%{
#include <stdio.h>
#include <string.h>
#include "tinysql.tab.h"

void yyerror(char *);
%}

%%
"create"                    { return CREATE; }
"add to"                    { return INSERT; }
"select"                    { return SELECT; }
"update"                    { return UPDATE; }
"delete from"               { return DELETE; }
"with condition"            { return WHERE; }
"to"                        { return TO; }
"in"                        { return IN; }
"from"                      { return FROM; }
"int"                       { return INT_TYPE; }
"string"                    { return STRING_TYPE; }
"all"                       { return ALL; }
"="                         { return EQUALS; }
"!="                        { return NOT_EQUALS; }
">"                         { return GREATER; }
"<"                         { return LESS; }
">="                        { return GREATER_EQUALS; }
"<="                        { return LESS_EQUALS; }
","                         { return COMMA; }
[a-zA-Z][a-zA-Z0-9_]*       { yylval.str = strdup(yytext); return IDENTIFIER; }
[0-9]+                      { yylval.num = atoi(yytext); return NUMBER; }
\"[^\"]*\"                  { 
                              yylval.str = strdup(yytext+1); 
                              yylval.str[strlen(yylval.str)-1] = '\0'; 
                              return STRING; 
                            }
\'[^\']*\'                  { 
                              yylval.str = strdup(yytext+1); 
                              yylval.str[strlen(yylval.str)-1] = '\0'; 
                              return STRING; 
                            }
[ \t\n]                     ; /* skip whitespace */
.                           { yyerror("Invalid character"); }
%%

int yywrap(void) {
    return 1;
}