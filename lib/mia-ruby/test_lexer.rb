$LOAD_PATH << File.dirname(__FILE__)

require 'lexer'

filename = 'hello.mia'

File.open(filename) {|file|
	puts "Loading File!"
	lexer = MiaParser.new
	data = file.read
  #data = 'Bob'
	puts data
	begin
		tokens = lexer.lex(data)
		puts tokens
	rescue MiaParser::ScanError => e
		puts 'MiaParser::ScanError'
    puts e
	end	
}