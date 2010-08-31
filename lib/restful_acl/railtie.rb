require 'restful_acl'

module RestfulAcl
  if defined? Rails::Railtie
    require 'rails'
    class Railtie < Rails::Railtie
      initializer 'restful_acl.insert_into_active_record' do
        ActiveSupport.on_load :active_record do
          RestfulAcl::Railtie.insert
        end
      end
    end
  end

  class Railtie
    def self.insert
      puts ">>>>>>>>>>"
      ActiveRecord::Base.send(:include, RestfulAcl::Model)
      ActionController::Base.send(:include, RestfulAcl::Controller)
      ActionView::Base.send(:include, RestfulAcl::Helper)
    end
  end
end