require 'machine/association_helper'
require 'machine/machine'
require 'machine/machine_group'
require 'machine/sequence'

# Find the definitions in the default locations:
# machines.rb
# test/machines.rb
# spec/machines.rb
Machine.find_definitions

# Shorthand method for building a machine, is an alias for Machine.build(name, attributes)
def Machine(name, attributes={})
  Machine.build(name, attributes)
end