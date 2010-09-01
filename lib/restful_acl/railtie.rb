require 'restful_acl'
require 'rails'

module RestfulAcl
  class Railtie < Rails::Railtie
    initializer 'restful_acl.insert' do
      ActiveRecord::Base.send(:include, RestfulAcl::Model)
      ActionController::Base.send(:include, RestfulAcl::Controller)
      ActionView::Base.send(:include, RestfulAcl::Helper)
    end
  end
end