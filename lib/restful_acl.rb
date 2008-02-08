# RestfulAcl

module RestfulAcl
  
  def self.included(base)
    base.extend(ClassMethods)
    base.send :include, ClassMethods
  end
  
  module ClassMethods
    
    def has_permission?
      public_urls = %w{/login /logout /session /denied /error}
      check_access unless public_urls.include?(request.request_uri)
    end


    protected
    
    def check_access
      begin
        # Load the Model based on the controller name passed in
        klass = Object.const_get(params[:controller].classify)
    
        # Load the object requested if the param[:id] exists
        object = klass.find(params[:id]) unless params[:id].blank?
       
        # Let's let the Model decide what is acceptable
        access_granted = case params[:action]
          when "index":   klass.is_readable_by(current_user)
          when "show":    klass.is_readable_by(current_user, object)
          when "edit":    object.is_updatable_by(current_user)
          when "update":  object.is_updatable_by(current_user)
          when "new":     klass.is_creatable_by(current_user)
          when "create":  klass.is_creatable_by(current_user)
          when "destroy": klass.is_deletable_by(current_user)
        end   

        permission_denied unless access_granted
    
      rescue
        # Failsafe: If any funny business is going on, log and redirect
        routing_error_occurred
      end
    end

    def permission_denied
      logger.info("[ACL] Permission denied to %s at %s for %s" %
      [(logged_in? ? current_user.login : 'guest'), Time.now, request.request_uri])
  
      redirect_to denied_url
    end

    def routing_error_occurred
      logger.info("[ACL] Routing error by %s at %s for %s" %
      [(logged_in? ? current_user.login : 'guest'), Time.now, request.request_uri])
  
      redirect_to error_url
    end
  end
end