module RestfulAcl
  
  def self.included(base)
    base.extend(ClassMethods)
    base.send :include, ClassMethods
  end
  
  module ClassMethods
    
    def has_permission?
      # Load the Model based on the controller name passed in
      klass = Object.const_get(params[:controller].classify)
      
      # Load the object requested if the param[:id] exists
      object = klass.find(params[:id]) unless params[:id].blank?
      
      # Let's let the Model decide what is acceptable
      permission_denied unless case params[:action] 
        when "index"          then klass.is_readable_by(current_user)
        when "show"           then klass.is_readable_by(current_user, object)
        when "edit", "update" then object.is_updatable_by(current_user)
        when "new", "create"  then klass.is_creatable_by(current_user)
        when "destroy"        then object.is_deletable_by(current_user)
        else klass.is_readable_by(current_user)
      end
      
    rescue
      # Failsafe: If any funny business is going on, log and redirect
      routing_error
    end


    private

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