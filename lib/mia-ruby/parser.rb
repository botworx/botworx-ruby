require 'parserx'

class MiaParser
  def parse(input)
    return scan_str(input)
  end
=begin
  def on_error(t, val, vstack)
    raise Racc::ParseError, sprintf("\nparse error on value %s (%s)",
                              val.inspect, token_to_str(t) || '?')
  end
=end
  def on_error(t, val, vstack)
    #raise Racc::ParseError, "#{@lineno}: unexpected token #{val.inspect} (#{token_to_str(t) || '?'}) : #{vstack}"
    raise Racc::ParseError,
    <<-eos
    #{@lineno}:#{@ss.pos}: unexpected token #{val.inspect} (#{token_to_str(t) || '?'})
     : #{vstack}
    eos
  end
=begin
  def on_error(tok, val, _values)
    if val.respond_to?(:id2name)
      v = val.id2name
    elsif String === val
      v = val
    else
      v = val.inspect
    end
    raise Racc::ParseError, "#{@lineno}: unexpected token '#{v}'"
  end  
=end  
end