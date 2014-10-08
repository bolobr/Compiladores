#include "HashTable.h"
#include <iostream>
#include <string>

using namespace std;

hashTable::hashTable(){
    _L = 1;
    _root = 0;
    _level = 1;
    _scope[_level] = 1;
}
void hashTable::st_error(int numero){
    char option;
    switch(numero){
        //case 1: cout<<"Symbols table full"<<endl;
        //case 2: cout<<"Item not found"<<endl;
        //case 3: cout<<"Item already inserted"<<endl;
    }
}

void hashTable::enterBlock(){
    _level++;
    if(_level > NMax)
        st_error(1);
    else
        _scope[_level]=_L;
    //cout<<endl<<"Entry on level "<<_level<<endl;
};

void hashTable::exitBlock(){
    int S, B, k;
    char ident[10];
    S = _L;
    B = _scope[_level];
    while(S>B){
        S--;
        strcpy(ident, _table[S].name);
        k = ident[1];
        _tabHash[k] = _table[S].col;

    }
    //cout<<endl<<"Exiting level "<<endl;
    _level--;
    _L=B;
}

int hashTable::getEntry(char x[10]){
    int n, aux, found, k;
    found = 0;
    n = x[0];
    k = _tabHash[n];
    while((k!=0)&&(found==0)){
        aux = strcmp(_table[k].name,x);
        if(aux == 0)
            found =1;
        else
            k = _table[k].col;
    }
    if (found == 0){
    //    cout<<"Item is in level "<<_table[k].level;
    //    cout<<"           index "<<k;
        return k;
    }
    else{
        st_error(2);
        return 0;
    }
}

void hashTable::install(char x[10], char attr[10]){
    int n, equal, k, aux;
    equal = 0;
    n = x[0];
    k = _tabHash[n];
    while(k >= _scope[_level]){
        aux = strcmp(_table[k].name, x);
        if (aux == 0){
            st_error(3);
            equal =1;
        }
        k = _table[k].col;
    }
    if (_L==NMax+1) st_error(1);
    else if(equal == 0){
        _table[_L].level=_level;
        aux = strlen(attr);
        for (k =0; k<aux; k++)
            strcpy(_table[_L].attr, attr);
        aux = strlen(x);
        for (k=0; k<aux; k++)
            _table[_L].name[k]=x[k];
        _table[_L].col = _tabHash[n];
        _tabHash[n]=_L;
        _L++;
    }
}

void hashTable::print(){
    int i;
    cout<<endl<<endl<<"Nome : | ";
    cout<<"Atributo : | ";
    cout<<"Nivel : "<< endl;
    for (i =1; i<=_L-1; i++){

        cout<<_table[i].name<< " | ";
        cout<<_table[i].attr<< " | ";
        cout<<_table[i].level<< endl;
    }

}
