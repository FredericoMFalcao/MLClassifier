#include "db.h"

float predictions[MAX_NO_OF_CATEG];


int main() 
{

	/*
	*  1. Read INITIAL DB STATE from file
	*
	*/
	FILE *fp = fopen("db.bin","rb");
	if (fp) {fread(&db, sizeof(db), 1, fp); fclose(fp); }


	while(!feof(stdin)) 
		if (scanf("%d", &WordId))
			for(int CategoryId=0; CategoryId < MAX_NO_OF_CATEG; CategoryId++)
				predictions[CategoryId] += (float)db.WordPerCat[CategoryId][WordId] / db.Word[WordId];
		else
			return 1;
	
	/*
	*  10. PRINT final predictions table
	*
	*/
	
	for(int CategoryId=0; CategoryId < MAX_NO_OF_CATEG; CategoryId++)
		if (predictions[CategoryId] > 0) 
			printf("%d %f\n", CategoryId, predictions[CategoryId]);
}
	
