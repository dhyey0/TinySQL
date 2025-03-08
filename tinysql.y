%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

void yyerror(char *s);
int yylex(void);

/* Simplified direct storage for column definitions */
char *columns[100];
char *datatypes[100];
int column_count = 0;

/* Simplified direct storage for insert values */
char *insert_columns[100];
char *insert_values[100];
int insert_pair_count = 0;
%}

%union {
    int num;
    char *str;
    struct {
        char **items;
        int count;
    } list;
}

%token CREATE INSERT SELECT UPDATE DELETE WHERE TO IN FROM COMMA 
%token INT_TYPE STRING_TYPE ALL EQUALS NOT_EQUALS GREATER LESS GREATER_EQUALS LESS_EQUALS
%token <str> IDENTIFIER STRING
%token <num> NUMBER

%type <str> value column_def data_type condition_expr operator

%%

command:
      create_stmt      { printf("SQL query generated successfully.\n"); }
    | insert_stmt      { printf("SQL query generated successfully.\n"); }
    | select_stmt      { printf("SQL query generated successfully.\n"); }
    | update_stmt      { printf("SQL query generated successfully.\n"); }
    | delete_stmt      { printf("SQL query generated successfully.\n"); }
    ;

/* CREATE TABLE statement */
create_stmt: 
    CREATE IDENTIFIER {
        column_count = 0; // Reset the column counter
    } column_list {
        printf("CREATE TABLE %s (\n", $2);
        
        // Print all column definitions
        for (int i = 0; i < column_count; i++) {
            printf("    %s %s", columns[i], datatypes[i]);
            if (i < column_count - 1) {
                printf(",\n");
            } else {
                printf("\n");
            }
            
            // Free memory as we go
            free(columns[i]);
            free(datatypes[i]);
        }
        
        printf(");\n");
        column_count = 0; // Reset for next use
    }
    ;

column_list:
    column_def
    | column_list COMMA column_def
    ;

column_def:
    IDENTIFIER data_type {
        // Store column definition directly
        columns[column_count] = strdup($1);
        datatypes[column_count] = $2; // $2 is already duplicated in data_type
        column_count++;
    }
    ;

data_type:
    INT_TYPE {
        $$ = strdup("INTEGER");
    }
    | STRING_TYPE {
        $$ = strdup("VARCHAR(255)");
    }
    ;

/* INSERT statement */
insert_stmt:
    INSERT IDENTIFIER {
        insert_pair_count = 0; // Reset for new insert
    } column_val_list {
        // Build columns and values string directly
        printf("INSERT INTO %s (", $2);
        
        // Print column list
        for (int i = 0; i < insert_pair_count; i++) {
            printf("%s", insert_columns[i]);
            if (i < insert_pair_count - 1) {
                printf(", ");
            }
        }
        
        printf(")\nVALUES (");
        
        // Print value list
        for (int i = 0; i < insert_pair_count; i++) {
            printf("%s", insert_values[i]);
            if (i < insert_pair_count - 1) {
                printf(", ");
            }
        }
        
        printf(");\n");
        
        // Free memory
        for (int i = 0; i < insert_pair_count; i++) {
            free(insert_columns[i]);
            free(insert_values[i]);
        }
        
        insert_pair_count = 0; // Reset for next use
    }
    ;

column_val_list:
    column_val
    | column_val_list COMMA column_val
    ;

column_val:
    IDENTIFIER value {
        // Store column and value pair directly
        insert_columns[insert_pair_count] = strdup($1);
        insert_values[insert_pair_count] = $2; // $2 is already duplicated in value
        insert_pair_count++;
    }
    ;

/* SELECT statement */
select_stmt:
    SELECT IDENTIFIER {
        printf("SELECT * FROM %s;\n", $2);
    }
    | SELECT select_column_list FROM IDENTIFIER {
        printf(" FROM %s;\n", $4);
    }
    | SELECT select_column_list FROM IDENTIFIER WHERE condition_expr {
        printf(" FROM %s WHERE %s;\n", $4, $6);
    }
    ;

select_column_list:
    ALL {
        printf("SELECT *");
    }
    | IDENTIFIER {
        printf("SELECT %s", $1);
    }
    | select_column_list COMMA IDENTIFIER {
        printf(", %s", $3);
    }
    ;

/* UPDATE statement */
update_stmt:
    UPDATE IDENTIFIER TO value IN IDENTIFIER {
        printf("UPDATE %s SET %s = %s;\n", $6, $2, $4);
    }
    | UPDATE IDENTIFIER TO value WHERE condition_expr IN IDENTIFIER {
        printf("UPDATE %s SET %s = %s WHERE %s;\n", $8, $2, $4, $6);
    }
    ;

/* DELETE statement */
delete_stmt:
    DELETE IDENTIFIER WHERE condition_expr {
        printf("DELETE FROM %s WHERE %s;\n", $2, $4);
    }
    ;

/* Common parts */
value:
    NUMBER {
        char *val;
        asprintf(&val, "%d", $1);
        $$ = val;
    }
    | STRING {
        char *val;
        asprintf(&val, "'%s'", $1);
        $$ = val;
    }
    ;

condition_expr:
    IDENTIFIER operator value {
        char *condition;
        asprintf(&condition, "%s %s %s", $1, $2, $3);
        $$ = condition;
        free($2);
        free($3);
    }
    | IDENTIFIER {
        $$ = $1;
    }
    ;

operator:
    EQUALS {
        $$ = strdup("=");
    }
    | NOT_EQUALS {
        $$ = strdup("<>");
    }
    | GREATER {
        $$ = strdup(">");
    }
    | LESS {
        $$ = strdup("<");
    }
    | GREATER_EQUALS {
        $$ = strdup(">=");
    }
    | LESS_EQUALS {
        $$ = strdup("<=");
    }
    ;

%%

void yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    printf("SQL Translator - Convert laymen instructions to SQL\n");
    printf("Enter a command (Ctrl+D to exit):\n");
    yyparse();
    return 0;
}