all: lmsyy.c lms.y HashTable.cpp HashTable.h
	bison -d lms.y && flex lmsyy.c && g++ lms.tab.c lex.yy.c HashTable.cpp -o compiler.out
clean:
	rm lms.tab.c lms.tab.h lex.yy.c compiler.out
