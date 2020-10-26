#!/bin/bash

TMP_FILE=$(mktemp)

printf ""  > $TMP_FILE
for word in $(cat)
do
	sqlite3 sqlite3.db "INSERT INTO Words (Word) VALUES(\"$word\");" > /dev/null 2> /dev/null
	sqlite3 sqlite3.db "SELECT id FROM Words WHERE Word = \"$word\";" >> $TMP_FILE
done
cat $TMP_FILE | bin/learn

# Clear temp file
[ -e $TMP_FILE ] && rm $TMP_FILE

