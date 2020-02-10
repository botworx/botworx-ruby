$LOAD_PATH << File.dirname(__FILE__)

require 'parser'
require 'compiler'
require 'analyzer'
require 'json'

filename = 'hello.mia'

File.open(filename) {|file|
  puts '#'
  puts '#Loader'
  puts '#'  
  parser = MiaParser.new
  compiler = Compiler.new
  analyzer = Analyzer.new
	data = file.read
  #data = "Bob\nBob"
	#puts data
	begin
    puts '#'
    puts '#Lexer'
    puts '#'  
    ast = parser.parse(data)
    #puts ast.toJSON
    #p ast
    #jj ast.toJSON
    puts '#'
    puts '#Parser'
    puts '#'    
    jj ast
    puts '#'
    puts '#Analyzer'
    puts '#'
    analyzer.analyze(ast)
    puts '#'
    puts '#Compiler'
    puts '#'
    compiler.compile(ast)
	rescue MiaParser::ScanError => e
		puts 'MiaParser::ScanError'
    puts e
	rescue Racc::ParseError => e
		puts 'MiaParser::ParseError'
    puts e    
	end
}