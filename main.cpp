#include "HashTable.cpp"

int main(){
    hashTable *symbol_table;
    symbol_table = new hashTable();
    //symbol_table->print();
    symbol_table->install("x", "variable");
    symbol_table->install("y", "variable");
    symbol_table->install("z", "variable");
    symbol_table->install("fibonnaci", "procedure");
    symbol_table->enterBlock();
    symbol_table->install("x", "variable");
    symbol_table->install("tmp", "variable");
    symbol_table->print();
    symbol_table->exitBlock();
    symbol_table->print();
    return 0;
}
