CC=gcc -g

all: predict learn db.h

predict: predict.c db.h
	$(CC) predict.c -o predict

learn: learn.c db.h
	$(CC) learn.c -o learn

clean:
	rm predict learn db.bin sqlite3.db
init:
	./ml init

install-ubuntu-requirements:
	apt install sqlite3 bash gcc
