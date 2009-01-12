require 'machine'

Machine.definition_file_paths = [
  File.join(RAILS_ROOT, 'machines'),
  File.join(RAILS_ROOT, 'test', 'machines'),
  File.join(RAILS_ROOT, 'spec', 'machines')
]

# Find the definitions in the default locations:
# machines.rb
# test/machines.rb
# spec/machines.rb
Machine.find_definitions
