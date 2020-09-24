SHELL=/bin/bash
_compiled.sql: $(shell find . -name "*.sql -not _compiled.sql")
	$(shell cat $$(find . -name "*.sql" | sort) > _compiled.sql)

install:
	@read -p 'What is the database name for the MLCategorizer? ' DBNAME;\
	mysql -e "DROP DATABASE IF EXISTS $$DBNAME; CREATE DATABASE $$DBNAME";\
	cat _compiled.sql | mysql $$DBNAME
