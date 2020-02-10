class MiaParser
macro
ID                        [a-zA-Z_]+[a-zA-Z0-9_]*
NL                        \n|\r\n|\r|\f
BLANK                     [\ \t]+
rule
  [a-z_]+[a-zA-Z0-9_]*    { [@@reserved[text] || :VERB, text] }
  [A-Z_]+[a-zA-Z0-9_]*    { [:NOUN, text] }
  \${ID}                  { [:VARIABLE, text] }
  \#[^\r?\n]*             #no action
  \|[^\r?\n]*             { [:SNIPPETSTMT, text] }
  \'.*\'                  { [:STRING, text] }
  \(                      { [text, text] }
  \)                      { [text, text] }
  \+                      { [text, text] }
  {NL}                    { @linepos = @ss.pos; [:NEWLINE, text] }
  {BLANK}                 #no action
inner
#Extend this class instead of putting code here!
end