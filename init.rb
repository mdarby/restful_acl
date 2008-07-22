require_dependency 'restful_acl'
require_dependency 'restful_acl_helper'

ActionController::Base.send :include, RestfulAcl
ActionView::Base.send :include, RestfulAclHelper