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

INICIO : E EOF  { $$ = { val: Number(0), node: newNode(yy, yystate, $1.node, 'EOF')}; return $$; }
       ;

E :  T E1       { $$ = { val: Number(0), node: newNode(yy, yystate, $1.node, $2.node)}; }  
  ;

E1 : '+' T E1   { $$ = { val: $2 , node: newNode(yy, yystate, '+',$2.node, $3.node)}; }
   | '-' T E1   { $$ = { val: Number(0), node: newNode(yy, yystate, '-',$2.node, $3.node)}; }
   |            { $$ = { val: Number(0), node: newNode(yy, yystate, 'e')}; }
   ;

T :  F T1       { $$ = { val: $1.val, node: newNode(yy, yystate, $1.node, $2.node)}; } 
  ;

T1 : '*' F T1   { $$ = { val: $2.val, node: newNode(yy, yystate, '*', $2.node, $3.node)}; }
   | '/' F T1   { $$ = { val: $2.val, node: newNode(yy, yystate, '/', $2.node, $3.node)}; }
   |            { $$ = { val: Number(1), node: newNode(yy, yystate, 'e')}; } 
   ;

F : ENTERO      { $$ = { val: Number($1), node: newNode(yy, yystate, $1)}; }
  | DECIMAL     { $$ = { val: Number($1), node: newNode(yy, yystate, $1)}; }
  | '(' E ')'   { $$ = { val: $1.val, node: newNode(yy, yystate, '(', $2, ')')}; }
  ;
