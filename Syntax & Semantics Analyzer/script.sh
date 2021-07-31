bison -d -y 1705036.y
echo '1'
g++ -w -c -o y.o y.tab.c
echo '2'
flex 1705036.l
echo '3'
g++ -w -c -o l.o lex.yy.c
echo '4'
g++ 1705036_symbolTable.cpp -c
g++ 1705036_symbolTable.o y.o l.o -lfl
echo '5'
./a.out input.txt
