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

%left '+' '-'
%left '*' '/'

%start INICIO

%%

INICIO : EXP EOF       { $$ = { val: $1.val, node: newNode(yy, yystate, $1.node, 'EOF')}; return $$; } 
       ;

EXP : EXP '+' EXP   { $$ = { val: $1.val + $3.val,  node: newNode(yy, yystate, $1.node, $2, $3.node)}; }       
    | EXP '-' EXP   { $$ = { val: $1.val - $3.val,  node: newNode(yy, yystate, $1.node, $2, $3.node)}; }
    | EXP '*' EXP   { $$ = { val: $1.val * $3.val,  node: newNode(yy, yystate, $1.node, $2, $3.node)}; }
    | EXP '/' EXP   { $$ = { val: $1.val / $3.val,  node: newNode(yy, yystate, $1.node, $2, $3.node)}; }
    | ENTERO        { $$ = { val: Number($1),       node: newNode(yy, yystate, $1)}; }
    | DECIMAL       { $$ = { val: Number($1),       node: newNode(yy, yystate, $1)}; }
    ;
