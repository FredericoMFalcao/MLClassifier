#include <stdio.h>   /* fopen(), fclose(), fread(), fwrite() */
#include <string.h> /* strcmp() */
#include <stdlib.h>  /* qsort() */

#define MAX_NO_OF_INPUT 128000
#define MAX_NO_OF_CATEGORY 512

/*
*	PROGRAM MODES
*
*/
int prog_mode = 100;
#define MODE_RESET_DATA 0
#define MODE_LEARN      1
#define MODE_PREDICT    2



FILE *fp;

/* 1. CATEGORY */
typedef struct {
	unsigned int index;
	char textValue[256];
	unsigned int length;
}Category;
unsigned int CategoryIdxByName(char *text);
int loadCategory( unsigned int idx, Category* category);

/* 2. INPUT */
typedef struct {
	unsigned int index;
	char textValue[256];
	unsigned int length;
}Input;
unsigned int InputIdxByName(char *text);
int loadInput(unsigned int idx, Input* input);

/* 3. Correlations - Inputs per category */
typedef struct {
	//unsigned int CategoryIdx;
	//unsigned int InputIdx;
	unsigned int length;
} Correlation;
int loadCorrelation(unsigned int categoryIdx, unsigned int inputIdx, Correlation *correlation);

/* 4. Output results */
typedef struct {
	unsigned int CategoryIdx;
	double correlation;
} OutputResultLine;
void normalizeOutputResult(OutputResultLine *o);

#include "implementation.c"

/* Global variables */
Input input;
Category category;
Correlation correlation;

char text[256];

int compareOutputElements(const void *a, const void *b ) { return ((OutputResultLine*)a)->correlation < ((OutputResultLine*)b)->correlation; }

int main(int argc, char *argv[]) {


	/*
	*	0. Parse PROGRAM MODE
	*/	
	for (int i =0; i< argc; i++)
		if (strcmp(argv[i], "--reset") == 0 )      prog_mode = MODE_RESET_DATA;
		else if (strcmp(argv[i], "--learn") == 0 ) prog_mode = MODE_LEARN;
		else if (strcmp(argv[i], "--predict") == 0 ) prog_mode = MODE_PREDICT;

	if (prog_mode == MODE_RESET_DATA) {
		/* 0. Open KNOWLEDGE file for writing */
		fp = fopen("/ExtraSpace/MLClassifierData/knowledge.bin", "w");

		/* 1. Write the Categories list */
		for (int i=0; i< MAX_NO_OF_CATEGORY; i++)
			fwrite(&category, sizeof(Category), 1, fp);

		/* 2. Write the inputs */
		for (int i=0; i< MAX_NO_OF_INPUT; i++)
			fwrite(&input, sizeof(Input), 1, fp);

		/* 3. Write the correlations */
		for(int i=0;i < MAX_NO_OF_INPUT; i++)
			for (int j = 0; j< MAX_NO_OF_CATEGORY; j++)
				fwrite(&correlation, sizeof(correlation), 1, fp);
		/* 
		for(correlation.InputIdx=0; correlation.InputIdx < MAX_NO_OF_INPUT; correlation.InputIdx++)
			for (correlation.CategoryIdx = 0; correlation.CategoryIdx< MAX_NO_OF_CATEGORY; correlation.CategoryIdx++)
				fwrite(&correlation, sizeof(correlation), 1, fp); 
		*/
	}

	if (prog_mode == MODE_LEARN) {
		/* 0. Open KNOWLEDGE file for reading/writing */
		fp = fopen("/ExtraSpace/MLClassifierData/knowledge.bin", "r+");
		if (!fp) { fprintf(stderr, "ERROR: Could not open knowledge file."); return 1; }
		
		/* 1. Scan a string */
		long CategoryIdx = -1, InputIdx;
		while(!feof(stdin)) {
			if (CategoryIdx == -1)
			{	
				scanf("%s", text);
				CategoryIdx = CategoryIdxByName(text);
		
				

				/* 1. Deal with the Category */
				/* 1.1 Read the current input length */
				loadCategory(CategoryIdx, &category);
				/* 1.2 Increment the current category length */
				category.length++;
				/* 1.3 Write to the file */
				saveCategory(CategoryIdx, &category);


				continue;
			}
				
			scanf("%s", text);
			InputIdx = InputIdxByName(text);

			

			/* 2. Deal with the Input */
			/* 2.1 Read the current input length */
			loadInput(InputIdx, &input);
			/* 2.2 Increment the current input length */
			input.length++;
			/* 2.3 Write to the file */
			saveInput(InputIdx, &input);

			


			/* 3. Deal with the Correlation */
			/* 3.1 Read the current association weigth */
			loadCorrelation(CategoryIdx, InputIdx, &correlation);

			/* 3.2 Increase the current correlation weigth */
			correlation.length++;

			/* 3.3. Write it to the file */
			saveCorrelation(CategoryIdx, InputIdx, &correlation);
		}
			
			
	}

	if (prog_mode == MODE_PREDICT) {
		/* 0. Open KNOWLEDGE file for reading */
		fp = fopen("/ExtraSpace/MLClassifierData/knowledge.bin", "r");
		if (!fp) { fprintf(stderr, "ERROR: Could not open knowledge file."); return 1; }

		/* 1. Create the output */
		OutputResultLine output[MAX_NO_OF_CATEGORY];
		for(int i = 0; i < MAX_NO_OF_CATEGORY; i++) {
			output[i].CategoryIdx = i;
			output[i].correlation = 0.00;
		}

		/* 2. Calculate the output */
		while(!feof(stdin)) {
			unsigned int InputIdx;
			scanf("%s", text);
			InputIdx = InputIdxByName(text);
			for (int CategoryIdx=0; CategoryIdx < MAX_NO_OF_CATEGORY; CategoryIdx++) {
				loadCorrelation(CategoryIdx, InputIdx, &correlation);
				loadCategory(CategoryIdx, &category);
				
				if (category.length) /* avoid divide by zero */
					output[CategoryIdx].correlation += (float)correlation.length / (float)category.length;
			}
			
		}

		normalizeOutputResult(&output[0]);

		/* 4. Order the output array */
		qsort(output, MAX_NO_OF_CATEGORY, sizeof(OutputResultLine), compareOutputElements);

		/* 5. Print the output */
		for (int i=0; i < MAX_NO_OF_CATEGORY; i++) {
			loadCategory(output[i].CategoryIdx, &category);
			printf("( %lf ) %s\n", output[i].correlation, category.textValue);
		}
	}
	
	if (fp) fclose(fp);

	return 0;
}
