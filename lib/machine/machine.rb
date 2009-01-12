class MachineNotFoundError < StandardError; end

class Machine
  
  cattr_accessor :machines #:nodoc:
  self.machines = {}
  
  cattr_accessor :sequences #:nodoc:
  self.sequences = {}

  # An Array of strings specifying locations that should be searched for
  # machine definitions. By default, machine will attempt to require
  # "machines," "test/machines," and "spec/machines." Only the first
  # existing file will be loaded.
  cattr_accessor :definition_file_paths
  
  def self.find_definitions #:nodoc:
    definition_file_paths.each do |file_path|
      begin
        require(file_path)
        break
      rescue LoadError
      end
    end
  end
  
  # Defines a new machine that sets up the default attributes for new objects.
  #
  # Arguments:
  #   name: (Symbol)
  #     A unique name used to identify this machine.
  #   options: (Hash)
  #     class: (Class) the class that will be used when generating instances for this
  #            machine. If not specified, the class will be guessed from the 
  #            machine name.
  #     extends: (Symbol) the name of a machine that will be extended by this one.
  #              If provided, the attributes of the extended machine will be applied
  #              to the object before the one being defined.
  #
  # Yields:
  #    The object being created and an association helper
  #
  # Example:
  #
  #   Machine.define :car do |car, machine|
  #     car.make = 'GMC'
  #     car.model = 'S-15'
  #   end
  def self.define(name, options={}, &block)
    self.machines[name] = Machine.new(name, options, block)
  end

  # Defines a group of machines with a base set of attributes and then a set of
  # machines as children. This is useful as a namespacing technique or for any
  # case where you wish to define a set of objects that share a set of base
  # attributes.
  #
  # Arguments:
  #   name: (Symbol)
  #     A unique name to identify the group. This name will itself become a machine
  #     that will build from the base attributes.
  #   options: (Hash)
  #     class: (Class) the class that will be used when generating instances for this
  #            machine. If not specified, the class will be guessed from the 
  #            machine name.
  #
  # Example
  #
  #   Machine.define_group :user do |group|
  #     group.base do |user, machine|
  #       user.password = 'password'
  #       user.password_confirmation = 'password'
  #       user.login = Machine.next(:login)
  #       user.email = Machine.next(:email)
  #     end
  # 
  #     group.define :super_user do |user, machine|
  #       user.permissions = [machine.permission(:user => user)]
  #     end
  #   end
  #
  #   Machine.build(:user)
  #   Machine.build(:super_user)
  #
  def self.define_group(name, options={}, &block)
    group = MachineGroup.new(name, options)
    yield group
  end

  # Creates an unsaved object using the machine with the given name.
  #
  # Arguments:
  #   name: (Symbol)
  #     The name of the machine to apply.
  #   attributes: (Hash)
  #     A set of attributes to use as a replacement for the default ones provided by
  #     the machine.
  #
  # Example
  #
  #   Machine.build(:car, :model => 'Civic', :make => 'Honda')
  def self.build(name, attributes={})
    machines = machines_for(name)
    raise MachineNotFoundError if machines.empty?
    object = machines.shift.build(attributes)
    while machine = machines.shift
      machine.apply_to(object, attributes)
    end
    object
  end

  # Creates an saved object using the machine with the given name.
  #
  # Arguments:
  #   name: (Symbol)
  #     The name of the machine to apply.
  #   attributes: (Hash)
  #     A set of attributes to use as a replacement for the default ones provided by
  #     the machine.
  #
  # Example
  #
  #   Machine.build!(:car, :model => 'Civic', :make => 'Honda')  
  def self.build!(name, attributes={})
    result = build(name, attributes)
    result.save! if result.respond_to?(:save!)
    result
  end

  # Apply the machine with the given name to the provided object. This can
  # be used to load an existing object with the attributes defined in a machine.
  #
  # Arguments:
  #   name: (Symbol)
  #     The name of the machine to apply.
  #   object: (Object)
  #     The object whose attributes should be set.
  #   attributes: (Hash)
  #     A set of replacements attributes for those specified in the machine.
  #
  # Example
  #
  #   car = Car.new
  #   Machine.apply_to(:car, car, :model => 'Jetta')
  def self.apply_to(name, object, attributes={})
    machines = machines_for(name)
    return if machines.empty?
    while machine = machines.shift
      machine.apply_to(object, attributes)
    end
    object    
  end

  # Defines a new named sequence. Sequences can be used to set attributes
  # that must be unique. Once a sequence is created it can be applied by
  # calling Machine.next, passing the sequence name.
  #
  # Arguments:
  #   name: (Symbol)
  #     A unique name used to identify this sequence.
  #   block: (Proc)
  #     The code to generate each value in the sequence. This block will be
  #     called with a unique number each time a value in the sequence is to be
  #     generated. The block should return the generated value for the
  #     sequence.
  #
  # Example
  #
  #   Machine.sequence :street do |n|
  #     "#{n} Main St."
  #   end
  def self.sequence(name, &block)
    self.sequences[name] = Sequence.new(block)
  end

  # Get the next value produced by the sequence with the given name. This
  # can be used in machine definitions to fill in attributes that must be
  # unique.
  #
  # Arguments:
  #   sequence: (Symbol)
  #     The name of the sequence to use.
  #
  # Example
  #
  #   Machine.define :address do |address, machine|
  #     address.street = machine.next(:street)
  #   end
  def self.next(sequence)
    sequences[sequence].next if sequences.has_key?(sequence)
  end
  
  def initialize(name, options, proc) #:nodoc
    @name, @options, @proc = name, options, proc
  end
  
  def extends #:nodoc
    @options[:extends] ? machines[@options[:extends]] : nil
  end
  
  def build(attributes={}) #:nodoc
    object = build_class.new
    apply_to(object, attributes)
    object
  end

  def apply_to(object, attributes={}) #:nodoc
    @proc.call(object, AssociationHelper.new)
    attributes.each { |key, value| object.send("#{key}=", value) }
  end

  protected
  
  def build_class #:nodoc
    @options[:class] || @name.to_s.camelize.constantize
  end
  
  def self.machines_for(name) #:nodoc
    result = [machines[name]]
    while result.last
      result << result.last.extends
    end
    result.compact.reverse
  end
end
