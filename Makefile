all: main.c implementation.c
	ctags $$(find . -name "*.c")
	gcc -g -Wall -o ml main.c

implementation.c : implementation.c.php
	sed 	-e 's/{{=/<?=/g' \
		-e 's/}}/?>/g' \
		-e 's/{{/<?php/g' \
		implementation.c.php | php > implementation.c

clean:
	rm implementation.c ml
