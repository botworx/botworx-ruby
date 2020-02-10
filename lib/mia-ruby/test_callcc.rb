require 'continuation'

def a
  puts "hello world"
  callcc {|cc| $label1 = cc } # pretend this says "label1:"
  puts "then you say..."
  b
end

def b
  puts "then I say"
  $label1.call # pretend this says "goto label1"
end

a