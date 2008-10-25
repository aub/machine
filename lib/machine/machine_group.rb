class MachineGroup
  
  def initialize(name, options={})
    @name = name
    @options = options
  end
  
  def base(&block)
    @base_machine = Machine.new(@name, @options, block)
    Machine.machines[@name] = @base_machine
  end
  
  def define(name, &block)
    if @base_machine
      options = @options.merge(:extends => @name)
    else
      options = @options.merge(:class => (@options[:class] || @name.to_s.camelize.constantize))
    end
    machine = Machine.new(name, options, block)
    Machine.machines[name] = machine
  end
end