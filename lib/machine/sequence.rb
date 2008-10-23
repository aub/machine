class Sequence
  
  def initialize(proc)
    @proc, @current_value = proc, 0
  end
  
  def next
    @current_value += 1
    @proc.call(@current_value)
  end
  
end