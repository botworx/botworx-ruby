$LOAD_PATH << File.dirname(__FILE__)

require 'task'
require 'taskgroup'

task1 = Task.new do
  puts 'hello'
end

task2 = Task.new do
  puts 'world'
end

task1.resume

group = TaskGroup.new

group.schedule task1
group.schedule task2

group.start