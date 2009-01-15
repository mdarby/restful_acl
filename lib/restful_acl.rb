module RestfulAcl

  def self.included(base)
    base.extend(ClassMethods)
    base.send :include, ClassMethods
  end

  module ClassMethods

    def has_permission?
      return true if administrator?

      begin
        # Load the Model based on the controller name
        klass = self.controller_name.classify.constantize

        if params[:id]
          # Load the object and possible parent requested
          object = klass.find(params[:id])
          parent = object.get_mom rescue nil
        else
          object = nil
          parent = get_parent_from_request_uri(klass) if klass.has_parent?
        end

        # Let's let the Model decide what is acceptable
        permission_denied unless case params[:action]
          when "index"          then klass.is_indexable_by(current_user, parent)
          when "new", "create"  then klass.is_creatable_by(current_user, parent)
          when "show"           then object.is_readable_by(current_user, parent)
          when "edit", "update" then object.is_updatable_by(current_user, parent)
          when "destroy"        then object.is_deletable_by(current_user, parent)
          else object.is_readable_by(current_user, parent)
        end

      rescue
        # Failsafe: If any funny business is going on, log and redirect
        routing_error
      end
    end

    private

      def get_parent_from_request_uri(child_klass)
        parent_klass = child_klass.mom.to_s
        bits         = request.request_uri.split('/')
        parent_id    = bits.at(bits.index(parent_klass.pluralize) + 1)

        parent_klass.classify.constantize.find(parent_id)
      end

      def administrator?
        current_user.respond_to?("is_admin?") && current_user.is_admin?
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
