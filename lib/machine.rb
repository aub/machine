require 'machine/association_helper'
require 'machine/machine'
require 'machine/machine_group'
require 'machine/sequence'

# Shorthand method for building a machine, is an alias for Machine.build(name, attributes)
def Machine(name, attributes={}, &block)
  Machine.build(name, attributes, &block)
end

# And the same drill for building a machine and saving the result.
def Machine!(name, attributes={}, &block)
  Machine.build!(name, attributes, &block)
end

