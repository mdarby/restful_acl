module RestfulAclController

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
          # No object was requested, so we need to go to the URI to figure out the parent
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
          else check_non_restful_route(current_user, klass, object, parent)
        end

      rescue NoMethodError => e
        # Misconfiguration: A RESTful_ACL specific method is missing.
        raise_error(klass, e)
      rescue
        # Failsafe: If any funny business is going on, log and redirect
        routing_error
      end
    end

    private

      def check_non_restful_route(user, klass, object, parent)
        if object
          object.is_readable_by(user, parent)
        elsif klass
          klass.is_indexable_by(user, parent)
        else
          # If all else fails, deny access
          false
        end
      end

      def get_method_from_error(error)
        error.message.gsub('`', "'").split("'").at(1)
      end

      def raise_error(klass, error)
        method = get_method_from_error(error)
        message = (is_class_method?(method)) ? "#{klass}#self.#{method}" : "#{klass}##{method}"
        raise NoMethodError, "[RESTful_ACL] #{message}(user, parent = nil) seems to be missing?"
      end

      def is_class_method?(method)
        method =~ /(indexable|creatable)/
      end

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
        logger.info("[RESTful_ACL] Permission denied to %s at %s for %s" %
        [(logged_in? ? current_user.login : 'guest'), Time.now, request.request_uri])

        redirect_to denied_url
      end

      def routing_error
        logger.info("[RESTful_ACL] Routing error by %s at %s for %s" %
        [(logged_in? ? current_user.login : 'guest'), Time.now, request.request_uri])

        redirect_to error_url
      end

  end
end
