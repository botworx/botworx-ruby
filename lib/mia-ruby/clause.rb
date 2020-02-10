
class Clause

  attr_reader :kind
  attr_reader :subj
  attr_reader :pred
  attr_reader :obj
  
  def initialize kind, subj, pred, obj
    @kind = kind
    @subj = subj
    @pred = pred
    @obj = obj
  end
  
  def ==(that)
    @kind == that.kind &&
    @subj == that.subj &&
    @pred == that.pred &&
    @obj == that.obj
  end
  
  def to_json(*a)
    {:kind => @kind, :subj => @subj, :pred => @pred, :obj => @obj}.to_json(*a)
  end
  
end