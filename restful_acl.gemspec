# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{restful_acl}
  s.version = "3.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt Darby"]
  s.date = %q{2009-12-08}
  s.description = %q{A Ruby on Rails plugin that provides fine grained access control to RESTful resources.}
  s.email = %q{matt@matt-darby.com}
  s.extra_rdoc_files = [
    "README.textile"
  ]
  s.files = [
    ".gitignore",
     "MIT-LICENSE",
     "README.textile",
     "Rakefile",
     "VERSION",
     "init.rb",
     "lib/restful_acl.rb",
     "lib/restful_acl/base.rb",
     "lib/restful_acl/controller.rb",
     "lib/restful_acl/errors.rb",
     "lib/restful_acl/helper.rb",
     "lib/restful_acl/model.rb",
     "lib/restful_acl/string.rb",
     "lib/restful_acl/url_parser.rb",
     "rails/init.rb",
     "restful_acl.gemspec",
     "spec/lib/url_parser.rb",
     "spec/spec_helper.rb",
     "uninstall.rb"
  ]
  s.homepage = %q{http://github.com/mdarby/restful_acl}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A Ruby on Rails plugin that provides fine grained access control to RESTful resources.}
  s.test_files = [
    "spec/lib/url_parser.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
  end
end

