
$LOAD_PATH << File.dirname(__FILE__)

require 'plan'
require 'taskgroup'

task1 = Plan.define do
  puts "I'm a parent task."
  spawn(Task.define do
    puts "I'm a spawned child task."
  end)
  callcc(Task.define do
    puts "I'm a callcc-ed child task."
  end)
  puts "And were back to the parent task!"
end


group = TaskGroup.new

group.schedule task1

group.start