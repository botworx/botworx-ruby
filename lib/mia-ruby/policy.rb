
class Policy
  def visit(t, n)
    t.emitln(['//visit ', n.kind].join)
  end
end

class CompositePolicy < Policy
  def visit(t, n)
    enter(t, n)
    leave(t, n)
  end
  def enter(t, n)
    t.emitln(['//begin ', n.kind].join)
  end
  def leave(t, n)
    t.emitln(['//end ', n.kind].join)
  end  
end

class PolicyGroup
  def [](x)
    @policies[x]
  end
end