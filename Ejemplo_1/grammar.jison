%{
    
%}
%lex
%options case-insensitive
entero [0-9]+
decimal {entero}"."{entero}
stringliteral (\"[^"]*\")
%%

\s+                   /* skip whitespace */

{decimal}             return 'DECIMAL' 
{entero}              return 'ENTERO'
{stringliteral}       return 'STRING_LITERAL'
"*"                   return '*'
"/"                   return '/'
";"                   return ';'
"-"                   return '-'
"+"                   return '+'
"("                   return '('
")"                   return ')'  
"["                   return '['
"]"                   return ']'
"evaluar"             return 'evaluar'

<<EOF>>				  return 'EOF'

/lex

%left '+' '-'
%left '*' '/'
%left UMENOS

%start INICIO

%%

INICIO : INSTRUCCIONES EOF {}
;

INSTRUCCIONES : INSTRUCCIONES INSTRUCCION { console.log($2);}
              | INSTRUCCION               { console.log($1); }
              | error                     { console.log('Este es un error sintáctico: ' 
                                            + yytext + ', en la linea: ' 
                                            + this._$.first_line + ', en la columna: ' 
                                            + this._$.first_column); }
              ;

INSTRUCCION : 'evaluar' '[' EXPRESION ']' ';' { $$ = 'El valor de la expresión es: ' + $3;}
            ;

EXPRESION : '-' EXPRESION %prec UMENOS	    { $$ = $2 * -1; }
          | EXPRESION '+' EXPRESION		    { $$ = $1 + $3; }
          | EXPRESION '-' EXPRESION		    { $$ = $1 - $3; }
          | EXPRESION '*' EXPRESION		    { $$ = $1 * $3; }
          | EXPRESION '/' EXPRESION	        { $$ = $1 / $3; }
          | ENTERO						    { $$ = Number($1); }
          | DECIMAL						    { $$ = Number($1); }
          | STRING_LITERAL				    { $$ = $1; }
          | '(' EXPRESION ')'		        { $$ = $2; }
          ;
