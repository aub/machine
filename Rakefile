require 'rubygems'
require 'rake'
require 'rake/testtask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "machine"
    gemspec.summary = "machine is an implementation of the factory pattern for creating model objects when testing Ruby apps"
    gemspec.description = "machine is an implementation of the factory pattern for creating model objects when testing Ruby apps. It borrows concepts from factory_girl, but has a different implementation for associations."
    gemspec.email = "aubreyholland@gmail.com"
    gemspec.homepage = "http://github.com/aub/machine"
    gemspec.authors = ["Aubrey Holland"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the machine.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

# Try to use hanna to create spiffier docs.
begin
  require 'hanna/rdoctask'
rescue LoadError
  require 'rake/rdoctask'
end

Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "machine #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.options << '--webcvs=http://github.com/aub/machine/tree/master/'
end

