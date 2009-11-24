module RestfulAclController

  def self.included(base)
    base.extend(ClassMethods)
    base.send :include, ClassMethods
  end

  module ClassMethods

    attr_accessor :restful_object, :restful_parent, :restful_klass, :restful_user

    def has_permission?
      return true if administrator?

      load_actors(params[:id])

      begin
        # Let's let the Model decide what is acceptable
        permission_denied unless case params[:action]
          when "index"          then @restful_klass.is_indexable_by(@restful_user, @restful_parent)
          when "new", "create"  then @restful_klass.is_creatable_by(@restful_user, @restful_parent)
          when "show"           then @restful_object.is_readable_by(@restful_user, @restful_parent)
          when "edit", "update" then @restful_object.is_updatable_by(@restful_user, @restful_parent)
          when "destroy"        then @restful_object.is_deletable_by(@restful_user, @restful_parent)
          else check_non_restful_route
        end

      rescue NoMethodError => e
        # Misconfiguration: A RESTful_ACL specific method is missing.
        raise_error(e)
      rescue
        # Failsafe: If any funny business is going on, log and redirect
        routing_error
      end
    end

    private

      def load_actors(id)
        @restful_user = current_user

        # Load the Model based on the controller name
        @restful_klass = self.controller_name.classify.demodulize.constantize

        if id.present?
          # Load the object and possible parent requested
          @restful_object = @restful_klass.find(params[:id])
          @restful_parent = @restful_object.get_mom if @restful_klass.has_parent?
        else
          # No object was requested, so we need to go to the URI to figure out the parent
          @restful_parent = get_morestful_frorestful_request_uri(@restful_klass) if @restful_klass.has_parent?

          if @restful_klass.is_singleton?
            @restful_object = @restful_parent.send(@restful_klass.to_s.tableize.singularize.to_sym)
          else
            # No object was requested (index, create actions)
            @restful_object = nil
          end
        end
      end

      def check_non_restful_route
        if @restful_object
          @restful_object.is_readable_by(@restful_user, @restful_parent)
        elsif @restful_klass
          @restful_klass.is_indexable_by(@restful_user, @restful_parent)
        else
          false # If all else fails, deny access
        end
      end

      def get_method_frorestful_error(error)
        error.message.gsub('`', "'").split("'").at(1)
      end

      def raise_error(error)
        method = get_method_frorestful_error(error)
        message = (is_class_method?(method)) ? "#{@restful_klass}#self.#{method}" : "#{@restful_klass}##{method}"
        raise NoMethodError, "[RESTful_ACL] #{message}(user, parent = nil) seems to be missing?"
      end

      def is_class_method?(method)
        method =~ /[index|creat]able/
      end

      def get_morestful_frorestful_request_uri(child_klass)
        parent_klass = child_klass.mom.to_s
        bits         = request.request_uri.split('/')
        parent_id    = bits.at(bits.index(parent_klass.pluralize) + 1)

        parent_klass.classify.constantize.find(parent_id)
      end

      def administrator?
        @restful_user.respond_to?("is_admin?") && @restful_user.is_admin?
      end

      def blame
        @restful_user.respond_to?(:login) ? @restful_user.login : @restful_user.username
      end

      def permission_denied
        logger.info("[RESTful_ACL] Permission denied to %s at %s for %s" % [(logged_in? ? blame : 'guest'), Time.now, request.request_uri])
        redirect_to denied_url
      end

      def routing_error
        logger.info("[RESTful_ACL] Routing error by %s at %s for %s" % [(logged_in? ? blame : 'guest'), Time.now, request.request_uri])
        redirect_to error_url
      end

  end

end
