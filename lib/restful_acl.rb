module RestfulAcl
  
  def self.included(base)
    base.extend(ClassMethods)
    base.send :include, ClassMethods
  end
  
  module ClassMethods

    def has_permission?
      return true if current_user.respond_to?("is_admin?") && current_user.is_admin? # Admins rule.
      
      begin
        # Load the Model based on the controller name
        klass = self.controller_name.classify.constantize

        # Load the object requested if the param[:id] exists
        object = klass.find(params[:id]) unless params[:id].blank?
            
        # Let's let the Model decide what is acceptable
        permission_denied unless case params[:action] 
          when "index"          then klass.is_readable_by(current_user)
          when "show"           then klass.is_readable_by(current_user, object)
          when "edit", "update" then object.is_updatable_by(current_user)
          when "destroy"        then object.is_deletable_by(current_user)
          when "new", "create"  then creatable_action(klass)            
          else klass.is_readable_by(current_user)
        end
      
      rescue
        # Failsafe: If any funny business is going on, log and redirect
        routing_error
      end
    end


    private

    def creatable_action(klass)
      begin
        parent_object = get_parent_resource(klass, request.request_uri)
        klass.is_creatable_by(current_user, parent_object)
      rescue
        issue_is_creatable_by_deprecation_warning(klass)
      end
    end

    def issue_is_creatable_by_deprecation_warning(klass)
      logger.info <<-END
        [RESTful_ACL] -- *Deprecation Warning!*"
        RESTful_ACL's #is_creatable_by method now requires an extra parameter.
        Please update your model's #is_creatable_by method to the following format:

        def self.is_creatable_by(user, parent_object = nil)
          ...
        end
        
        Offending class: #{klass}
        
        Please see the http://github.com/mdarby/restful_acl for further info
        
      END
      
      false
    end

    def get_parent_resource(target_klass, path)
      # Convert the requested path into hash form
      hash = ActionController::Routing::Routes.recognize_path(path, :method => :get)
      
      # Loop through path keys and see if any end in '_id' and our kid class belongs_to the associated AR Class
      pair = hash.detect{|k, v| k.to_s.ends_with?("_id") && target_klass.columns_hash.has_key?(k.to_s)}
      
      # Load up the AR class based on the matching path pair
      klass = pair[0].to_s[0...-3].classify.constantize
      
      # Find and return the target parent object
      klass.find(pair[1])
    end

    def permission_denied
      logger.info("[ACL] Permission denied to %s at %s for %s" %
      [(logged_in? ? current_user.login : 'guest'), Time.now, request.request_uri])
  
      redirect_to denied_url
    end

    def routing_error
      logger.info("[ACL] Routing error by %s at %s for %s" %
      [(logged_in? ? current_user.login : 'guest'), Time.now, request.request_uri])
  
      redirect_to error_url
    end
  
  end
end
