
class Scheduler < Task

  def initialize(action)
    super(action)
    @tasks = []
  end
  
  def schedule(task)
    @tasks << task
  end
  
  def start
    #resume
    #while @tasks.length != 0
    #  resume
    #end
    while resume; end
  end
  
  def resume
    if @action
      super()
      @action = nil
    end
    task = @tasks.shift
    if not task
      return
    end
    
    begin
      status = task.resume
    rescue Escape
    end
    #catch(:escape){status = task.resume}
    
    puts "Status:  #{status}"
    
    case status
    when nil
      if task.parent
        schedule task.parent
      end
    when :running
      schedule task     
    end
    
    if @tasks.length != 0
      again
    end
  end
  
end