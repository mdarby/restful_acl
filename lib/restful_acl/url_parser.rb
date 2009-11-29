# This class takes a User and block of text containing a URL and deduces the requested action
# and any object that that action will be taken upon.
#
# Author:: Matt Darby (mailto:matt@matt-darby.com)
# Copyright:: Copyright(c) 2009 Matt Darby
# License:: MIT

class UrlParser

  TypesOfURLs = [
    {:name => "parent_with_specific_child", :controller_bit => 3, :object_id_bit => 4,   :regex => /\/(\w+)\/(\d+)[\w-]*\/(\w+)\/(\d+)[\w-]*$/},
    {:name => "parent_with_edit_child",     :controller_bit => 3, :object_id_bit => 4,   :regex => /\/(\w+)\/(\d+)[\w-]*\/(\w+)\/(\d+)[\w-]*\/edit$/},
    {:name => "parent_with_child_index",    :controller_bit => 3, :object_id_bit => nil, :regex => /\/(\w+)\/(\d+)[\w-]*\/(\w+)$/},
    {:name => "parent_with_new_child",      :controller_bit => 3, :object_id_bit => nil, :regex => /\/(\w+)\/(\d+)[\w-]*\/(\w+)\/new$/},
    {:name => "edit_singleton_child",       :controller_bit => 3, :object_id_bit => nil, :regex => /\/(\w+)\/(\d+)[\w-]*\/(\w+)\/edit$/},
    {:name => "new_singleton_child",        :controller_bit => 3, :object_id_bit => nil, :regex => /\/(\w+)\/(\d+)[\w-]*\/(\w+)\/new$/},
    {:name => "edit_parent",                :controller_bit => 1, :object_id_bit => 2,   :regex => /\/(\w+)\/edit$/},
    {:name => "new_parent",                 :controller_bit => 1, :object_id_bit => nil, :regex => /\/(\w+)\/new$/},
    {:name => "specific_parent",            :controller_bit => 1, :object_id_bit => 2,   :regex => /\/(\w+)\/(\d+)[\w-]*$/},
    {:name => "parent_index",               :controller_bit => 1, :object_id_bit => nil, :regex => /\/(\w+)$/}
  ]

  URL        = /href="([\w\/-]+)"/
  AJAXURL    = /url:'([\w\/-]+)'/
  NewURL     = /\/new$/
  EditURL    = /\/edit$/
  ObjectURL  = /\/(\d+)[\w-]*$/
  DestroyURL = /.*m\.setAttribute\('value', 'delete'\).*/

  attr_accessor :text, :user, :url

  # Dynamically define methods based off of TypesOfURLs hash
  TypesOfURLs.each do |type|
    define_method(type[:name]) do |url, controller_bit, object_id_bit, regex|
      data            = regex.match(url)
      controller_name = data[controller_bit]
      object_id       = (object_id_bit.present?) ? data[object_id_bit] : nil
      action          = requested_action(controller_name)

      {
        :controller_name => controller_name,
        :object_id       => object_id,
        :action          => action,
        :uri             => requested_url,
        :user            => @user
      }
    end
  end


  def initialize(user, &block)
    @text = yield
    @user = user
    @url  = requested_url
  end

  # Parse a URL and return a hash suitable for usage with RESTful_ACL
  # * :controller_name => The requested action's controller's name,
  # * :object_id       => The requested ID of the object in question (nil when Index, New, Create actions),
  # * :action          => The requested RESTful action (index, show, etc.),
  # * :uri             => The requested URL,
  # * :user            => The current user (used for context in RESTful_ACL)
  def options_hash
    invoke_url_type_method(deduce_url_type)
  end


  private

    # Call the dynamically created method with arguments from deduced hash
    def invoke_url_type_method(type)
      send(type[:name], @url, type[:controller_bit], type[:object_id_bit], type[:regex])
    end

    # Deduce the requested URL's "type" based on the TypesOfURLs hash
    def deduce_url_type
      TypesOfURLs.detect{|type| type[:regex].match(@url)}
    end

    # Find the requested URL out of the text block received
    def requested_url
      link = case @text
        when URL then URL.match(@text)[1]
        when AJAXURL then AJAXURL.match(@text)[1]
        else raise RestfulAcl::UnrecognizedURLError, "'#{@text}' doesn't seem to contain a valid URL?"
      end
    end

    # Deduce the requested action based on URL type
    # (or text block as :destroy links are defined via javascript)
    def requested_action(controller_name)
      return "destroy" if @text =~ DestroyURL

      case @url
        when EditURL then "edit"
        when NewURL then "new"
        when ObjectURL || controller_name.singular? then "show"
        else "index"
      end
    end

end
