#!/bin/bash
# Change to directory of current source file
cd "$( dirname "${BASH_SOURCE[0]}" )"

PLUGIN_DIR=/usr/lib/mysql/plugin


for FILE_NAME in $(ls *.c);
do
	FUNC_NAME=${FILE_NAME%.c}
	gcc -shared -o $FUNC_NAME.so -I/usr/include/mysql $FUNC_NAME.c && \
	mv $FUNC_NAME.so $PLUGIN_DIR && \
	mysql -e "DROP FUNCTION IF EXISTS $FUNC_NAME; CREATE FUNCTION $FUNC_NAME RETURNS string SONAME '$FUNC_NAME.so'"
done



