require 'lexerx'

def _new_token(type, lineno, lexpos)
  return [type, nil]
end

def _TERMINATOR(lineno, lexpos)
  return _new_token(:TERMINATOR, lineno, lexpos)
end

def _INDENT(lineno, lexpos)
  return _new_token(:INDENT, lineno, lexpos)
end
    
def _DEDENT(lineno, lexpos)
  return _new_token(:DEDENT, lineno, lexpos)
end

class MiaParser
  def initialize
    @linepos = 0
    @paren_count = 0
    @at_line_start = false
    @prevTokenType = :TERMINATOR
    @indentstack = [0]
    @queue = []
    @eof = false
    #
    @@reserved = {
      "class" => :CLASS,
      "predicate" => :PREDICATE,
      "def" => :DEF,
      "if" => :IF,
      "return" => :RETURN,
    }
    
  end
  def find_indent(token)
    last_cr = @linepos
    if last_cr < 0
      last_cr = 0
    end
    indent = (@ss.pos - token[1].length) - last_cr
    return indent
  end
  #use for testing
  def lex(code)
    scan_setup(code)
    tokens = []
    while token = next_token
      tokens << token
    end
    tokens
  end
  #copied and overridden from rexical generated lexer
  def __next_token
    return if @ss.eos?
    # skips empty actions
    until token = _next_token or @ss.eos?; end
    token  
  end
  def next_token
    token = nil; latok = nil
    indent = 0
    if(@queue.length != 0)
      token = @queue.shift
      if token
        @prevTokenType = token[0] #get token kind
      end
      return token
    end
    token = __next_token
    #
    if token == nil
      if @eof
        return nil
      end    
      @eof = true
      lineno = 0
      lexpos = 0
      while(@indentstack[-1] > 0)
        @indentstack.pop
        @queue << _DEDENT(lineno, lexpos)
      end
      @queue << nil
    elsif(token[0] == :NEWLINE)
      #print 'Newline Filter'
      while 1
        latok = __next_token
        #print 'Lookahead:  ' + latok.type
        if latok[0] != :NEWLINE
          break
        end
      end
      indent = find_indent(latok)
      #puts "Indent:  #{indent}"
      #lineno = latok.lineno
      lineno = @lineno
      #lexpos = latok.lexpos
      lexpos = @ss.pos
      if(indent > @indentstack[-1])
        @indentstack << indent
        @queue << _INDENT(lineno, lexpos)
      elsif(indent < @indentstack[-1])
        while(indent < @indentstack[-1])
          @indentstack.pop
          @queue << _DEDENT(lineno, lexpos)
        end
        @queue << _TERMINATOR(lineno, lexpos)
      else
        if(@prevTokenType != :TERMINATOR)
          @queue << _TERMINATOR(lineno, lexpos)
        end
      end
      @queue << latok
    else
      @queue << token
    end
    #
    token = @queue.shift
    if token != nil
      @prevTokenType = token[0]
    end
    return token
    
  end
  
end