/*
create Employees name string, age int, salary int, department string
add to Employees name "Hil Patel", age 22, salary 40000, department "MDES"
select Employees
select name from Employees
select all from Employees
select name from Employees with condition name = "Hil Patel"
select age, salary from Employees with condition department = "MDES"
update salary to 55000 in Employees
update department to "LFI" with condition name = "HIL Patel" in Employees
*/


/*'
//THE FOLLOWING IS THE CFG 






<commands> ::= <create_table_stmt>
            | <insert_stmt>
            | <delete_stmt>
            | <update_stmt>
            | <select_stmt>

<create_table_stmt> ::= CREATE TABLE IDENTIFIER WITH <column_list>

<column_list> ::= IDENTIFIER
               | <column_list> ',' IDENTIFIER

<insert_stmt> ::= ADD <column_list> WITH <value_list> TO IDENTIFIER

<value_list> ::= STRING_LITERAL
              | INT_LITERAL
              | <value_list> ',' STRING_LITERAL
              | <value_list> ',' INT_LITERAL

<delete_stmt> ::= REMOVE FROM IDENTIFIER

<update_stmt> ::= UPDATE IDENTIFIER SET IDENTIFIER '=' STRING_LITERAL

<select_stmt> ::= FIND ALL FROM IDENTIFIER
               | FIND <select_column_list> FROM IDENTIFIER

<select_column_list> ::= IDENTIFIER
                       | <select_column_list> ',' IDENTIFIER

















                       
*/