module RestfulAcl
  module Helper

    def allowed?(&block)
      options = UrlParser.new(current_user, &block).options_hash
      access = RestfulAcl::Base.new(options)

      yield if access.allowed?
    end

    %w{creat delet updat read}.each do |m|
      define_method("#{m}able?") do |*args, &block|
        RAILS_DEFAULT_LOGGER.error <<-STR

          *****************************************************************************************
          * RESTful_ACL error => ##{m}able? has been removed as of v3.0.0, please use #allowable?
          *****************************************************************************************

        STR
      end
    end

  end
end
