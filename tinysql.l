%{
#include <stdio.h>
#include <string.h>
#include "tinysql.tab.h"
int yyparse();
void convert_to_sql(char *input);
%}

%%

[A-Za-z0-9 ,=]*\n { convert_to_sql(yytext); }

%%

void convert_to_sql(char *input) {
    char sql[256];

    if (strstr(input, "Create table")) {
        char table[50], columns[200];
        sscanf(input, "Create table %s with %[^\n]", table, columns);
        sprintf(sql, "CREATE TABLE %s (%s);", table, columns);
    } 
    else if (strstr(input, "Add")) {
        char table[50], name[50];
        int id;
        sscanf(input, "Add %s with ID %d to %s", name, &id, table);
        sprintf(sql, "INSERT INTO %s VALUES (%d, '%s');", table, id, name);
    } 
    else if (strstr(input, "Delete from")) {
        char table[50], condition[100];
        sscanf(input, "Delete from %s with %[^\n]", table, condition);
        sprintf(sql, "DELETE FROM %s WHERE %s;", table, condition);
    } 
    else if (strstr(input, "Update")) {
        char table[50], updates[100], condition[100];
        sscanf(input, "Update %s set %[^w] where %[^\n]", table, updates, condition);
        sprintf(sql, "UPDATE %s SET %s WHERE %s;", table, updates, condition);
    } 
    else if (strstr(input, "Find")) {
        char table[50], condition[100];
        sscanf(input, "Find %s where %[^\n]", table, condition);
        sprintf(sql, "SELECT * FROM %s WHERE %s;", table, condition);
    } 
    else {
        printf("Invalid query format!\n");
        return;
    }

    printf("Converted to SQL: %s\n", sql);
}

int yywrap() {
    return 1;
}

int main() {
    yyparse();
    return 0;
}
