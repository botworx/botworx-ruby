require 'fiber'
require 'task'

class FiberTask < Task

  def initialize(action = nil)
    super(action)
    @fiber = Fiber.new do
      instance_eval &@action
    end
  end
  
  def resume
    @fiber.resume
  end
  
end

def fibertask &action
  FiberTask.new action
end
