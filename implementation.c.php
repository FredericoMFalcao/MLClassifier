// vim: syntax=c 

{{ foreach(["Category", "Input"] as $no => $type) :  }}
/*
*   {{=$no}}. {{=strtoupper($type)}}     
*
*/
{{ foreach(["load", "save"] as $mode) : }}
int {{=$mode}}{{=$type}}AtIndex( unsigned int idx, {{=$type}}* {{=strtolower($type)}}) {
	long int offset = 0;
	{{ if ( $type == "Input" ) : }}
	offset += sizeof(Category) * MAX_NO_OF_CATEGORY;
	{{ endif; }}
	offset += sizeof({{=$type}}) * idx;
	fseek(fp, offset, SEEK_SET);
	{{ if ($mode == "load") : }}
	return fread({{=strtolower($type)}}, sizeof({{=$type}}), 1, fp);
	{{ else : }}
	return fwrite({{=strtolower($type)}}, sizeof({{=$type}}), 1, fp);
	{{ endif; }}
}
{{ endforeach; }}

unsigned int {{=$type}}IdxByName(char *text) {
	{{=$type}} el;
	/* 1. Read an existing element  */
	for (int i=0; i< MAX_NO_OF_{{=strtoupper($type)}}; i++) {
		load{{=$type}}AtIndex(i,&el);
		if (strcmp(el.textValue, text) == 0)
			return i;
	}
	/* 2. Create a new entry */
	for (int i=0; i< MAX_NO_OF_{{=strtoupper($type)}}; i++) {
		load{{=$type}}AtIndex(i,&el);
		if (strlen(el.textValue) == 0) {
			el.index = i;
			strncpy(el.textValue, text, 255);
			save{{=$type}}AtIndex(i, &el);
			return el.index;
		}
	}

	return 0;
}
{{ endforeach; }}

/*
*   3. CORRELATION
*
*/
{{ foreach(["load", "save"] as $mode) : }}
int {{=$mode}}Correlation(unsigned int categoryIdx, unsigned int inputIdx, Correlation *correlation) {
	long int offset = 0;
	offset += sizeof(Category) * MAX_NO_OF_CATEGORY;
	offset += sizeof(Input) * MAX_NO_OF_INPUT;
	offset += sizeof(Correlation) * ( MAX_NO_OF_CATEGORY * inputIdx + categoryIdx );
	fseek(fp, offset, SEEK_SET);
	{{ if ( $mode == "load") : }}
	return fread(correlation, sizeof(Correlation), 1, fp);
	{{ else : }}
	return fwrite(correlation, sizeof(Correlation), 1, fp);
	{{ endif; }}

}
{{ endforeach; }}
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
