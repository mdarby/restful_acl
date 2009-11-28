module RestfulAcl
  module Helper

    def allowed?(&block)
      options = UrlParser.new(current_user, &block).options_hash
      access = RestfulAcl::Base.new(options)

      yield if access.allowed?
    end

  end
end