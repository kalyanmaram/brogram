clear
rm -i *.c *.h *.o
flex -o brogram.yy.c brogram.l
bison -d brogram.y
gcc brogram.tab.c brogram.yy.c -lm -o brogram.exe
