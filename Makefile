all: paisa

parser.tab.c parser.tab.h:	parser.y
	bison -t -v -d parser.y

lex.yy.c: lexer.l parser.tab.h
	flex lexer.l

paisa: lex.yy.c parser.tab.c parser.tab.h
	gcc -ll parser.tab.c lex.yy.c symbolTable.c -o paisa

clean:
	$(RM) paisa parser.tab.c lex.yy.c parser.tab.h parser.output paisa.exe
