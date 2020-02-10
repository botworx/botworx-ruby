
class Message

  def initialize kind, clause
    @kind = kind
    @clause = clause
  end
  
  def ==(that)
    @kind == that.kind
    @clause == that.clause
  end
  
end