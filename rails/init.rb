require 'restful_acl_controller'
require 'restful_acl_helper'
require 'restful_acl_model'

ActionController::Base.send :include, RestfulAclController
ActionView::Base.send :include, RestfulAclHelper
ActiveRecord::Base.send :include, RestfulAclModel

RAILS_DEFAULT_LOGGER.debug "** [RESTful_ACL] loaded"