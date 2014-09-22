#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#define NMax 10


typedef struct symbol{
    char name[10];
    int  level;
    char attr[10];
    int  col;
}symbol;

class hashTable{
    int _scope[10];
    int _tabHash[509];
    int _level;
    int _L;
    int _root;
    symbol _table[100];

    public:
    hashTable();
    int  hashing(char *chave[10]);
    void enterBlock();
    void st_error(int numero);
    void exitBlock();
    int  getEntry(char name[10]);
    void install(char name[10], char attr[10]);
    void print();
};




