module RestfulAclController

  def self.included(base)
    base.extend(ClassMethods)
    base.send :include, ClassMethods
  end

  module ClassMethods

    attr_accessor :object, :parent, :klass, :user

    def has_permission?
      return true if administrator?

      load_actors(params[:id])

      begin
        # Let's let the Model decide what is acceptable
        permission_denied unless case params[:action]
          when "index"          then @klass.is_indexable_by(@user, @parent)
          when "new", "create"  then @klass.is_creatable_by(@user, @parent)
          when "show"           then @object.is_readable_by(@user, @parent)
          when "edit", "update" then @object.is_updatable_by(@user, @parent)
          when "destroy"        then @object.is_deletable_by(@user, @parent)
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
        @user = current_user

        # Load the Model based on the controller name
        @klass = self.controller_name.classify.demodulize.constantize

        if id.present?
          # Load the object and possible parent requested
          @object = @klass.find(params[:id])
          @parent = @object.get_mom if @klass.has_parent?
        else
          # No object was requested, so we need to go to the URI to figure out the parent
          @parent = get_mom_from_request_uri(@klass) if @klass.has_parent?

          if @klass.is_singleton?
            @object = @parent.send(@klass.to_s.tableize.singularize.to_sym)
          else
            # No object was requested (index, create actions)
            @object = nil
          end
        end
      end

      def check_non_restful_route
        if @object
          @object.is_readable_by(@user, @parent)
        elsif @klass
          @klass.is_indexable_by(@user, @parent)
        else
          false # If all else fails, deny access
        end
      end

      def get_method_from_error(error)
        error.message.gsub('`', "'").split("'").at(1)
      end

      def raise_error(error)
        method = get_method_from_error(error)
        message = (is_class_method?(method)) ? "#{@klass}#self.#{method}" : "#{@klass}##{method}"
        raise NoMethodError, "[RESTful_ACL] #{message}(user, parent = nil) seems to be missing?"
      end

      def is_class_method?(method)
        method =~ /[index|creat]able/
      end

      def get_mom_from_request_uri(child_klass)
        parent_klass = child_klass.mom.to_s
        bits         = request.request_uri.split('/')
        parent_id    = bits.at(bits.index(parent_klass.pluralize) + 1)

        parent_klass.classify.constantize.find(parent_id)
      end

      def administrator?
        @user.respond_to?("is_admin?") && @user.is_admin?
      end

      def blame
        @user.respond_to?(:login) ? @user.login : @user.username
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
