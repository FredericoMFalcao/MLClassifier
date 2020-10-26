#!/bin/bash
sqlite3 data/sqlite3.db "CREATE TABLE Words (id INTEGER PRIMARY KEY AUTOINCREMENT, Word VARCHAR(255) UNIQUE);"
