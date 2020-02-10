require 'fiber'

fiber1 = Fiber.new do
  x, y = 0, 1
  loop do
    Fiber.yield y
    x, y = y, x + y
  end
end

#20.times { puts fib.resume }

puts fiber1.resume

fiber2 = fiber1.clone
p fiber2
puts fiber2.inspect
puts fiber2.alive?
puts fiber2.resume

puts fiber1.resume