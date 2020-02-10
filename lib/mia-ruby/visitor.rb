

class Visitor
  def visit(node)
    policy = @policygroup[node.kind]
    if policy == nil
      print node
      raise "Undefined Policy:  " + node.kind.to_s
    end
    policy.visit(self, node)
  end
end