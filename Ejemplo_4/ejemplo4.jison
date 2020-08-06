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

INICIO : SUMA EOF           { const temp = getTemp(); $$ = { temp, node: newNode(yy, yystate, $1.node, $2, 'EOF')}; return $$; console.log(`${$1.temp},,,${temp}`); } 
       ;

SUMA : SUMA '+' MULT        { const temp = getTemp(); $$ = { temp, node: newNode(yy, yystate, $1.node, $2, $3.node)};   console.log(`+,${$1.temp},${$3.temp},${temp}`);        }       
     | SUMA '-' MULT        { const temp = getTemp(); $$ = { temp, node: newNode(yy, yystate, $1.node, $2, $3.node)};   console.log(`-,${$1.temp},${$3.temp},${temp}`);        }
     | MULT                 { const temp = getTemp(); $$ = { temp, node: newNode(yy, yystate, $1.node)};                console.log(`${$1.temp},,,${temp}`);                   }
     ;

MULT : MULT '*' VALOR       { const temp = getTemp(); $$ = { temp, node: newNode(yy, yystate, $1.node, $2, $3.node)};   console.log(`*,${$1.temp},${$3.temp},${temp}`);        }       
     | MULT '/' VALOR       { const temp = getTemp(); $$ = { temp, node: newNode(yy, yystate, $1.node, $2, $3.node)};   console.log(`/,${$1.temp},${$3.temp},${temp}`);        }
     | VALOR                { const temp = getTemp(); $$ = { temp, node: newNode(yy, yystate, $1.node)};                console.log(`${$1.temp},,,${temp}`);                   }
     ;

VALOR : '(' SUMA ')'        { const temp = getTemp(); $$ = { temp, node: newNode(yy, yystate, $1, $2, $3)};             console.log(`${$2.temp},,,${temp}`);                   }
      | ENTERO              { const temp = getTemp(); $$ = { temp, node: newNode(yy, yystate, $1)};                     console.log(`${$1},,,${temp}`);                        }
      | DECIMAL             { const temp = getTemp(); $$ = { temp, node: newNode(yy, yystate, $1)};                     console.log(`${$1},,,${temp}`);                        }
      ;
