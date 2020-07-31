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

INICIO : E EOF  { console.log($1);  }
       ;

E :  T E1       { var s = eval('$$'); $$ = $2; }  
  ;

E1 : '+' T E1   { var s = eval('$$'); $$ = s[eval('$$').length-4] + $3; }
   | '-' T E1   { var s = eval('$$'); $$ = s[eval('$$').length-4] - $3; }
   |            { var s = eval('$$'); $$ = s[eval('$$').length-1]; }
   ;

T :  F T1       { var s = eval('$$'); $$ = $2; } 
  ;

T1 : '*' F T1   { var s = eval('$$'); $$ = s[eval('$$').length-4] * $3; }
   | '/' F T1   { var s = eval('$$'); $$ = s[eval('$$').length-4] / $3; }
   |            { var s = eval('$$'); $$ = s[eval('$$').length-1]; } 
   ;

F : ENTERO      { var s = eval('$$'); $$ = Number($1); }
  | DECIMAL     { var s = eval('$$'); $$ = $1; }
  | '(' E ')'   { var s = eval('$$'); $$ = $2; }
  ;
