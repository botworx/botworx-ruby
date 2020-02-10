

class Node
  attr_reader :kind
  def initialize()
  end
end
  
class List < Node
  attr_reader :children
  def initialize(children = nil)
    if children == nil
      @children = []
    else
      @children = children
    end
  end
  def push(child)
    @children << child
  end
end
        
class Block < List
  def initialize(children = nil)
    super(children)
    @kind = :Block
  end 
  def to_json(*a)
    {:kind => @kind, :children => @children}.to_json(*a)
  end
end

class RhsBlock < Block
  def initialize(children = nil)
    super(children)
    @kind = :RhsBlock
  end 
end

class LhsBlock < Block
  def initialize(children = nil)
    super(children)
    @kind = :LhsBlock
  end 
end

class ClassDefShare < Node
  def initialize
    @kind = :ClassDefShare
    @triggers = []
  end
  def to_json(*a)
    {:kind => @kind}.to_json(*a)
  end
end

class Trigger < Node
  def initialize
    @kind = :Trigger
  end
  def to_json(*a)
    {:kind => @kind}.to_json(*a)
  end
end

class ClassDef < Node
  attr_reader :name
  attr_reader :block
  attr_reader :share
  attr_reader :plans
  def initialize(name, block)
    @kind = :ClassDef
    @name = name
    @block = block
    @share = ClassDefShare.new
    @plans = []
  end
  def add_plan plan
    @plans << plan
  end
  def to_json(*a)
    {:kind => @kind, :name => @name, :block => @block}.to_json(*a)
  end
end

class PlanDef < Node
  attr_reader :name
  attr_reader :trigger
  attr_reader :block
  def initialize(name, trigger, block)
    @kind = :PlanDef
    @name = name
    @trigger = trigger
    @block = block
  end
  def to_json(*a)
    {:kind => @kind, :name => @name, :trigger => @trigger, :block => @block}.to_json(*a)
  end
end

class Trigger < Node
  attr_reader :message
  def initialize(message)
    @kind = :Trigger
    @message = message
  end 
  def to_json(*a)
    {:kind => @kind, :message => @message}.to_json(*a)
  end
end

class Message < Node
  attr_reader :expr
  attr_reader :mods
  def initialize(premods, expr, postmods)
    @kind = :Message
    @mods = []
    if premods
      @mods += premods
    end
    @expr = expr
    if postmods
      @mods += postmods
    end
  end
  def to_json(*a)
    {:kind => @kind, :mods => @mods, :expr => @expr}.to_json(*a)
  end
end

class Clause < Node
  attr_reader :subj
  attr_reader :pred
  attr_reader :obj
  def initialize(subj, pred, obj)
    @kind = :Clause
    @subj = subj
    @pred = pred
    @obj = obj
  end
  def to_json(*a)
    {:kind => @kind, :subj => @subj, :pred => @pred, :obj => @obj}.to_json(*a)
  end
end

class Snippet < Node
  attr_reader :code
  def initialize(code)
    @kind = :Snippet
    @code = code
  end 
  def to_json(*a)
    {:kind => @kind, :code => @code}.to_json(*a)
  end
end

class Literal < Node
  attr_reader :value
  def initialize(value)
    @kind = :Literal
    @value = value
  end 
  def to_json(*a)
    {:kind => @kind, :value => @value}.to_json(*a)
  end
end

class StringNode < Literal
  def initialize(value)
    @kind = :String
    super(value)
  end 
end

class Word < Node
  attr_reader :value
  def initialize(value)
    @kind = :Word
    @value = value
  end 
  def to_json(*a)
    {:kind => @kind, :value => @value}.to_json(*a)
  end
end

class Variable < Node
  attr_reader :name
  def initialize(name)
    @kind = :Variable
    @name = name
  end 
  def to_json(*a)
    {:kind => @kind, :name => @name}.to_json(*a)
  end
end

class Nil < Node
  def initialize
    @kind = :Nil
  end 
  def to_json(*a)
    {:kind => @kind}.to_json(*a)
  end
end