$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'restful_acl'
require 'spec'
require 'spec/autorun'
require 'rubygems'
require 'activesupport'

Spec::Runner.configure do |config|

  def url(path)
    "<a href=\"#{path}\" target=\"_blank\" alt=\"foo\">#{path}</a>"
  end

  def destroy_url(path)
    "<a href=\"#{path}\" data-method=\"delete\">Delete Image</a>"
  end

  def ajax_url(path)
    "<a href=\"#{path}\" data-remote=\"true\">AJAX</a>"
  end

end
