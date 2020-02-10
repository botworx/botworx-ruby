$LOAD_PATH << File.dirname(__FILE__)

require 'clause'
require 'json'

c1 = Clause.new(:believe, :Itchy, :likes, :Cheese)
c2 = Clause.new(:believe, :Itchy, :likes, :Cheese)
c3 = Clause.new(:believe, :Itchy, :likes, :_)

c4 = Clause.new(:believe, :Scratchy, :likes, :Mice)

jj c1

puts c1 == c2
puts c1 == c3
puts c1 == c4
