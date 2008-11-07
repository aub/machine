class AssociationHelper
  
  def initialize #:nodoc
    
  end
  
  def next(sequence) #:nodoc
    Machine.next(sequence)
  end
  
  def method_missing(name, *args) #:nodoc
    if Machine.machines.has_key?(name)
      Machine.machines[name].build(*args)
    end
  end  
end