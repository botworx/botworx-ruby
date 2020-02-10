
require 'message'

class Trigger

  def initialize msg, &block
    @msg = msg
    @block = block
  end
  
  def match msg
    @msg == msg
  end
  
end