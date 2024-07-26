%{
#include "brogram.tab.h"
#include <stdlib.h>
#include <string.h>

/* prototypes */
long copyName(char* name);
%}

%%
[ \t\r\n]                {}
[0-9]+                   yylval = atoi(yytext); return NUM;

"startbro"               return STARTBRO;
"endbro"                 return ENDBRO;
"broprint"               return BROPRINT;
"brogive"                return BROGIVE;
"broloop"                return BROLOOP;
"broswitch"              return BROSWITCH;
"brocase"                return BROCASE;
"brobreak"               return BROBREAK;


"=="                     return EQ;
"!"                      return NEQ;
">"                      return GT;
"<"                      return LT;
[a-z]                    yylval = yytext[0]; return VAR;
[a-zA-Z_][a-zA-Z0-9_]*   yylval = copyName(yytext); return ID;

"="                      return ASSIGN;
";"                      return SEMICOLON;
"("                      return LPAREN;
")"                      return RPAREN;
"{"                      return LBRACE;
"}"                      return RBRACE;
":"                      return COLON;

.                        return yytext[0];
%%

int yywrap(void)
{
  return 1;
}

long copyName(char* name)
{
   int len = strlen(name);
   char* copy = malloc(len + 1);
   strcpy(copy, name);
   return (long)copy;
}








