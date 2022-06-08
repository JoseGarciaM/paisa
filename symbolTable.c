#include <stdio.h>
#include <string.h>
#include "symbolTable.h"

int table_size = 0;
Symbol table[TABLE_MAX_SIZE];

int params_len = 0;
Symbol func_params[20];

int struct_len = 0;
Symbol struct_mems[20];

int isNumeric(char *key){
    char type[TYPE_NAME_MAX_SIZE];
    strcpy(type, getType(key));
    if(strcmp(type, "int") == 0 || strcmp(type, "float") == 0){
        return 1;
    }
    return 0;
}

int addToSymbolTable(char *new_key, char *new_type){
    int i = 0;
    for (i = 0; i < table_size; i++)
    {
        if (strcmp(table[i].key, new_key) == 0)
        {
            // printf("ERROR KEY: %s with TYPE %s already exists in table\n", new_key, new_type);
            return 1; //ya existe
        }
    }
    strcpy(table[i].key, new_key);
    strcpy(table[i].type, new_type);
    printf("Symbol added:\nKey: %s\nType: %s\n\n", new_key, new_type);
    table_size++;
    return 0;
}

char *getType(char *key){
    int i;
    for (i = 0; i < table_size; i++)
    {
        if (strcmp(key, table[i].key) == 0)
        {
            return table[i].type;
        }
    }
    return "";
}

int areMatchingTypes(char *id_1, char *id_2){   
    if(strcmp(getType(id_1), getType(id_2)) == 0){
        return 1;
    }
    return 0;
}

int isFunction(char *key){
    if(strcmp(getType(key), "function") == 0){
        return 1;
    }
    return 0;
}


int isArray(char *key){
    if(strcmp(getType(key), "array") == 0){
        return 1;
    }
    return 0;
}

char *addType(char *new_type){
    int i;
    for (i = 0; i < table_size; i++)
    {
        if (strcmp(table[i].type, new_type) == 0)
        {
            printf("%s %s type is already defined \n", table[i].type, new_type);
            return table[i].type;
        }
        else
        {
            if (new_type == "int" || new_type == "float" || new_type == "char" || new_type == "vacio")
            {
                strcpy(table[i].type, new_type);
                printf("Type %s updated\n", new_type);
            }
            else
            {
                printf("ERROR: Type %s not compatible\n", new_type);
            }
        }
    }
    return "";
}

int updateSymbol(char *key, char *old_type, char *new_value, char *new_type){
    int i;
    for (i = 0; i < table_size; i++)
    {
        if (strcmp(table[i].key, key) == 0)
        {
            if (strcmp(old_type, new_type) == 0)
            {
                //cambiar valor aqui
                return 0;
            }
            else
            {
                printf("TYPE ERROR: Symbol %s is of type %s. Value given is of type %s\n", key, old_type, new_type);
            }
        }
    }
    //UNDEFINED VARIABLE ERROR
    printf("TYPE ERROR: variable %s is not defined.\n", key);
    return 1;
}

int symbolExists(const char *key){
    int i = 0;
    if (table_size == 0)
    {
        // printf("La tabla esta vacia\n");
        return 0;
    }
    
    // printf("SEARCHING FOR %s\n", key);
    for (i = 0; i < table_size; i++)
    {
        // printf("\tFound %s of type %s (comp: %d)\n", table[i].key, table[i].type, strcmp(table[i].key, key));
        if (strcmp(table[i].key, key) == 0)
        {
            // printf("Key: %s Exists on table\n", key);
            return 1;
        }
    }
    //printf("key is not on table");
    return 0;
  
}

void printSymbolTable(){
    int i;
    printf("============\n");
    printf("SYMBOL TABLE\n");
    printf("length: %d\n", table_size);
    printf("============\n");
    for (i = 0; i < table_size; i++)
    {
        printf("%s %s %s\n", table[i].key, table[i].type, table[i].value);
    }
}

int addFuncParam(char * key, char * type){
    int i;
    for (i = 0; i < params_len; i++)
    {
        if (strcmp(func_params[i].key, key) == 0)
        {
            return 1; //ya existe
        }
    }
    memset(func_params[i].key, 0, 30);
    memset(func_params[i].type, 0, 10);
    strcpy(func_params[i].key, key);
    strcpy(func_params[i].type, type);
    params_len++;
    return 0;
}

