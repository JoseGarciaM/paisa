%{
#include<stdio.h>
#include<string.h>
extern int yylex(void);
extern int line_number;
void yyerror(char *s);

#include "symbolTable.h"
%}

%union{
  int ival;
  float fval;
  char cval;
  char * sval;
}

%type<sval> ID
%type<ival> INTNUM
%type<fval> FLOATNUM
%type<cval> CHARLITERAL

%start program
%token INICIO FINAL
%token SEMI COMMA DOT
%token ID INT FLOAT CHAR VACIO STRUCT FUNC RETURN BOOL
%token ADDITION SUBTRACTION MULTIPLICATION DIVIDE MOD LPAREN RPAREN
%token INTNUM FLOATNUM CHARLITERAL STRINGLITERAL
%token BOOLVAL NULLVAL
%token NOT 
%token GETS PUTS PUTSLN
%token ASSIGNMENT_OPERATOR LBRACKET RBRACKET LBRACE RBRACE NUMBER AND OR EQUALS NOT_EQUALS LESS_THAN GREATER_THAN LESS_EQUAL GREATER_EQUAL
%token SELECTION_IF SELECTION_ELSE
%token LOOP_FOR LOOP_DOWHILE LOOP_WHILE

%%
program: INICIO statement_list FINAL {printSymbolTable();}

statement: declaration_statement SEMI
          | arithmetic_operation SEMI
          | selection_statement
          | std_in_out_statement SEMI
          | function_declaration
          | function_call SEMI
          | struct_definition
          | struct_member_reference SEMI
          | assignment_statement SEMI
          | iteration_statment
          | array_definition SEMI
          ;

statement_list: statement
              | statement_list statement
              ;

declaration_statement: INT ID    {if(addToSymbolTable($2, "int")==1){printf("ERROR (line %d): Symbol '%s' is already defined.\n", line_number, $2);}}
                    | FLOAT ID   {if(addToSymbolTable($2, "float")==1){printf("ERROR (line %d): Symbol '%s' is already defined.\n", line_number, $2);}}
                    | CHAR ID    {if(addToSymbolTable($2, "char")==1){printf("ERROR (line %d): Symbol '%s' is already defined.\n", line_number, $2);}}
                    | BOOL ID    {if(addToSymbolTable($2, "bool")==1){printf("ERROR (line %d): Symbol '%s' is already defined.\n", line_number, $2);}}
                    ;

