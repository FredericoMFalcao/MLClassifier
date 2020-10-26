#!/bin/bash

TMP_FILE=$(mktemp)

if [ "$1" == "init" ]
then
	sqlite3 sqlite3.db "CREATE TABLE Words (id INTEGER PRIMARY KEY AUTOINCREMENT, Word VARCHAR(255) UNIQUE);"
fi

if [ "$1" == "learn" ]
then
	printf ""  > $TMP_FILE
	for word in $(cat)
	do
		sqlite3 sqlite3.db "INSERT INTO Words (Word) VALUES(\"$word\");" > /dev/null 2> /dev/null
		sqlite3 sqlite3.db "SELECT id FROM Words WHERE Word = \"$word\";" >> $TMP_FILE
	done
	cat $TMP_FILE | ./learn
fi

if [ "$1" == "predict" ]
then
	printf "" > $TMP_FILE
	for word in $(cat)
	do
		sqlite3 sqlite3.db "SELECT id FROM Words WHERE Word = \"$word\";" >> $TMP_FILE
	done
	cat $TMP_FILE | ./predict
fi

[ -e $TMP_FILE ] && rm $TMP_FILE
