class Sequence
  
  def initialize(proc) #:nodoc
    @proc, @current_value = proc, 0
  end
  
  def next #:nodoc
    @current_value += 1
    @proc.call(@current_value)
  end
  
end