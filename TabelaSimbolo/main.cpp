#include "HashTable.cpp"

int main(){
    hashTable *symbol_table;
    symbol_table = new hashTable();
    //symbol_table->print();
    symbol_table->install("x", "Int");
    symbol_table->install("y", "Int");
    symbol_table->install("z", "Int");
    symbol_table->install("fibonnaci", "procedure");
    symbol_table->enterBlock();
    symbol_table->install("x", "Float");
    symbol_table->install("tmp", "String");
    symbol_table->install("y", "Int");
    symbol_table->print();
    symbol_table->exitBlock();
    symbol_table->print();
    symbol_table->install("a", "Int");
    symbol_table->enterBlock();
    symbol_table->install("a", "Int");
    symbol_table->enterBlock();
    symbol_table->install("a", "Int");
    symbol_table->print();
    return 0;
}
