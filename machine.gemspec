Gem::Specification.new do |s|
  s.version = '1.0.0'
  s.date = %q{2008-11-07}
 
  s.name = %q{machine}
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.authors = ['Aubrey Holland', 'patch']
  s.description = %q{machine defines a factory system for creating model objects to replace fixtures in Ruby apps.}
  s.email = %q{aubrey@patch.com}
  s.files = ['lib', 'lib/machine', 'lib/machine/association_helper.rb', 'lib/machine/machine.rb', 'lib/machine/machine_group.rb', 'lib/machine/sequence.rb', 'lib/machine.rb', 'machine-1.0.0.gem', 'machine.gemspec', 'rails', 'rails/init.rb', 'Rakefile', 'README.textile', 'test', 'test/machine_group_test.rb', 'test/machine_test.rb', 'test/models.rb', 'test/sequence_test.rb', 'test/test.db', 'test/test_helper.rb', 'TODO.textile']
  s.homepage = %q{http://github.com/aub/machine/tree/master}
  s.require_paths = ['lib']
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Machine crunches factories.}
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.textile']
  s.rdoc_options = ['--line-numbers', '--inline-source', '--main', 'README.textile']
  s.test_files = ['test/machine_test.rb', 'test/machine_group_test.rb', 'test/sequence_test.rb']
  
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2
  end
end
