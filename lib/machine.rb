require 'machine/association_helper'
require 'machine/machine'
require 'machine/sequence'

Machine.find_definitions

def Machine(name, attributes={})
  Machine.build(name, attributes)
end