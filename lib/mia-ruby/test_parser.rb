$LOAD_PATH << File.dirname(__FILE__)

require 'parser'
require 'json'

filename = 'hello.mia'

File.open(filename) {|file|
	puts "Loading File!"
  parser = MiaParser.new
	data = file.read
  #data = "Bob\nBob"
	#puts data
	begin
    ast = parser.parse(data)
    #puts ast.toJSON
    #p ast
    #jj ast.toJSON
    jj ast
	rescue MiaParser::ScanError => e
		puts 'MiaParser::ScanError'
    puts e
	rescue Racc::ParseError => e
		puts 'MiaParser::ParseError'
    puts e    
	end
}