%lex
%options case-insensitive
entero [0-9]+
decimal ('-')?{entero}("."{entero})?
%%

\s+                   /* skip whitespace */

{decimal}             return 'num'
'if'                  return 'if'
'else'                return 'else'
'('                   return '('
')'                   return ')'
'}'                   return '}'
'{'                   return '{'
'+'                   return '+'
'-'                   return '-'
'*'                   return '*'
'/'                   return '/'
'<'                   return '<'
'>'                   return '>'
'<='                  return '<='
'>='                  return '>='
'=='                  return '=='
'!='                  return '!='
';'                   return ';'
<<EOF>>		       return 'EOF'

/lex

%left '==' '!='
%left '<' '>' '<=' '>='
%left '+' '-'
%left '*' '/'

%start S

%%

S : INSTRUCCIONES EOF         { $$ = { val: 0, node: newNode(yy, yystate, $1.node, $2)}; return $$; }
  ;

INSTRUCCIONES : INSTRUCCIONES INSTRUCCION    { $$ = { val: 0, node: newNode(yy, yystate, $1.node, $2.node)}; }
              | INSTRUCCION                  { $$ = { val: 0, node: newNode(yy, yystate, $1.node)}; }
              ;

INSTRUCCION : EXPRESION   { $$ = { val: 0, node: newNode(yy, yystate, $1.node)}; }
            | IF          { $$ = { val: 0, node: newNode(yy, yystate, $1.node)}; }
            ;

WHILE : 'while' '(' EXPRESION ')' CUERPO  
      ;

DO_WHILE : 'do' CUERPO 'while' '(' EXPRESION ')' ';'

IF : 'if' '(' EXPRESION ')' CUERPO                { $$ = { val: 0, node: newNode(yy, yystate, $1, $3.node, $5.node)}; }
   | 'if' '(' EXPRESION ')' CUERPO 'else' CUERPO  { $$ = { val: 0, node: newNode(yy, yystate, $1, $3.node, $5.node, $6, $7.node)}; }
   | 'if' '(' EXPRESION ')' CUERPO 'else' IF      { $$ = { val: 0, node: newNode(yy, yystate, $1, $3.node, $5.node, $6, $7.node)}; }
   ;

CUERPO : '{' INSTRUCCIONES '}'  { $$ = { val: 0, node: newNode(yy, yystate, $2.node)}; }
       ;

EXPRESION : EXPRESION  '+'  EXPRESION  { $$ = { val: 0, node: newNode(yy, yystate, $1.node, $2, $3.node)}; }
          | EXPRESION  '-'  EXPRESION  { $$ = { val: 0, node: newNode(yy, yystate, $1.node, $2, $3.node)}; }
          | EXPRESION  '*'  EXPRESION  { $$ = { val: 0, node: newNode(yy, yystate, $1.node, $2, $3.node)}; }
          | EXPRESION  '/'  EXPRESION  { $$ = { val: 0, node: newNode(yy, yystate, $1.node, $2, $3.node)}; }
          | EXPRESION  '<'  EXPRESION  { $$ = { val: 0, node: newNode(yy, yystate, $1.node, $2, $3.node)}; }
          | EXPRESION  '<=' EXPRESION  { $$ = { val: 0, node: newNode(yy, yystate, $1.node, $2, $3.node)}; }
          | EXPRESION  '>'  EXPRESION  { $$ = { val: 0, node: newNode(yy, yystate, $1.node, $2, $3.node)}; }
          | EXPRESION  '>=' EXPRESION  { $$ = { val: 0, node: newNode(yy, yystate, $1.node, $2, $3.node)}; }
          | EXPRESION  '==' EXPRESION  { $$ = { val: 0, node: newNode(yy, yystate, $1.node, $2, $3.node)}; }
          | EXPRESION  '!=' EXPRESION  { $$ = { val: 0, node: newNode(yy, yystate, $1.node, $2, $3.node)}; }
          | num                        { $$ = { val: 0, node: newNode(yy, yystate, $1)}; }
          ;