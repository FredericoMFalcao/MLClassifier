#include <stdio.h>

#define MAX_NO_OF_WORDS 210000
#define MAX_NO_OF_CATEG 400

typedef unsigned int uint;

uint  CategoryId;
uint  WordId;

typedef struct {
	unsigned int Word[MAX_NO_OF_WORDS];
	unsigned int Cat[MAX_NO_OF_CATEG];

	unsigned int WordPerCat[MAX_NO_OF_CATEG][MAX_NO_OF_WORDS];

} Database;

Database db;
