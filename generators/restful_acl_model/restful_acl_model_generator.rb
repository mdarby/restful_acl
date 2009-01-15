class RestfulAclGenerator < Rails::Generator::NamedBase

  def initialize(*runtime_args)
    super(*runtime_args)
  end

  def manifest
    record do |m|
      install_routes(m)

      m.directory(File.join('app/models'))
      m.directory(File.join('db/migrate'))

      m.template "restful_acl.rb", File.join('app/models', "#{table_name.singularize}.rb")
      m.template "restful_acl_vote.rb", File.join('app/models', "#{table_name.singularize}_vote.rb")

      # Migrations
      m.migration_template "create_RestfulAcl_tables.rb", "db/migrate", :migration_file_name => "create_RestfulAcl_tables"

    end
  end

  def table_name
    class_name.tableize
  end

  def model_name
    class_name.demodulize
  end

  def object_name
    table_name.singularize
  end

  def install_routes(m)
    m.route_resources ":#{table_name}"
  end


  protected

    def banner
      "Usage: #{$0} #{spec.name} ModelName <optional: ParentModel>"
    end

end