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

INICIO : SUMA EOF       { $$ = { val: $1.val, node: newNode(yy, yystate, $1.node, $2, 'EOF')}; return $$; } 
       ;

SUMA : SUMA '+' MULT        { $$ = { val: $1.val + $3.val,  node: newNode(yy, yystate, $1.node, $2, $3.node)}; }       
     | SUMA '-' MULT        { $$ = { val: $1.val - $3.val,  node: newNode(yy, yystate, $1.node, $2, $3.node)}; }
     | MULT                 { $$ = { val: $1.val,           node: newNode(yy, yystate, $1.node)}; }
     ;

MULT : MULT '*' VALOR       { $$ = { val: $1.val + $3.val,  node: newNode(yy, yystate, $1.node, $2, $3.node)}; }       
     | MULT '/' VALOR       { $$ = { val: $1.val - $3.val,  node: newNode(yy, yystate, $1.node, $2, $3.node)}; }
     | VALOR                { $$ = { val: $1.val,           node: newNode(yy, yystate, $1.node)}; }
     ;

VALOR : '(' SUMA ')'        { $$ = { val: Number($2),       node: newNode(yy, yystate, $1, $2, $3)}; }
      | ENTERO              { $$ = { val: Number($1),       node: newNode(yy, yystate, $1)}; }
      | DECIMAL             { $$ = { val: Number($1),       node: newNode(yy, yystate, $1)}; }
      ;
