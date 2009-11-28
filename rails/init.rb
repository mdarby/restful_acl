require 'restful_acl'

ActionController::Base.send :include, RestfulAcl::Controller
ActionView::Base.send :include, RestfulAcl::Helper
ActiveRecord::Base.send :include, RestfulAcl::Model

RAILS_DEFAULT_LOGGER.debug "** [RESTful_ACL] loaded"