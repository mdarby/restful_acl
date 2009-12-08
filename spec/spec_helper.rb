$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'restful_acl'
require 'spec'
require 'spec/autorun'
require 'rubygems'
require 'activesupport'

Spec::Runner.configure do |config|
  
  def url(path)
    "<a href=\"#{path}\">#{path}</a>"
  end
  
end