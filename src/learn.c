#include "db.h"

int main() 
{

	/*
	*  1. Read INITIAL DB STATE from file
	*
	*/
	FILE *fp = fopen("db.bin","rb");
	if (fp) {fread(&db, sizeof(db), 1, fp); fclose(fp); }

	scanf("%d", &CategoryId);
	while( !feof(stdin)) {
		if (!scanf("%d", &WordId)) return 1;
		db.Word[WordId]++;
		db.Cat[CategoryId]++;
		db.WordPerCat[CategoryId][WordId]++;
	}
	
	/*
	*  10. Write FINAL DB STATE to file
	*
	*/
	fp = fopen("db.bin","wb");
	if (fp) {fwrite(&db, sizeof(db), 1, fp); fclose(fp); }
}
	
