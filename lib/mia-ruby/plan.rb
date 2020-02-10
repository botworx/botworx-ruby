require 'sequence'

class Plan < Sequence
  def self.define(&action)
    Plan.new action
  end
end