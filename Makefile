SHELL=/bin/bash
_compiled.sql: $(shell find . -name "*.sql -not _compiled.sql")
	$(shell cat $$(find . -name "*.sql" | sort) > _compiled.sql)