sum_operation: ID ADDITION ID               {if(symbolExists($1) && symbolExists($3) && isNumeric($1) && isNumeric($3)){}else{printf("1 is numeric %d, 1 defined %d, 3 is numeric %d, 3 is defined %d, 3 is '%s'\n", isNumeric($1), symbolExists($1), isNumeric($3), symbolExists($3), $3); printf("TYPE ERROR (line %d): the symbol '%s' and '%s' must both be defined and of type 'int' or 'float'.\n", line_number, $1, $3);}}
              | ID ADDITION INTNUM          {if(symbolExists($1) && isNumeric($1)){}else{printf("TYPE ERROR (line %d): symbol '%s' must be of type 'int' or 'float'\n", line_number, $1);}}
              | ID ADDITION FLOATNUM        {if(symbolExists($1) && isNumeric($1)){}else{printf("TYPE ERROR (line %d): symbol '%s' must be of type 'int' or 'float'\n", line_number, $1);}}
              | INTNUM ADDITION ID          {if(symbolExists($3) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): symbol '%s' must be of type 'int' or 'float'\n", line_number, $3);}}
              | INTNUM ADDITION INTNUM      {}
              | INTNUM ADDITION FLOATNUM    {}
              | FLOATNUM ADDITION ID        {if(symbolExists($3) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): symbol '%s' must be of type 'int' or 'float'\n", line_number, $3);}}  
              | FLOATNUM ADDITION INTNUM    {}
              | FLOATNUM ADDITION FLOATNUM  {}
              ;

sub_operation: ID SUBTRACTION ID                {if(symbolExists($1) && symbolExists($3) && isNumeric($1) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): the symbol '%s' and '%s' must both be defined and of type 'int' or 'float'.\n", line_number, $1, $3);}}
              | ID SUBTRACTION INTNUM           {if(symbolExists($1) && isNumeric($1)){}else{printf("TYPE ERROR (line %d): symbol '%s' must be of type 'int' or 'float'\n", line_number, $1);}}
              | ID SUBTRACTION FLOATNUM         {if(symbolExists($1) && isNumeric($1)){}else{printf("TYPE ERROR (line %d): symbol '%s' must be of type 'int' or 'float'\n", line_number, $1);}}
              | INTNUM SUBTRACTION ID           {if(symbolExists($3) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): symbol '%s' must be of type 'int' or 'float'\n", line_number, $3);}}
              | INTNUM SUBTRACTION INTNUM       {}
              | INTNUM SUBTRACTION FLOATNUM     {}
              | FLOATNUM SUBTRACTION ID         {if(symbolExists($3) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): symbol '%s' must be of type 'int' or 'float'\n", line_number, $3);}}
              | FLOATNUM SUBTRACTION INTNUM     {}
              | FLOATNUM SUBTRACTION FLOATNUM   {}
              ;

mult_operation: ID MULTIPLICATION ID              {if(symbolExists($1) && symbolExists($3) && isNumeric($1) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): the symbol '%s' and '%s' must both be defined and of type 'int' or 'float'.\n", line_number, $1, $3);}}
              | ID MULTIPLICATION INTNUM          {if(symbolExists($1) && isNumeric($1)){}else{printf("TYPE ERROR (line %d): symbol '%s' must be of type 'int' or 'float'\n", line_number, $1);}}
              | ID MULTIPLICATION FLOATNUM        {if(symbolExists($1) && isNumeric($1)){}else{printf("TYPE ERROR (line %d): symbol '%s' must be of type 'int' or 'float'\n", line_number, $1);}}
              | INTNUM MULTIPLICATION ID          {if(symbolExists($3) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): symbol '%s' must be of type 'int' or 'float'\n", line_number, $3);}}
              | INTNUM MULTIPLICATION INTNUM      {}
              | INTNUM MULTIPLICATION FLOATNUM    {}
              | FLOATNUM MULTIPLICATION ID        {if(symbolExists($3) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): symbol '%s' must be of type 'int' or 'float'\n", line_number, $3);}}
              | FLOATNUM MULTIPLICATION INTNUM    {}
              | FLOATNUM MULTIPLICATION FLOATNUM  {}
              ;

div_operation: ID DIVIDE ID               {if(symbolExists($1) && symbolExists($3) && isNumeric($1) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): the symbol '%s' and '%s' must both be defined and of type 'int' or 'float'.\n", line_number, $1, $3);}}
              | ID DIVIDE INTNUM          {if(symbolExists($1) && isNumeric($1)){}else{printf("TYPE ERROR (line %d): symbol '%s' must be of type 'int' or 'float'\n", line_number, $1);}}
              | ID DIVIDE FLOATNUM        {if(symbolExists($1) && isNumeric($1)){}else{printf("TYPE ERROR (line %d): symbol '%s' must be of type 'int' or 'float'\n", line_number, $1);}}
              | INTNUM DIVIDE ID          {if(symbolExists($3) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): symbol '%s' must be of type 'int' or 'float'\n", line_number, $3);}}
              | INTNUM DIVIDE INTNUM      {}
              | INTNUM DIVIDE FLOATNUM    {}
              | FLOATNUM DIVIDE ID        {if(symbolExists($3) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): symbol '%s' must be of type 'int' or 'float'\n", line_number, $3);}}
              | FLOATNUM DIVIDE INTNUM    {}
              | FLOATNUM DIVIDE FLOATNUM  {}
              ;

mod_operation: ID MOD ID                {if(symbolExists($1) && symbolExists($3) && isNumeric($1) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): the symbol '%s' and '%s' must both be defined and of type 'int' or 'float'.\n", line_number, $1, $3);}}
              | ID MOD INTNUM           {if(symbolExists($1) && isNumeric($1)){}else{printf("TYPE ERROR (line %d): symbol '%s' must be of type 'int' or 'float'\n", line_number, $1);}}
              | ID MOD FLOATNUM         {if(symbolExists($1) && isNumeric($1)){}else{printf("TYPE ERROR (line %d): symbol '%s' must be of type 'int' or 'float'\n", line_number, $1);}}
              | INTNUM MOD ID           {if(symbolExists($3) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): symbol '%s' must be of type 'int' or 'float'\n", line_number, $3);}}
              | INTNUM MOD INTNUM       {}
              | INTNUM MOD FLOATNUM     {}
              | FLOATNUM MOD ID         {if(symbolExists($3) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): symbol '%s' must be of type 'int' or 'float'\n", line_number, $3);}}
              | FLOATNUM MOD INTNUM     {}
              | FLOATNUM MOD FLOATNUM   {}
              ;

arithmetic_operation: sum_operation
                    | sub_operation
                    | mult_operation
                    | div_operation
                    | mod_operation
                    ;

equality_expression: ID EQUALS ID               {if(symbolExists($1) && symbolExists($3) && areMatchingTypes($1, $3)){}else{printf("TYPE ERROR (line %d): symbols '%s' and '%s' must be compatible types to be compared.\n", line_number, $1, $3);}}
                    | ID EQUALS INTNUM          {if(symbolExists($1) && isNumeric($1)){}else{printf("TYPE ERROR (line %d): Symbol %s must be numeric to be compared with type 'int'.\n", line_number, $1);}}
                    | ID EQUALS FLOATNUM        {if(symbolExists($1) && isNumeric($1)){}else{printf("TYPE ERROR (line %d): Symbol %s must be numeric to be compared with type 'float'.\n", line_number, $1);}}
                    | ID EQUALS BOOLVAL         {if(symbolExists($1) && strcmp(getType($1), "bool")==0){}else{printf("TYPE ERROR (line %d): Symbol %s must be boolean to be compared with type 'bool'.\n", line_number, $1);}}
                    | INTNUM EQUALS ID          {if(symbolExists($3) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): Symbol %s must be numeric to be compared with type 'int'.\n", line_number, $3);}}
                    | INTNUM EQUALS INTNUM
                    | INTNUM EQUALS FLOATNUM
                    | FLOATNUM EQUALS ID        {if(symbolExists($3) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): Symbol %s must be numeric to be compared with type 'float'.\n", line_number, $3);}}
                    | FLOATNUM EQUALS INTNUM
                    | FLOATNUM EQUALS FLOATNUM 
                    | BOOLVAL EQUALS BOOLVAL
                    | BOOLVAL EQUALS ID         {if(symbolExists($3) && strcmp(getType($3), "bool")==0){}else{printf("TYPE ERROR (line %d): Symbol %s must be boolean to be compared with type 'bool'.\n", line_number, $3);}}
                    ;

inequality_expression: ID NOT_EQUALS ID             {if(symbolExists($1) && symbolExists($3) && areMatchingTypes($1, $3)){}else{printf("TYPE ERROR (line %d): symbols '%s' and '%s' must be compatible types to be compared.\n", line_number, $1, $3);}}
                    | ID NOT_EQUALS INTNUM          {if(symbolExists($1) && isNumeric($1)){}else{printf("TYPE ERROR (line %d): Symbol %s must be numeric to be compared with type 'int'.\n", line_number, $1);}}
                    | ID NOT_EQUALS FLOATNUM        {if(symbolExists($1) && isNumeric($1)){}else{printf("TYPE ERROR (line %d): Symbol %s must be numeric to be compared with type 'float'.\n", line_number, $1);}}
                    | ID NOT_EQUALS BOOLVAL         {if(symbolExists($1) && strcmp(getType($1), "bool")==0){}else{printf("TYPE ERROR (line %d): Symbol %s must be boolean to be compared with type 'bool'.\n", line_number, $1);}}
                    | INTNUM NOT_EQUALS ID          {if(symbolExists($3) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): Symbol %s must be numeric to be compared with type 'int'.\n", line_number, $3);}}
                    | INTNUM NOT_EQUALS INTNUM
                    | INTNUM NOT_EQUALS FLOATNUM
                    | FLOATNUM NOT_EQUALS ID        {if(symbolExists($3) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): Symbol %s must be numeric to be compared with type 'float'.\n", line_number, $3);}}
                    | FLOATNUM NOT_EQUALS INTNUM
                    | FLOATNUM NOT_EQUALS FLOATNUM
                    | BOOLVAL NOT_EQUALS BOOLVAL
                    | BOOLVAL NOT_EQUALS ID         {if(symbolExists($3) && strcmp(getType($3), "bool")==0){}else{printf("TYPE ERROR (line %d): Symbol %s must be boolean to be compared with type 'bool'.\n", line_number, $3);}}
                    ;

lessthan_expression: ID LESS_THAN ID                {if(symbolExists($1) && symbolExists($3) && areMatchingTypes($1, $3)){}else{printf("TYPE ERROR (line %d): symbols '%s' and '%s' must be compatible types to be compared.\n", line_number, $1, $3);}}
                    | ID LESS_THAN INTNUM           {if(symbolExists($1) && isNumeric($1)){}else{printf("TYPE ERROR (line %d): Symbol %s must be numeric to be compared with type 'int'.\n", line_number, $1);}}   
                    | ID LESS_THAN FLOATNUM         {if(symbolExists($1) && isNumeric($1)){}else{printf("TYPE ERROR (line %d): Symbol %s must be numeric to be compared with type 'float'.\n", line_number, $1);}}
                    | INTNUM LESS_THAN ID           {if(symbolExists($3) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): Symbol %s must be numeric to be compared with type 'int'.\n", line_number, $3);}}
                    | INTNUM LESS_THAN INTNUM       {}
                    | INTNUM LESS_THAN FLOATNUM     {}
                    | FLOATNUM LESS_THAN ID         {if(symbolExists($3) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): Symbol %s must be numeric to be compared with type 'float'.\n", line_number, $3);}}
                    | FLOATNUM LESS_THAN INTNUM     {}
                    | FLOATNUM LESS_THAN FLOATNUM   {}
                    ;

greaterthan_expression: ID GREATER_THAN ID          {if(symbolExists($1) && symbolExists($3) && areMatchingTypes($1, $3)){}else{printf("TYPE ERROR (line %d): symbols '%s' and '%s' must be compatible types to be compared.\n", line_number, $1, $3);}}
                    | ID GREATER_THAN INTNUM        {if(symbolExists($1) && isNumeric($1)){}else{printf("TYPE ERROR (line %d): Symbol %s must be numeric to be compared with type 'int'.\n", line_number, $1);}}
                    | ID GREATER_THAN FLOATNUM      {if(symbolExists($1) && isNumeric($1)){}else{printf("TYPE ERROR (line %d): Symbol %s must be numeric to be compared with type 'float'.\n", line_number, $1);}}
                    | INTNUM GREATER_THAN ID        {{if(symbolExists($3) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): Symbol %s must be numeric to be compared with type 'int'.\n", line_number, $3);}}}
                    | INTNUM GREATER_THAN INTNUM
                    | INTNUM GREATER_THAN FLOATNUM
                    | FLOATNUM GREATER_THAN ID      {if(symbolExists($3) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): Symbol %s must be numeric to be compared with type 'float'.\n", line_number, $3);}}
                    | FLOATNUM GREATER_THAN INTNUM
                    | FLOATNUM GREATER_THAN FLOATNUM
                    ;

lessequal_expression: ID LESS_EQUAL ID              {if(symbolExists($1) && symbolExists($3) && areMatchingTypes($1, $3)){}else{printf("TYPE ERROR (line %d): symbols '%s' and '%s' must be compatible types to be compared.\n", line_number, $1, $3);}}
                    | ID LESS_EQUAL INTNUM          {if(symbolExists($1) && isNumeric($1)){}else{printf("TYPE ERROR (line %d): Symbol %s must be numeric to be compared with type 'int'.\n", line_number, $1);}}
                    | ID LESS_EQUAL FLOATNUM        {if(symbolExists($1) && isNumeric($1)){}else{printf("TYPE ERROR (line %d): Symbol %s must be numeric to be compared with type 'float'.\n", line_number, $1);}}
                    | INTNUM LESS_EQUAL ID          {if(symbolExists($3) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): Symbol %s must be numeric to be compared with type 'int'.\n", line_number, $3);}}
                    | INTNUM LESS_EQUAL INTNUM
                    | INTNUM LESS_EQUAL FLOATNUM
                    | FLOATNUM LESS_EQUAL ID        {if(symbolExists($3) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): Symbol %s must be numeric to be compared with type 'float'.\n", line_number, $3);}}
                    | FLOATNUM LESS_EQUAL INTNUM
                    | FLOATNUM LESS_EQUAL FLOATNUM  
                    ;

greaterequal_expression: ID GREATER_EQUAL ID            {if(symbolExists($1) && symbolExists($3) && areMatchingTypes($1, $3)){}else{printf("TYPE ERROR (line %d): symbols '%s' and '%s' must be compatible types to be compared.\n", line_number, $1, $3);}}
                    | ID GREATER_EQUAL INTNUM           {if(symbolExists($1) && isNumeric($1)){}else{printf("TYPE ERROR (line %d): Symbol %s must be numeric to be compared with type 'int'.\n", line_number, $1);}}
                    | ID GREATER_EQUAL FLOATNUM         {if(symbolExists($1) && isNumeric($1)){}else{printf("TYPE ERROR (line %d): Symbol %s must be numeric to be compared with type 'float'.\n", line_number, $1);}}
                    | INTNUM GREATER_EQUAL ID           {if(symbolExists($3) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): Symbol %s must be numeric to be compared with type 'int'.\n", line_number, $3);}}
                    | INTNUM GREATER_EQUAL INTNUM
                    | INTNUM GREATER_EQUAL FLOATNUM
                    | FLOATNUM GREATER_EQUAL ID         {if(symbolExists($3) && isNumeric($3)){}else{printf("TYPE ERROR (line %d): Symbol %s must be numeric to be compared with type 'float'.\n", line_number, $3);}}
                    | FLOATNUM GREATER_EQUAL INTNUM
                    | FLOATNUM GREATER_EQUAL FLOATNUM   
                    ;

conditional_expression: equality_expression     {}
                      | inequality_expression   {}
                      | lessthan_expression     {}
                      | greaterthan_expression  {}
                      | lessequal_expression    {}
                      | greaterequal_expression {}
                      | ID        {if(symbolExists($1) && strcmp(getType($1), "bool")==0){}else{printf("TYPE ERROR (line %d): Symbol '%s' must be of type 'bool' to be used as a conditional expression.\n", line_number, $1);}}
                      | BOOLVAL
                      ;

compound_conditional: conditional_expression 
                    | NOT conditional_expression
                    | LPAREN conditional_expression RPAREN AND LPAREN conditional_expression RPAREN
                    | LPAREN conditional_expression RPAREN OR LPAREN conditional_expression RPAREN
                    | compound_conditional AND LPAREN conditional_expression RPAREN
                    | compound_conditional OR LPAREN conditional_expression RPAREN
                    | LPAREN conditional_expression RPAREN AND compound_conditional
                    | LPAREN conditional_expression RPAREN OR compound_conditional
                    ;

selection_statement: SELECTION_IF LPAREN compound_conditional RPAREN LBRACE statement_list RBRACE   {}
                    | SELECTION_IF LPAREN compound_conditional RPAREN LBRACE statement_list RBRACE SELECTION_ELSE LBRACE statement_list RBRACE {}
                    ;

std_in_out_statement: stdin_func      
                    | stdout_func     
                    | stdout_ln_func  
                    ;

stdin_func: GETS ID {if(symbolExists($2)==0){printf("ERROR (line %d): Symbol '%s' is undefined.\n", line_number, $2);}}
          ;

stdout_func: PUTS ID            {if(symbolExists($2)==0){printf("ERROR (line %d): Symbol '%s' is undefined.\n", line_number, $2);}}
            | PUTS CHARLITERAL  {}
            | PUTS INTNUM       {}
            | PUTS FLOATNUM     {}
            ;

stdout_ln_func: PUTSLN ID           {if(symbolExists($2)==0){printf("ERROR (line %d): Symbol '%s' is undefined.\n", line_number, $2);}}
              | PUTSLN CHARLITERAL  {}
              | PUTSLN INTNUM       {}
              | PUTSLN FLOATNUM     {}
              ;

function_declaration: FUNC ID LPAREN func_declaration_list RPAREN INT LBRACE statement_list RBRACE      {if(symbolExists($2)==0){transferFuncParams($2, "intfunc");}else{resetParams();printf("ERROR (line %d): Symbol %s is already defined.\n", line_number, $2);}}
                    | FUNC ID LPAREN func_declaration_list RPAREN FLOAT LBRACE statement_list RBRACE    {if(symbolExists($2)==0){transferFuncParams($2, "floatfunc");}else{resetParams();printf("ERROR (line %d): Symbol %s is already defined.\n", line_number, $2);}}
                    | FUNC ID LPAREN func_declaration_list RPAREN CHAR LBRACE statement_list RBRACE     {if(symbolExists($2)==0){transferFuncParams($2, "charfunc");}else{resetParams();printf("ERROR (line %d): Symbol %s is already defined.\n", line_number, $2);}}
                    | FUNC ID LPAREN func_declaration_list RPAREN VACIO LBRACE statement_list RBRACE   {if(symbolExists($2)==0){transferFuncParams($2, "voidfunc");}else{resetParams();printf("ERROR (line %d): Symbol %s is already defined.\n", line_number, $2);}}
                    | FUNC ID LPAREN func_declaration_list RPAREN BOOL LBRACE statement_list RBRACE     {if(symbolExists($2)==0){transferFuncParams($2, "boolfunc");}else{resetParams();printf("ERROR (line %d): Symbol %s is already defined.\n", line_number, $2);}}
                    ;

func_declaration_list: func_param_declaration 
                | func_param_declaration COMMA func_declaration_list 
                | 
                ;

func_param_declaration: INT ID    {if(addFuncParam($2, "int") == 0){}else{printf("ERROR (line %d): Function parameter '%s' already defined.\n",line_number, $2);}}
                      | CHAR ID   {if(addFuncParam($2, "char") == 0){}else{printf("ERROR (line %d): Function parameter '%s' already defined.\n",line_number, $2);}}
                      | FLOAT ID  {if(addFuncParam($2, "float") == 0){}else{printf("ERROR (line %d): Function parameter '%s' already defined.\n",line_number, $2);}}
                      | BOOL ID   {if(addFuncParam($2, "bool") == 0){}else{printf("ERROR (line %d): Function parameter '%s' already defined.\n",line_number, $2);}}
                      ;

function_call: ID LPAREN parameter_list RPAREN {}
              ;

parameter_list: func_call_param
              | func_call_param COMMA parameter_list
              | 
              ;

func_call_param: ID
              | INTNUM
              | CHARLITERAL
              | FLOATNUM
              | BOOLVAL
              ;

struct_definition: STRUCT ID LBRACE struct_declaration_list RBRACE {if(symbolExists($2)==0){transferStructMems($2);}else{resetStruct();printf("ERROR (line %d): Symbol %s is already defined.\n", line_number, $2);}}
                ;

struct_declaration_list: struct_declaration SEMI
                      | struct_declaration SEMI struct_declaration_list
                      |
                      ;

struct_declaration: INT ID     {if(addMemberToStruct($2, "int")==0){}else{printf("ERROR (line %d): Struct member '%s' is already defined.\n", line_number, $2);}}
                  | CHAR ID    {if(addMemberToStruct($2, "char")==0){}else{printf("ERROR (line %d): Struct member '%s' is already defined.\n", line_number, $2);}}
                  | FLOAT ID   {if(addMemberToStruct($2, "float")==0){}else{printf("ERROR (line %d): Struct member '%s' is already defined.\n", line_number, $2);}}
                  | BOOL ID    {if(addMemberToStruct($2, "bool")==0){}else{printf("ERROR (line %d): Struct member '%s' is already defined.\n", line_number, $2);}}
                  ;

struct_member_reference: ID DOT ID {if(structMemExists($1, $3)){}else{printf("TYPE ERROR (line %d): '%s.%s' is undefined.\n", line_number, $1, $3);}}
                      ;

iteration_statment: for_loop
                  | while_loop
                  | dowhile_loop
                  ;

for_loop: LOOP_FOR LPAREN optional_assignment SEMI optional_conditional SEMI optional_increment RPAREN LBRACE statement_list RBRACE 
        ;

optional_assignment:  assignment_statement
                    |
                    ;

optional_conditional: conditional_expression
                    |
                    ;

optional_increment: ID ASSIGNMENT_OPERATOR arithmetic_operation {if(symbolExists($1) && isNumeric($1)){}else{printf("TYPE ERROR (line %d): Symbol '%s' must be declared and of numeric type.\n", line_number, $1);}}
                  |
                  ;

while_loop: LOOP_WHILE LPAREN compound_conditional RPAREN RBRACE statement_list LBRACE
          ;

dowhile_loop: LOOP_DOWHILE LBRACE statement_list RBRACE LOOP_WHILE LPAREN compound_conditional RPAREN
            ;


assignment_statement: ID ASSIGNMENT_OPERATOR ID                       {if(symbolExists($1) && symbolExists($3) && areMatchingTypes($1,$3)){}else{printf("TYPE ERROR (line %d): Symbols '%s' and '%s' must both be declared and of matching types.\n", line_number, $1, $3);}}
                    | ID ASSIGNMENT_OPERATOR FLOATNUM                 {if(symbolExists($1) && strcmp(getType($1), "float")==0){}else{printf("TYPE ERROR (line %d): Symbol '%s' must be of type 'float' to assign an float value.\n", line_number, $1);}}
                    | ID ASSIGNMENT_OPERATOR INTNUM                   {if(symbolExists($1) && strcmp(getType($1), "int")==0){}else{printf("TYPE ERROR (line %d): Symbol '%s' must be of type 'int' to assign an integer value.\n", line_number, $1);}}
                    | ID ASSIGNMENT_OPERATOR function_call            {}
                    | ID ASSIGNMENT_OPERATOR arithmetic_operation     {if(symbolExists($1) && isNumeric($1)){}else{printf("TYPE ERROR (line $d): Cannot assign numeric value to non-numeric symbol '%s'.\n", line_number, $1);}}
                    | ID ASSIGNMENT_OPERATOR ID DOT ID                {if(symbolExists($1) && structMemExists($3,$5) && structMatchesID($3,$5,$1)){}else{printf("TYPE ERROR (line %d): Both symbols '%s' and '%s' member of struct '%s' must be of equivalent types to assign values between them.\n", line_number, $1, $5, $3);}}
                    | ID ASSIGNMENT_OPERATOR ID LBRACKET array_index RBRACKET          {if(symbolExists($1) && symbolExists($3) && arrMatchesID($3, $1)){}else{printf("TYPE ERROR (line %d): Symbol '%s' must be the same type as '%s'.\n", line_number, $1, $3);}}
                    | ID ASSIGNMENT_OPERATOR BOOLVAL                  {if(symbolExists($1) && strcmp(getType($1), "bool")==0){}else{printf("TYPE ERROR (line %d): Symbol '%s' must be of type boolean to assign a boolean value.\n", line_number, $1);}}
                    | ID ASSIGNMENT_OPERATOR CHARLITERAL              {if(symbolExists($1) && strcmp(getType($1), "char")==0){}else{printf("TYPE ERROR (line %d): Symbol '%s' must be of type char to assign a char value.\n", line_number, $1);}}
                    | ID DOT ID ASSIGNMENT_OPERATOR ID                {if(symbolExists($5) && structMemExists($1, $3) && structMatchesID($1, $3, $5)){}else{printf("TYPE ERROR (line %d): Symbols '%s' and '%s.%s' must be of the same type.\n", line_number, $5, $1, $3);}}
                    | ID DOT ID ASSIGNMENT_OPERATOR FLOATNUM          {if(structMemExists($1, $3) && strcmp(getStructMemType($1, $3), "float")==0){}else{printf("TYPE ERROR (line %d): Symbol '%s.%s' must be declared and of type 'float' to assign a float value.\n", line_number, $1, $3);}}
                    | ID DOT ID ASSIGNMENT_OPERATOR INTNUM            {if(structMemExists($1, $3) && strcmp(getStructMemType($1, $3), "int")==0){}else{printf("TYPE ERROR (line %d): Symbol '%s.%s' must be declared and of type 'int' to assign an integer value.\n", line_number, $1, $3);}}
                    | ID DOT ID ASSIGNMENT_OPERATOR function_call     {}
                    | ID DOT ID ASSIGNMENT_OPERATOR arithmetic_operation          {if(structMemExists($1, $3) && structMemNumeric($1, $3)){}else{printf("TYPE ERROR (line %d): Symbol '%s.%s' must be declared and of numeric type.\n", line_number, $1, $3);}}
                    | ID DOT ID ASSIGNMENT_OPERATOR ID DOT ID         {if(structMemExists($1, $3) && structMemExists($5, $7) && structTypesMatch($1, $3, $5, $7)){}else{printf("TYPE ERROR (line %d): Struct members must be declared and of matching types.\n", line_number);}}
                    | ID DOT ID ASSIGNMENT_OPERATOR ID LBRACKET array_index RBRACKET   {if(structMemExists($1, $3) && structMatchesArr($1, $3, $5)){}else{printf("TYPE ERROR (line %d): Struct member '%s.%s' and '%s' array element must both be declared and of the same type.\n", line_number, $1, $3, $5);}}
                    | ID DOT ID ASSIGNMENT_OPERATOR BOOLVAL           {if(structMemExists($1, $3) && strcmp(getStructMemType($1, $3), "bool")==0){}else{printf("TYPE ERROR (line %d): Symbol '%s.%s' must be declared and of type 'bool' to assign a boolean value.\n", line_number, $1, $3);}}
                    | ID DOT ID ASSIGNMENT_OPERATOR CHARLITERAL       {if(structMemExists($1, $3) && strcmp(getStructMemType($1, $3), "char")==0){}else{printf("TYPE ERROR (line %d): Symbol '%s.%s' must be declared and of type 'char' to assign a char value.\n", line_number, $1, $3);}}
                    | ID LBRACKET array_index RBRACKET ASSIGNMENT_OPERATOR ID          {if(symbolExists($1) && symbolExists($6) && arrMatchesID($1, $6)){}else{printf("TYPE ERROR (line %d): Array '%s' must be the same type as symbol '%s'.\n", line_number, $1, $6);}}
                    | ID LBRACKET array_index RBRACKET ASSIGNMENT_OPERATOR FLOATNUM    {if(symbolExists($1) && strcmp(getType($1), "floatarr")==0){}else{printf("TYPE ERROR (line %d): Array '%s' must be of type 'float'.\n", line_number, $1);}}
                    | ID LBRACKET array_index RBRACKET ASSIGNMENT_OPERATOR INTNUM      {if(symbolExists($1) && strcmp(getType($1), "intarr")==0){}else{printf("TYPE ERROR (line %d): Array '%s' must be of type 'int'.\n", line_number, $1);}}
                    | ID LBRACKET array_index RBRACKET ASSIGNMENT_OPERATOR function_call               {}
                    | ID LBRACKET array_index RBRACKET ASSIGNMENT_OPERATOR arithmetic_operation        {if(symbolExists($1) && arrIsNumeric($1)){}else{printf("TYPE ERROR (line %d): Array '%s' must be of numeric type.\n", line_number, $1);}}
                    | ID LBRACKET array_index RBRACKET ASSIGNMENT_OPERATOR ID DOT ID   {if(symbolExists($1) && structMemExists($6, $8) && structMatchesArr($6, $8, $1)){}else{printf("TYPE ERROR (line %d): Array '%s' and struct member '%s.%s' must be of compatible types.\n", line_number, $1, $6, $8);}}
                    | ID LBRACKET array_index RBRACKET ASSIGNMENT_OPERATOR ID LBRACKET array_index RBRACKET {if(symbolExists($1) && symbolExists($6) && areMatchingTypes($1, $6)){}else{printf("TYPE ERROR (line %d): Arrays '%s' and '%s' must be of the same type.", line_number, $1, $6);}}
                    | ID LBRACKET array_index RBRACKET ASSIGNMENT_OPERATOR BOOLVAL     {if(symbolExists($1) && strcmp(getType($1), "boolarr")==0){}else{printf("TYPE ERROR (line %d): Array '%s' must be of type 'boolean'.\n", line_number, $1);}}
                    | ID LBRACKET array_index RBRACKET ASSIGNMENT_OPERATOR CHARLITERAL                 {if(symbolExists($1) && strcmp(getType($1), "chararr")==0){}else{printf("TYPE ERROR (line %d): Array '%s' must be of type 'char'.\n", line_number, $1);}}
                    ;

array_definition: INT ID LBRACKET INTNUM RBRACKET     {if(addToSymbolTable($2, "intarr")==1){printf("ERROR (line %d): Array '%s' is already defined.\n", line_number, $2);}}
                | FLOAT ID LBRACKET INTNUM RBRACKET   {if(addToSymbolTable($2, "floatarr")==1){printf("ERROR (line %d): Array '%s' is already defined.\n", line_number, $2);}}
                | CHAR ID LBRACKET INTNUM RBRACKET    {if(addToSymbolTable($2, "chararr")==1){printf("ERROR (line %d): Array '%s' is already defined.\n", line_number, $2);}}
                | BOOL ID LBRACKET INTNUM RBRACKET    {if(addToSymbolTable($2, "boolarr")==1){printf("ERROR (line %d): Array '%s' is already defined.\n", line_number, $2);}}
                ;

array_index: INTNUM
            | ID    {if(symbolExists($1) && strcmp(getType($1), "int")==0){}else{printf("TYPE ERROR (line %d): Symbol '%s' used as array reference must be a defined integer type.");}}

%%

void yyerror(char *s) {
  printf("\nline %d: %s\n",line_number,s);
}

int main(void) {
  yyparse();
}
