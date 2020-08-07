%{let s = null;%}
%lex
%options case-insensitive
entero [0-9]+
decimal ('-')?{entero}("."{entero})?
%%

\s+                   /* skip whitespace */

{decimal}             return 'num'
'('                   return '('
')'                   return ')'
';'                   return ';'
','                   return ','
'u'                   return 'u'
'd'                   return 'd'
'l'                   return 'l'
'r'                   return 'r'
<<EOF>>		       return 'EOF'

/lex

%start S

%%

S : R EOF                     { s = eval('$$'); $$ = { val: $1.loc, node: newNode(yy, yystate, $1.node, 'EOF') }; return $$; }
  ; 

R : PI MOV                    { s = eval('$$'); $$ = { loc:{ x: $2.loc.x, y: $2.loc.y }, node: newNode(yy, yystate, $1.node, $2.node) } }
  ;

PI : '(' num ',' num ')'      { s = eval('$$'); $$ = { loc:{ x: Number($2), y: Number($4) }, node: newNode(yy, yystate, $1, $2, $3, $4, $5) } }
   ;

MOV : MOV ';' D               { s = eval('$$'); $$ = { loc:{ x: s[s.length-3].loc.x + $3.loc.x, y: s[s.length-3].loc.y + $3.loc.y }, node: newNode(yy, yystate, $1.node, $2, $3.node) } }
    | D                       { s = eval('$$'); $$ = { loc:{ x: s[s.length-2].loc.x + $1.loc.x, y: s[s.length-2].loc.y + $1.loc.y }, node: newNode(yy, yystate, $1.node) } }
    ;

D : 'u'                       { s = eval('$$'); $$ = { loc:{ x: 0, y: 1 }, node: newNode(yy, yystate, $1) } }
  | 'd'                       { s = eval('$$'); $$ = { loc:{ x: 0, y: -1 }, node: newNode(yy, yystate, $1) } }  
  | 'r'                       { s = eval('$$'); $$ = { loc:{ x: 1, y: 0 }, node: newNode(yy, yystate, $1) } }  
  | 'l'                       { s = eval('$$'); $$ = { loc:{ x: -1, y: 0 }, node: newNode(yy, yystate, $1) } }
  ;   
