class MachineGroup
  
  def initialize(name, options={}) #:nodoc
    @name = name
    @options = options
  end
  
  def base(&block) #:nodoc
    @base_machine = Machine.new(@name, @options, block)
    Machine.machines[@name] = @base_machine
  end
  
  def define(name, &block) #:nodoc
    if @base_machine
      options = @options.merge(:extends => @name)
    else
      options = @options.merge(:class => (@options[:class] || @name.to_s.camelize.constantize))
    end
    machine = Machine.new(name, options, block)
    Machine.machines[name] = machine
  end
end