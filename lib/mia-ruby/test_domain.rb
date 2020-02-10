$LOAD_PATH << File.dirname(__FILE__)

require 'trigger'
require 'message'
require 'clause'
require 'domain'

trigger = Trigger.new Message.new(:add, Clause.new(:believe, :Self, :likes, :Cheese))

domain = Domain.new
domain.add_trigger trigger
