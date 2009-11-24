Gem::Specification.new do |s|
  s.name        = "restful_acl"
  s.version     = "2.1"
  s.date        = "2009-11-23"
  s.summary     = "Object-level access control"
  s.email       = "matt@matt-darby.com"
  s.homepage    = "http://github.com/mdarby/restful_acl"
  s.description = "A Rails gem that provides fine grained access control to RESTful resources."
  s.has_rdoc    = false
  s.authors     = ["Matt Darby"]
  s.files       = [
    "LICENSE",
    "README.textile",
    "Rakefile",
    "init.rb",
    "lib/controller.rb",
    "lib/helper.rb",
    "lib/model.rb",
    "rails/init.rb",
    "restful_acl.gemspec",
    "spec/restful_acl_spec.rb",
    "spec/spec.opts",
    "spec/spec_helper.rb",
    "spec/widgets.rb"
  ]
end