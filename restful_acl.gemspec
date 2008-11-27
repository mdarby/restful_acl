Gem::Specification.new do |s|
  s.name     = "restful_acl"
  s.version  = "1.0"
  s.date     = "2008-11-27"
  s.summary  = "Object-level access control"
  s.email    = "matt@matt-darby.com"
  s.homepage = "http://github.com/mdarby/restful_acl/tree/master"
  s.description = "A Rails gem that provides fine grained access control to RESTful resources in a Rails 2.0+ project."
  s.has_rdoc = true
  s.authors  = ["Matt Darby"]
  s.files    = ["MIT-LICENSE",
  "README",
  "Rakefile",
  "init.rb",
  "install.rb",
  "lib/restful_acl.rb",
  "lib/restful_acl_helper.rb",
  "tasks/restful_acl_tasks.rake",
  "uninstall.rb",]
  s.test_files = ["test/restful_acl_test.rb"]
end
