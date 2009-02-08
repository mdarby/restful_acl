Gem::Specification.new do |s|
  s.name     = "restful_acl"
  s.version  = "2.0.6"
  s.date     = "2009-02-07"
  s.summary  = "Object-level access control"
  s.email    = "matt@matt-darby.com"
  s.homepage = "http://github.com/mdarby/restful_acl"
  s.description = "A Rails gem that provides fine grained access control to RESTful resources in a Rails 2.0+ application."
  s.has_rdoc = false
  s.authors  = ["Matt Darby"]
  s.files    = [
    "MIT-LICENSE",
    "README.textile",
    "Rakefile",
    "init.rb",
    "install.rb",
    "lib/restful_acl_controller.rb",
    "lib/restful_acl_helper.rb",
    "lib/restful_acl_model.rb",
    "rails/init.rb",
    "uninstall.rb"
  ]
end
