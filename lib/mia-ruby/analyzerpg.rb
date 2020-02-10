require 'visitor'
require 'policy'

class AnalyzerPG < PolicyGroup
  def initialize
    @policies = {
      :RhsBlock => RhsBlockPolicy.new,
      :LhsBlock => LhsBlockPolicy.new,
      :ClassDef => ClassDefPolicy.new,
      :ClassDefShare => ClassDefSharePolicy.new,      
      :PredicateDef => PredicateDefPolicy.new,
      :PlanDef => PlanDefPolicy.new,
      :BinaryExpr => Policy.new,
      :UnaryExpr => Policy.new,
      :Message => MessagePolicy.new,
      :Clause => ClausePolicy.new,
      :Where => Policy.new,
      :Snippet => SnippetPolicy.new,
      :Nil => NilPolicy.new,
      :Word => WordPolicy.new,
      :Literal => LiteralPolicy.new,
      :Variable => VariablePolicy.new
    }
  end

class SnippetPolicy < Policy
  def visit(t, n)
  end
end

class PredicateDefPolicy < Policy
end

class BlockPolicy < CompositePolicy
  def enter(t, n)
    super(t, n)
    for c in n.children
      t.visit(c)
    end
  end
end

class RhsBlockPolicy < BlockPolicy
end

class LhsBlockPolicy < BlockPolicy
end

class ClassDefSharePolicy < Policy
  def visit(t, n)
  end
end

class ClassDefPolicy < CompositePolicy
  def enter(t, n)
    t.save
    t.classDef = n
    #
    t.visit(n.share)
    #
    t.visit(n.block)
    #
    t.restore
  end
  def leave(t, n)
  end
end

class PlanDefPolicy < CompositePolicy
  def enter(t, n)
    name = n.name
    className = t.classDef.name
    if(name == 'constructor')
      name = 'initialize'
    end
    #
    t.classDef.add_plan n
    #
    t.visit(n.block)
  end
  def leave(t, n)
  end
end

class MessagePolicy < Policy
  def visit(t, n)
    t.visit(n.expr)
  end
end

class NilPolicy < Policy
  def visit(t, n)
  end
end

class WordPolicy < Policy
  def visit(t, n)
  end
end

class LiteralPolicy < Policy
  def visit(t, n)
  end
end

class VariablePolicy < Policy
  def visit(t, n)
  end
end

class ClausePolicy < Policy
  def visit(t, n)
    t.visit(n.subj)
    t.visit(n.pred)
    t.visit(n.obj)
  end
end

end
