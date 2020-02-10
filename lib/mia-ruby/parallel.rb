
require 'taskgroup'

class Parallel < TaskGroup
  def self.define(&action)
    Parallel.new action
  end
end