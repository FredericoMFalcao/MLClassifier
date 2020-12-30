// vim: syntax=c 

/*
*   0. CATEGORY     
*
*/
int loadCategory( unsigned int idx, Category* category) {
	long int offset = 0;
		offset += sizeof(Category) * idx;
	fseek(fp, offset, SEEK_SET);
		return fread(category, sizeof(Category), 1, fp);
	}
int saveCategory( unsigned int idx, Category* category) {
	long int offset = 0;
		offset += sizeof(Category) * idx;
	fseek(fp, offset, SEEK_SET);
		return fwrite(category, sizeof(Category), 1, fp);
	}

unsigned int CategoryIdxByName(char *text) {
	Category el;
	/* 1. Read an existing element  */
	for (int i=0; i< MAX_NO_OF_CATEGORY; i++) {
		loadCategory(i,&el);
		if (strcmp(el.textValue, text) == 0)
			return i;
	}
	/* 2. Create a new entry */
	for (int i=0; i< MAX_NO_OF_CATEGORY; i++) {
		loadCategory(i,&el);
		if (strlen(el.textValue) == 0) {
			el.index = i;
			strncpy(el.textValue, text, 255);
			saveCategory(i, &el);
			return el.index;
		}
	}

	return 0;
}
/*
*   1. INPUT     
*
*/
int loadInput( unsigned int idx, Input* input) {
	long int offset = 0;
		offset += sizeof(Category) * MAX_NO_OF_CATEGORY;
		offset += sizeof(Input) * idx;
	fseek(fp, offset, SEEK_SET);
		return fread(input, sizeof(Input), 1, fp);
	}
int saveInput( unsigned int idx, Input* input) {
	long int offset = 0;
		offset += sizeof(Category) * MAX_NO_OF_CATEGORY;
		offset += sizeof(Input) * idx;
	fseek(fp, offset, SEEK_SET);
		return fwrite(input, sizeof(Input), 1, fp);
	}

unsigned int InputIdxByName(char *text) {
	Input el;
	/* 1. Read an existing element  */
	for (int i=0; i< MAX_NO_OF_INPUT; i++) {
		loadInput(i,&el);
		if (strcmp(el.textValue, text) == 0)
			return i;
	}
	/* 2. Create a new entry */
	for (int i=0; i< MAX_NO_OF_INPUT; i++) {
		loadInput(i,&el);
		if (strlen(el.textValue) == 0) {
			el.index = i;
			strncpy(el.textValue, text, 255);
			saveInput(i, &el);
			return el.index;
		}
	}

	return 0;
}

/*
*   3. CORRELATION
*
*/
int loadCorrelation(unsigned int categoryIdx, unsigned int inputIdx, Correlation *correlation) {
	long int offset = 0;
	offset += sizeof(Category) * MAX_NO_OF_CATEGORY;
	offset += sizeof(Input) * MAX_NO_OF_INPUT;
	offset += sizeof(Correlation) * MAX_NO_OF_CATEGORY * inputIdx + categoryIdx;
	fseek(fp, offset, SEEK_SET);
		return fread(correlation, sizeof(Correlation), 1, fp);
	
}
int saveCorrelation(unsigned int categoryIdx, unsigned int inputIdx, Correlation *correlation) {
	long int offset = 0;
	offset += sizeof(Category) * MAX_NO_OF_CATEGORY;
	offset += sizeof(Input) * MAX_NO_OF_INPUT;
	offset += sizeof(Correlation) * MAX_NO_OF_CATEGORY * inputIdx + categoryIdx;
	fseek(fp, offset, SEEK_SET);
		return fwrite(correlation, sizeof(Correlation), 1, fp);
	
}
void normalizeOutputResult(OutputResultLine *o) {
	double max_value = 0;
	/* 1. Find the maximum */
	for(int i=0; i<MAX_NO_OF_CATEGORY; i++)
		if (o[i].correlation > max_value) 
			max_value = o[i].correlation;

	if (max_value == 0) return; /* avoid division by zero */

	/* 2. Divide every element by the maximum */
	for(int i=0; i<MAX_NO_OF_CATEGORY; i++)
		o[i].correlation /= max_value;
}
