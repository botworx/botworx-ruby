require 'task'
require 'scheduler'

class TaskGroup < Scheduler
 
  def initialize(action = nil)
    super(action)
    @posts = []
  end
  
  def post(msg)
    @posts << msg
  end
  
  def schedule(task)
    super(task)
    task.group = self
  end
  
end