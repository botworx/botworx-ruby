# MIA Grammar
class MiaParser

token INDENT DEDENT TERMINATOR RETURN CLASS DEF PREDICATE WHERE VERB NOUN VARIABLE 
token SEMICOLON STRING SNIPPETSTMT NUMBER NOT

rule
  
Root
	: RhsBody
  | RhsBlock TERMINATOR
  |
    { result = RhsBlock.new }
	;

RhsBlock
	: INDENT RhsBody DEDENT
    { result = val[1]; }
  | INDENT DEDENT
    { result = RhsBlock.new }
	;
	
RhsBody
	: RhsLine
    { result = RhsBlock.new [val[0]] }
  | RhsBody TERMINATOR RhsLine
    { result = val[0]; result.push(val[2]) }
  | RhsBody TERMINATOR
	;
  
RhsLine
	: Message | Statement
	;

LhsBlock
	: INDENT LhsBody DEDENT
    { result = val[1]; }
  | INDENT DEDENT
    { result = LhsBlock.new }
	;
	
LhsBody
	: LhsLine
    { result = LhsBlock.new [val[0]] }
  | LhsBody TERMINATOR LhsLine
    { result = val[0]; result.push(val[2]) }
  | LhsBody TERMINATOR
	;

LhsLine
	: Expression | Statement
	;
  
ExprList
  :
  | Expression
    { result = [val[0]] }
  | ExprList TERMINATOR Expression
    { result = val[0]; result.push(val[2]) }
  | ExprList TERMINATOR
  ;
  	
Statement
	: ClassDef | PredicateDef | PlanDef | Where | Return | SnippetStmt
	;

Return
	: RETURN Expression
    { result = Return.new val[1] }
  | RETURN
    { result = Return.new nil }
	;
  
ClassDef
	: CLASS NOUN RhsBlock
    { result = ClassDef.new(val[1], val[2]) }
	;

PredicateDef
	: PREDICATE VERB '(' NOUN ')'
    { result = PredicateDef.new(val[1], val[3]) }
	;

PlanDef
	: DEF Identifier OptTrigger RhsBlock
    { result = PlanDef.new(val[1], val[2], val[3]) }
	;

Where
  : WHERE INDENT ExprList DEDENT TERMINATOR WhereActions SEMICOLON
    { result = WhereStmt.new(val[2], val[5]) }
  ;

WhereActions
  : WhereAction
    { result = [val[0]] }
  | WhereActions TERMINATOR WhereAction
    { result = val[0]; result.push(val[2]) }
  | WhereActions TERMINATOR
  ;
  
WhereAction
  : WhereTrue | WhereFalse | WhereAllTrue | WhereAllFalse
  ;

WhereTrue
	: '-->' RhsBlock
    { result = WhereAction.new(val[0], val[1]) }
	;

WhereFalse
	: '!->' RhsBlock
    { result = WhereAction.new(val[0], val[1]) }
	;

WhereAllTrue
	: '==>' RhsBlock
    { result = WhereAction.new(val[0], val[1]) }
	;

WhereAllFalse
	: '!=>' RhsBlock
    { result = WhereAction.new(val[0], val[1]) }
	;
    
Expression
	: Clause | Term | ParExpr | UnaryExpr | BinaryExpr
	;
  
Identifier
  : NOUN | VERB
  ;
  
Term
	: Variable | Noun | String
	;
  
SnippetStmt
  : SNIPPETSTMT
    { result = Snippet.new(val[0]); }
  ;
  
Message
  : OptMsgPreMods Expression OptMsgPostMods
  { result = Message.new(val[0], val[1], val[2]) }
;

OptMsgPreMods
  :
    { result = nil }
  | MsgPreMods
    { result = val[0] }
  ;
 
MsgPreMods
  :
  | MsgPreMod
    { result = [val[0]] }
  | MsgPreMods MsgPreMod
    { result = val[0]; result << val[1] }
  ;

MsgPreMod
	: '+' | '-' | '+-' | '*'
	;
  
OptMsgPostMods
  :
    { result = nil }
  | MsgPostMods
    { result = val[0] }    
  ;

MsgPostMod
	: '.' | '!' | '?'
	;
  
MsgPostMods
  :
  | MsgPostMod
    { result = [val[0]] }
  | MsgPostMods MsgPostMod
    { result = val[0]; result << val[1] }
  ;
  
Clause
  : Expression Verb Expression
    { result = Clause.new(val[0], val[1], val[2]) }
  | Expression Verb
    { result = Clause.new(val[0], val[1], Nil.new) }
  | Verb Expression
    { result = Clause.new(Nil.new, val[0], val[1]) }
  | Verb
    { result = Clause.new(Nil.new, val[0], Nil.new) }
  | Expression
    #{ result = Clause.new(val[0], Nil.new, Nil.new) }
    { result = val[1] }
  ;

Verb
  : VERB
  { result = Word.new(val[0]) }

Noun
  : NOUN
  { result = Word.new(val[0]) }

Variable
  : VARIABLE
  { result = Variable.new(val[0]) }
  
String
  : STRING
  { result = StringNode.new(val[0]) }

OptTrigger
  :
  { result = nil }
  | Trigger
  { result = val[0] }
  
Trigger
	: '(' ')'
    { result = nil }
  | '(' Message ')' 
    { result = val[1] }
	;
  
ParExpr
	: '(' ')'
    { result = nil }
  | '(' Expression ')' 
    { result = val[1] }
	;

UnaryExpr
  : Not | Assert | Retract | Modify | Propose | Achieve | Slash
  ;

Not
  : NOT Expression
  { result = UnaryExpr.new(val[0], val[1]) }
  ;  
  
Assert
  : '+' Expression
  { result = UnaryExpr.new(val[0], val[1]) }
  ;

Retract
  : '-' Expression
  { result = UnaryExpr.new(val[0], val[1]) }
  ;

Modify
  : '-+' Expression
  { result = UnaryExpr.new(val[0], val[1]) }
  ;

Propose
  : '*' Expression
  { result = UnaryExpr.new(val[0], val[1]) }
  ;

Achieve
  : '@' Expression
  { result = UnaryExpr.new(val[0], val[1]) }
  ;

Slash
  : '/' Expression
  { result = UnaryExpr.new(val[0], val[1]) }
  ;
  
BinaryExpr
	: ContextExpr | SubclauseExpr | InjectExpr | PropertyExpr | BindExpr | NotEqualExpr
	;

ContextExpr
	: Expression '<:' INDENT ExprList DEDENT
    { result = BinaryExpr.new(val[1], val[0], val[3]) }
	;

SubclauseExpr
	: Expression '::' INDENT ExprList DEDENT
    { result = BinaryExpr.new(val[1], val[0], val[3]) }
	;
  
InjectExpr
	: Expression '<<:' Expression
    { result = BinaryExpr.new(val[1], val[0], val[2]) }
	;

PropertyExpr
	: Expression '`' Expression
    { result = BinaryExpr.new(val[1], val[0], val[2]) }
	;
  
BindExpr
	: Expression '->' Expression
    { result = BinaryExpr.new(val[1], val[0], val[2]) }
	;
  
NotEqualExpr
	: Expression '!=' Expression
    { result = BinaryExpr.new(val[1], val[0], val[2]) }
	;  
	
end

---- header
require 'lexer'
require 'ast'
---- inner
#Extend this class instead of putting code here!
