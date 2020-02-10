require 'analyzerpg'

class State
  attr_reader :classDef
  def initialize(classDef)
    @classDef = classDef
  end
end

class Analyzer < Visitor
  attr_accessor :classDef
  def initialize
    @rhspolicygroup = AnalyzerPG.new
    @policygroup = @rhspolicygroup
    @out = []
    @indentlevel = 0
    @indentation = ''
    @states = []
    #
    @classDef = nil
  end
  
  def analyze(ast)
    visit(ast)
  end
  
  def save
    state = State.new(@classDef)
    @states << state
  end
  
  def restore
    state = @states.pop()
    @classDef = state.classDef
  end

  def emit(s)
    print s
  end
  
  def emitindented(s)
    print @indentation + s
  end
  
  def emitln(s)
    puts @indentation + s
  end
  
  def emitnl(s)
    puts s
  end
  
  def indent
    @indentlevel += 1
    @indentation = '  ' * (@indentlevel)
  end
  
  def dedent
    @indentlevel -= 1
    @indentation = '  ' * (@indentlevel)
  end
  
end
        