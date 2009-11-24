require 'restful_acl'

ActionController::Base.send :include, RestfulAclController
ActionView::Base.send :include, RestfulAclHelper
ActiveRecord::Base.send :include, RestfulAclModel

RAILS_DEFAULT_LOGGER.debug "** [RESTful_ACL] loaded"