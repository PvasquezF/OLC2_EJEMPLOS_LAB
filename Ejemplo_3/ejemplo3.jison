%{let s = null;%}
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
<<EOF>>		            return 'EOF'

/lex

%start INICIO

%%

INICIO : E EOF  { $$ = { val: $1.val, node: newNode(yy, yystate, $1.node, 'EOF')}; return $$; } 
       ;

E :  T E1       { s = eval('$$'); $$ = { val: $2.val, node: newNode(yy, yystate, $1.node, $2.node)}; }  
  ;

E1 : '+' T E1   { s = eval('$$'); $$ = { val: s[s.length-4].val + $3.val, node: newNode(yy, yystate, $1, $2.node, $3.node)}; }
   | '-' T E1   { s = eval('$$'); $$ = { val: s[s.length-4].val - $3.val, node: newNode(yy, yystate, $1, $2.node, $3.node)}; }
   |            { s = eval('$$'); $$ = { val: s[s.length-1].val, node: newNode(yy, yystate, 'EPSILON')}; }
   ;

T :  F T1       { s = eval('$$'); $$ = { val: $2.val, node: newNode(yy, yystate, $1.node, $2.node)}; } 
  ;

T1 : '*' F T1   { s = eval('$$'); $$ = { val: s[s.length-4].val * $3.val, node: newNode(yy, yystate, $1, $2.node, $3.node)}; }
   | '/' F T1   { s = eval('$$'); $$ = { val: s[s.length-4].val / $3.val, node: newNode(yy, yystate, $1, $2.node, $3.node)}; }
   |            { s = eval('$$'); $$ = { val: s[s.length-1].val, node: newNode(yy, yystate, 'EPSILON')}; } 
   ;

F : ENTERO      { s = eval('$$'); $$ = { val: Number($1), node: newNode(yy, yystate, $1)}; }
  | DECIMAL     { s = eval('$$'); $$ = { val: Number($1), node: newNode(yy, yystate, $1)}; }
  | '(' E ')'   { s = eval('$$'); $$ = { val: $2.val, node: newNode(yy, yystate, $2)}; }
  ;
