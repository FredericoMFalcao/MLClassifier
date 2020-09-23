SHELL=/bin/bash
all: _compiled.sql
_compiled.sql: $(shell find . -name "*.sql -not _compiled.sql")
	$(shell cat $$(find . -name "*.sql" | sort) > _compiled.sql)
