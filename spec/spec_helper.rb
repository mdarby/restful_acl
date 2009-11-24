$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'restful_acl'
require 'spec'
require 'widgets'

Spec::Runner.configure do |config|
  
end