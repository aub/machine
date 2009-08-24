# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{machine}
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Aubrey Holland"]
  s.date = %q{2009-08-24}
  s.description = %q{machine is an implementation of the factory pattern for creating model objects when testing Ruby apps. It borrows concepts from factory_girl, but has a different implementation for associations.}
  s.email = %q{aubreyholland@gmail.com}
  s.extra_rdoc_files = [
    "README.textile"
  ]
  s.files = [
    ".gitignore",
     "README.textile",
     "Rakefile",
     "TODO.textile",
     "VERSION.yml",
     "lib/machine.rb",
     "lib/machine/association_helper.rb",
     "lib/machine/machine.rb",
     "lib/machine/machine_group.rb",
     "lib/machine/sequence.rb",
     "machine.gemspec",
     "rails/init.rb",
     "test/machine_group_test.rb",
     "test/machine_test.rb",
     "test/models.rb",
     "test/sequence_test.rb",
     "test/test.db",
     "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/aub/machine}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{machine is an implementation of the factory pattern for creating model objects when testing Ruby apps}
  s.test_files = [
    "test/machine_group_test.rb",
     "test/machine_test.rb",
     "test/models.rb",
     "test/sequence_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
