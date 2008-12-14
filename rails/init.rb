require 'restful_acl'
require 'restful_acl_helper'

ActionController::Base.send :include, RestfulAcl
ActionView::Base.send :include, RestfulAclHelper

RAILS_DEFAULT_LOGGER.debug "** [RESTful_ACL] loaded"