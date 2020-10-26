CC=gcc -g

all: bin/predict bin/learn src/db.h
	./init.sh

predict: src/predict.c src/db.h
	$(CC) src/predict.c -o bin/predict

learn: src/learn.c src/db.h
	$(CC) src/learn.c -o bin/learn

clean:
	rm data/*
	rm bin/*


install-docker-requirements:
	apk add gcc make libc-dev
