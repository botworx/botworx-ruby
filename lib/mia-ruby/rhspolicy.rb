require 'visitor'
require 'policy'

class RhsPolicyGroup < PolicyGroup
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
    t.emitln(n.code)
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
    t.emitln 'class Share < ExpertShare'
    t.indent
    t.emitln 'initialize'
    t.indent
    t.emitln 'add_trigger(Trigger.new(:attempt, :perform, Ent_Self, Ent_bloxBrain, BLANK, -> {|x, m| x.blox(m)})'
    t.dedent
    t.emitln 'end'
    t.dedent
    t.emitln 'end'
  end
end

class ClassDefPolicy < CompositePolicy
  def enter(t, n)
    t.save
    t.classDef = n
    t.emitln(['class ', n.name, ' < Expert'].join)
    t.indent
    #
    t.emitnl
    t.emitln 'include Singleton'
    #t.visit(n.share)
    t.emitnl
    t.emitln 'initialize'
    t.indent
    for plan in n.plans do
      m = plan.trigger
      if !m
        next
      end
      mk = :attempt      
      if m.mods.include? '+'
        k = :add
      end
      ck = :perform
      t.emitln "add_trigger(Trigger.new(:#{mk}, :#{ck}, Ent_Self, Ent_bloxBrain, BLANK, -> {|x, m| x.blox(m)}))"
      #t.emitln 'add_trigger(Trigger.new(:attempt, :perform, Ent_Self, Ent_bloxBrain, BLANK, -> {|x, m| x.blox(m)}))'
      #p trigger
    end
    t.dedent
    t.emitln 'end'
    t.emitnl
    #
    t.visit(n.block)
    #
    t.dedent
    t.restore
  end
  def leave(t, n)
    t.emitln('end')
  end
end

class PlanDefPolicy < CompositePolicy
  def enter(t, n)
    name = n.name
    className = t.classDef.name
    if(name == 'constructor')
      name = 'initialize'
    end
    t.emitln(['def ', name].join)
    t.indent()
    t.visit(n.block)
  end
  def leave(t, n)
    t.dedent()
    t.emitln('end')
    t.emitnl
  end
end

class MessagePolicy < Policy
  def visit(t, n)
    t.emitindented('post(task, ')
    t.visit(n.expr)
    t.emitnl(')')
  end
end

class NilPolicy < Policy
  def visit(t, n)
    t.emit('nil')
  end
end

class WordPolicy < Policy
  def visit(t, n)
    t.emit(n.value)
  end
end

class LiteralPolicy < Policy
  def visit(t, n)
    t.emit(n.value)
  end
end

class VariablePolicy < Policy
  def visit(t, n)
    t.emit(n.name)
  end
end

class ClausePolicy < Policy
  def visit(t, n)
    t.emit('Clause.new(')
    t.visit(n.subj)
    t.emit(', ')
    t.visit(n.pred)
    t.emit(', ')
    t.visit(n.obj)
    t.emit(')')
  end
end

end
