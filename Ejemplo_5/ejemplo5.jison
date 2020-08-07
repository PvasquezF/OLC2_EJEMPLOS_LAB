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

S : R EOF                     { $$ = { val: $1.loc, node: newNode(yy, yystate, $1.node, 'EOF') }; console.log($$.val); return $$; }
  ; 

R : PI MOV                    {  $$ = { loc:{ x: $2.loc.x, y: $2.loc.y }, node: newNode(yy, yystate, $1.node, $2.node) } }
  ;

PI : '(' num ',' num ')'      {$$ = { loc:{ x: Number($2), y: Number($4) }, node: newNode(yy, yystate, $1, $2, $3, $4, $5) } }
   ;

MOV : MOV ';' D               { s = eval('$$'); $$ = { loc:{ x: s[s.length-3].loc.x + $3.loc.x, y: s[s.length-3].loc.y + $3.loc.y }, node: newNode(yy, yystate, $1.node, $2, $3.node) } }
    | D                       { s = eval('$$'); $$ = { loc:{ x: s[s.length-2].loc.x + $1.loc.x, y: s[s.length-2].loc.y + $1.loc.y }, node: newNode(yy, yystate, $1.node) } }
    ;

D : 'u'                       {  $$ = { loc:{ x: 0, y: 1 }, node: newNode(yy, yystate, $1) } }
  | 'd'                       {  $$ = { loc:{ x: 0, y: -1 }, node: newNode(yy, yystate, $1) } }  
  | 'r'                       {  $$ = { loc:{ x: 1, y: 0 }, node: newNode(yy, yystate, $1) } }  
  | 'l'                       {  $$ = { loc:{ x: -1, y: 0 }, node: newNode(yy, yystate, $1) } }
  ;   
