%{
%}
%lex
%options case-insensitive
entero [0-9]+
decimal {entero}"."{entero}
%%

\s+                   /* skip whitespace */

{decimal}             return 'DECIMAL' 
{entero}              return 'ENTERO'
"*"                   return '*'
"/"                   return '/'
";"                   return ';'
"-"                   return '-'
"+"                   return '+'
"("                   return '('
")"                   return ')'  
<<EOF>>		       return 'EOF'

/lex
%start INICIO

%%

INICIO : E EOF  { $$ = { val: $1.val, node: newNode(yy, yystate, $1.node, 'EOF')}; return $$; } 
       ;

E :  T E1       { var s = eval('$$'); $$ = { val: $2, node: newNode(yy, yystate, $2)}; }  
  ;

E1 : '+' T E1   { var s = eval('$$'); $$ = { val: s[eval('$$').length-4] + $3, node: newNode(yy, yystate, $1.node, $2, $3.node)}; }
   | '-' T E1   { var s = eval('$$'); $$ = { val: s[eval('$$').length-4] - $3, node: newNode(yy, yystate, $1.node, $2, $3.node)}; }
   |            { var s = eval('$$'); $$ = { val: s[eval('$$').length-1], node: newNode(yy, yystate, $1.node, 'EPSILON')}; }
   ;

T :  F T1       { var s = eval('$$'); $$ = { val: $2, node: newNode(yy, yystate, $2)}; } 
  ;

T1 : '*' F T1   { var s = eval('$$'); $$ = { val: s[eval('$$').length-4] * $3, node: newNode(yy, yystate, $1.node, $2, $3.node)}; }
   | '/' F T1   { var s = eval('$$'); $$ = { val: s[eval('$$').length-4] / $3, node: newNode(yy, yystate, $1.node, $2, $3.node)}; }
   |            { var s = eval('$$'); $$ = { val: s[eval('$$').length-1], node: newNode(yy, yystate, $1.node, 'EPSILON')}; } 
   ;

F : ENTERO      { var s = eval('$$'); $$ = { val: Number($1), node: newNode(yy, yystate, $1)}; }
  | DECIMAL     { var s = eval('$$'); $$ = { val: Number($1), node: newNode(yy, yystate, $1)}; }
  | '(' E ')'   { var s = eval('$$'); $$ = { val: $2, node: newNode(yy, yystate, $1)}; }
  ;
