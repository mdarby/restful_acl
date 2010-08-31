module RestfulAcl
  module Controller

    def self.included(base)
      base.extend(ClassMethods)
      base.send :include, ClassMethods
    end

    module ClassMethods

      def has_permission?
        options = {
          :controller_name => self.controller_name,
          :object_id       => params[:id],
          :uri             => request.fullpath,
          :user            => current_user,
          :action          => params[:action]
        }

        permission_denied unless RestfulAcl::Base.new(options).allowed?
      end


      private

        def permission_denied
          logger.info("[RESTful_ACL] Permission denied to %s at %s for %s" % [blame, Time.now, request.fullpath])
          redirect_to denied_url
        end

        def blame
          (@current_user.present?) ? "User ##{@current_user.id}" : "GUEST"
        end

    end

  end
end
