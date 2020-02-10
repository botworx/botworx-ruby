
$LOAD_PATH << File.dirname(__FILE__)

require 'task'
require 'taskgroup'

task1 = Task.new do
  puts "I'm a parent task."
  spawn(Task.new do
    puts "I'm a spawned child task."
  end)
  call(Task.new do
    puts "I'm a called child task."
  end) do
  puts "And were back to the parent task!"
  end
end


group = TaskGroup.new

group.schedule task1

group.start