void transferFuncParams(char * func_name, char * func_type){
    int i;
    char full_name[60];
    for(i=0; i<params_len; i++){
        memset(full_name, 0, 60);
        sprintf(full_name, "%s.%s", func_name, func_params[i].key);
        addToSymbolTable(full_name, func_params[i].type);
    }
    addToSymbolTable(func_name, func_type);
    params_len = 0;
}

void resetParams(){
    params_len = 0;
}

int addMemberToStruct(char * key, char * type){
    int i=0;
    for(i=0; i<struct_len; i++){
        if(strcmp(struct_mems[i].key, key)==0){
            return 1; //ya existe
        }
    }
    memset(struct_mems[i].key, 0, 30);
    memset(struct_mems[i].type, 0, 10);
    strcpy(struct_mems[i].key, key);
    strcpy(struct_mems[i].type, type);
    struct_len++;
    return 0;
}

void transferStructMems(char * struct_name){
    int i;
    char full_name[60];
    for(i=0; i<struct_len; i++){
        memset(full_name, 0, 60);
        sprintf(full_name, "%s.%s", struct_name, struct_mems[i].key);
        addToSymbolTable(full_name, struct_mems[i].type);
    }
    addToSymbolTable(struct_name, "struct");
    struct_len = 0;
}

void resetStruct(){
    struct_len = 0;
}

int structMemExists(char * struct_name, char * mem_name){
    char full_name[60];
    sprintf(full_name, "%s.%s", struct_name, mem_name);
    return symbolExists(full_name);
}

int structMemNumeric(char * struct_name, char * mem_name){
    char full_name[60];
    sprintf(full_name, "%s.%s", struct_name, mem_name);
    return isNumeric(full_name);
}

int structMatchesID(char * struct_name, char * mem_name, char * reg_id){
    char full_name[60];
    sprintf(full_name, "%s.%s", struct_name, mem_name);
    if(strcmp(getType(full_name), getType(reg_id))==0){
        return 1;
    }
    return 0;
}

int structTypesMatch(char * struct_a, char * mem_a, char * struct_b, char * mem_b){
    char full_name_a[60];
    char full_name_b[60];
    sprintf(full_name_a, "%s.%s", struct_a, mem_a);
    sprintf(full_name_b, "%s.%s", struct_b, mem_b);
    return areMatchingTypes(full_name_b, full_name_a);
}

char * getStructMemType(char * struct_name, char * mem_name){
    char full_name[60];
    sprintf(full_name, "%s.%s", struct_name, mem_name);
    return getType(full_name);
}

int structMatchesArr(char * struct_name, char * mem_name, char * arr_name){
    char full_name[60];
    sprintf(full_name, "%s.%s", struct_name, mem_name);
    return arrMatchesID(getType(arr_name), getType(full_name));
}

int arrMatchesID(char * arr_id, char * reg_id){
    char arr_type[10];
    strcpy(arr_type, getType(arr_id));
    char reg_type[10];
    strcpy(reg_type, getType(reg_id));
    if(strcmp(arr_type, "intarr")==0 && strcmp(reg_type, "int")==0){
        return 1;
    }else if(strcmp(arr_type, "floatarr")==0 && strcmp(reg_type, "float")==0){
        return 1;
    }else if(strcmp(arr_type, "chararr")==0 && strcmp(reg_type, "char")==0){
        return 1;
    }else if(strcmp(arr_type, "boolarr")==0 && strcmp(reg_type, "bool")==0){
        return 1;
    }else{
        return 0;
    }
}

int arrIsNumeric(char * arr_id){
    char type[10];
    strcpy(type, getType(arr_id));
    if(strcmp(type, "intarr")==0 || strcmp(type, "floatarr")==0){
        return 1;
    }
    return 0;
}

// int main(){
//     // Symbol sym_table[10];
//     // addToSymbolTable(sym_table, "a", "function", "5");

//     // getType(sym_table, "a");
//     // isFunction(sym_table,"a");

//     // printSymbolTable(sym_table);

//     // symbolExists(sym_table, "a");

//     return 0;
// }