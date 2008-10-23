class AssociationHelper
  
  def initialize
    
  end
  
  def method_missing(name, *args)
    if Machine.machines.has_key?(name)
      Machine.machines[name].build(*args)
    end
  end  
end