
$LOAD_PATH << File.dirname(__FILE__)

require 'parallel'
require 'taskgroup'
require 'whilst'
require 'fibertask'

task1 = Parallel.define do
  #spawn(Task.define do
  spawn(task do
    count = 0
    #call(Whilst.define(->{count < 10}) do
    call(whilst(->{count < 10}) do
      puts count
      count += 1
    end) do
    puts 'done counting'
    end
  end)
  spawn(Task.define do
    puts "I'm child task 2."
  end)
  spawn(fibertask do
    ('a'..'z').each do |l|
      puts l
      Fiber.yield again
    end
  end)
end

group = TaskGroup.new

group.schedule task1

group.start