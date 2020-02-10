require 'continuation'

class Escape < Exception
end

class SequenceStrategy
  def initialize()
  end
  def step(task)
    blocks = task.blocks
    block = blocks.shift
    task.blocks = blocks
  end
end

class Task

  attr_accessor :group
  attr_accessor :parent
  attr_reader :status

  def self.define(&action)
    Task.new action
  end

  def initialize(action = nil)
    @action = action
    @group = nil
    @parent = nil
    @status = :created
  end

  def step()
    @strategy.step(self)
  end

  def sequence(blocks)
    @strategy = SequenceStrategy.new
    @blocks = blocks
  end

  def spawn child
    group.schedule child
  end

  def call(child, &action)
    child.parent = self
    if action
      @action = action
    end
    group.schedule child
  end

  def callcc(child)
    child.parent = self
    Kernel.callcc do |cc|
      @action = Proc.new {cc.call}
      group.schedule child
      raise Escape.new
      #throw :escape
    end
  end

  def resume
    instance_eval &@action
  end

  def succeed
    @status = :success
  end

  def fail
    @status = :failure
  end

  def suspend
    @status = :suspended
  end

  def again
    @status = :running
  end

end

def task &action
  Task.new action
end
