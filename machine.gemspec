Gem::Specification.new do |s|
  s.version = "0.1.0"
  s.date = %q{2008-10-23}
 
  s.name = %q{machine}
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["patch", "Aubrey Holland"]
  s.description = %q{Machine crunches factories.}
  s.email = %q{aubrey@patch.com}
  s.files = ["lib/machine", "lib/machine/association_helper.rb", "lib/machine/machine.rb", "lib/machine/sequence.rb", "lib/machine/version.rb", "lib/machine.rb", "machine.gemspec", "rails/init.rb", "Rakefile", "README.textile", "test/machine_test.rb", "test/models.rb", "test/sequence_test.rb", "test/test.db", "test/test_helper.rb", "TODO.textile"]
  s.homepage = %q{http://github.com/patch/machine}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Machine crunches factories.}
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.textile"]
  s.rdoc_options = ["--line-numbers", "--inline-source", "--main", "README.textile"]
  s.test_files = ["test/machine_test.rb", "test/sequence_test.rb"]
  
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2
  end
end
