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

INICIO : SUMA EOF           { var temp = getTemp(); $$ = { temp, val: `${$1.val}\n=,${$1.temp},,${temp}`, node: newNode(yy, yystate, $1.node, $2, 'EOF')}; return $$; } 
       ;

SUMA : SUMA '+' MULT        { var temp = getTemp(); $$ = { temp, val: `${$1.val}\n${$3.val}\n+,${$1.temp},${$3.temp},${temp}`, node: newNode(yy, yystate, $1.node, $2, $3.node)}; }       
     | SUMA '-' MULT        { var temp = getTemp(); $$ = { temp, val: `${$1.val}\n${$3.val}\n-,${$1.temp},${$3.temp},${temp}`, node: newNode(yy, yystate, $1.node, $2, $3.node)}; }
     | MULT                 { var temp = getTemp(); $$ = { temp, val: `${$1.val}\n=,${$1.temp},,${temp}`,            node: newNode(yy, yystate, $1.node)};              }
     ;

MULT : MULT '*' VALOR       { var temp = getTemp(); $$ = { temp, val: `${$1.val}\n${$3.val}\n*,${$1.temp},${$3.temp},${temp}`, node: newNode(yy, yystate, $1.node, $2, $3.node)}; }       
     | MULT '/' VALOR       { var temp = getTemp(); $$ = { temp, val: `${$1.val}\n${$3.val}\n/,${$1.temp},${$3.temp},${temp}`, node: newNode(yy, yystate, $1.node, $2, $3.node)}; }
     | VALOR                { var temp = getTemp(); $$ = { temp, val: `${$1.val}\n=,${$1.temp},,${temp}`,            node: newNode(yy, yystate, $1.node)};              }
     ;

VALOR : '(' SUMA ')'        { var temp = getTemp(); $$ = { temp, val: `${$2.val}\n=,${$2.temp},,${temp}`,  node: newNode(yy, yystate, $1, $2, $3)};                     }
      | ENTERO              { var temp = getTemp(); $$ = { temp, val: `=,${$1},,${temp}`,       node: newNode(yy, yystate, $1)};                             }
      | DECIMAL             { var temp = getTemp(); $$ = { temp, val: `=,${$1},,${temp}`,       node: newNode(yy, yystate, $1)};                             }
      ;
