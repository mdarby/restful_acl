require 'restful_acl'
require 'restful_acl_helper'
require 'restful_acl_model'

ActionController::Base.send :include, RestfulAcl
ActionView::Base.send :include, RestfulAclHelper
ActiveRecord::Base.send :include, RestfulAclModel

RAILS_DEFAULT_LOGGER.debug "** [RESTful_ACL] loaded"