#!/bin/bash

TMP_FILE=$(mktemp)

printf "" > $TMP_FILE
for word in $(cat)
do
	sqlite3 sqlite3.db "SELECT id FROM Words WHERE Word = \"$word\";" >> $TMP_FILE
done
cat $TMP_FILE | bin/predict

# Clear temp file
[ -e $TMP_FILE ] && rm $TMP_FILE
