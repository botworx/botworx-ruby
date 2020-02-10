
require 'task'

class Whilst < Task

  def self.define(test, &action)
    Whilst.new test, action
  end
  
  def initialize test, action
    super action
    @test = test
  end
  
  def resume
    if @test.()
      super()
      again
    end
  end
  
end

#module Dsl
  def whilst test, &action
    Whilst.new test, action
  end
#end
