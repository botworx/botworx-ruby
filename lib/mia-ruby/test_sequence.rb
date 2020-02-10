
$LOAD_PATH << File.dirname(__FILE__)

require 'sequence'
require 'taskgroup'

task1 = Task.new do
  puts "I'm a parent task."
  sequence [
    lambda {|t| puts "I'm a spawned child task."},
    lambda {|t| puts "I'm a called child task."}
  ]
  end
end


group = TaskGroup.new

group.schedule task1

group.start
