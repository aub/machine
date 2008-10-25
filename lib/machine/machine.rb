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
  self.definition_file_paths = %w(machines test/machines spec/machines)
  
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
  def self.define(name, options={}, &block)
    self.machines[name] = Machine.new(name, options, block)
  end

  def self.define_group(name, options={}, &block)
    group = MachineGroup.new(name, options)
    yield group
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
  def self.sequence(name, &block)
    self.sequences[name] = Sequence.new(block)
  end
  
  def self.build(name, attributes={})
    machines = machines_for(name)
    return nil if machines.empty?
    object = machines.shift.build(attributes)
    while machine = machines.shift
      machine.apply_to(object, attributes)
    end
    object
  end

  def self.build!(name, attributes={})
    result = build(name, attributes)
    result.save! if result.respond_to?(:save!)
    result
  end
  
  def self.apply_to(name, object, attributes={})
    machines = machines_for(name)
    return if machines.empty?
    while machine = machines.shift
      machine.apply_to(object, attributes)
    end
    object    
  end
  
  def self.next(sequence)
    sequences[sequence].next if sequences.has_key?(sequence)
  end
  
  def initialize(name, options, proc)
    @name, @options, @proc = name, options, proc
  end
  
  def extends
    @options[:extends] ? machines[@options[:extends]] : nil
  end
  
  def build(attributes={})
    object = build_class.new
    apply_to(object, attributes)
    object
  end

  def apply_to(object, attributes={})
    @proc.call(object, AssociationHelper.new)
    attributes.each { |key, value| object.send("#{key}=", value) }
  end

  protected
  
  def build_class
    @options[:class] || @name.to_s.camelize.constantize
  end
  
  def self.machines_for(name)
    result = [machines[name]]
    while result.last
      result << result.last.extends
    end
    result.compact.reverse
  end
end
  