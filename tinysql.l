%{
#include <stdio.h>
#include <string.h>
#include "tinysql.tab.h"  // Fix: Include Bison header
int yyparse();
void convert_to_sql(char *input);
%}

%%

[A-Za-z0-9 ,=]*\n { convert_to_sql(yytext); }

%%

void convert_to_sql(char *input) {
    char sql[256];

    if (strstr(input, "Show all")) {
        strcpy(sql, "SELECT * FROM students;");
    } else if (strstr(input, "Add")) {
        int id;
        char name[50];
        sscanf(input, "Add %s with ID %d to students", name, &id);
        sprintf(sql, "INSERT INTO students VALUES (%d, '%s');", id, name);
    } else if (strstr(input, "Remove student with ID")) {
        int id;
        sscanf(input, "Remove student with ID %d", &id);
        sprintf(sql, "DELETE FROM students WHERE id = %d;", id);
    } else if (strstr(input, "Change ID of")) {
        int old_id, new_id;
        sscanf(input, "Change ID of %d to %d", &old_id, &new_id);
        sprintf(sql, "UPDATE students SET id = %d WHERE id = %d;", new_id, old_id);
    } else if (strstr(input, "Update student with ID")) {
        int id;
        char field[50], new_value[50];
        sscanf(input, "Update student with ID %d set %s = %s", &id, field, new_value);
        sprintf(sql, "UPDATE students SET %s = '%s' WHERE id = %d;", field, new_value, id);
    } else if (strstr(input, "Find student where")) {
        char field[50], value[50];
        sscanf(input, "Find student where %s = %s", field, value);
        sprintf(sql, "SELECT * FROM students WHERE %s = '%s';", field, value);
    } else {
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
