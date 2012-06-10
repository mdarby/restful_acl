module RestfulAcl
  class Base

    attr_accessor :object, :parent, :user, :controller_name, :uri, :action, :object_id


    def initialize(options)
      options.each{|(k,v)| instance_variable_set "@#{k}", v}
      (@object_id.present?) ? load_actors_from_id : load_actors_from_uri
    end

    def load_actors_from_id
      @object = object_class.find(@object_id.to_i)
      @parent = @object.get_mom if object_class.has_parent?
    end

    def load_actors_from_uri
      @parent = load_parent_from_uri if object_class.has_parent?
      @object = (object_class.is_singleton?) ? load_singleton_object : nil
    end

    def load_singleton_object
      @parent.send(object_class.to_s.tableize.singularize.to_sym)
    end

    def load_parent_from_uri
      parent_klass = object_class.mom.to_s
      bits         = @uri.split('/')
      parent_id    = bits.at(bits.index(parent_klass.pluralize).to_i + 1)

      if parent_id.to_i == 0
        look_for = /#{parent_klass}_id=(\d+)/
        @uri.match(look_for)
        parent_id = $1
      end

      parent_klass.classify.constantize.find(parent_id.to_i)
    end

    def object_class
      @object_class ||= @controller_name.classify.demodulize.constantize
    end

    def admin?
      @user.respond_to?("is_admin?") && @user.is_admin?
    end

    def allowed?
      return true if admin?

      case @action
        when "index"          then object_class.is_indexable_by(@user, @parent)
        when "new", "create"  then object_class.is_creatable_by(@user, @parent)
        when "show"           then @object.is_readable_by(@user, @parent)
        when "edit", "update" then @object.is_updatable_by(@user, @parent)
        when "destroy"        then @object.is_deletable_by(@user, @parent)
        else check_non_restful_route
      end
    end

    def check_non_restful_route
      if @object.present?
        @object.is_readable_by(@user, @parent)
      elsif object_class.present?
        object_class.is_indexable_by(@user, @parent)
      else
        false # If all else fails, deny access
      end
    end

  end
end