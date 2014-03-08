%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "../hardware/shared.h"

#include "Assembler.tab.h"
%}

%%

\;* {
	return IGNORE;
}

[ \n\t] {
	return IGNORE;
}

[A-z]+[ ]+ {
	yylval.lbl = lookupOpcode(yytext);
	return OPERATION;
}

\%[A-z][A-z] {
	yylval.lbl = lookupOperand(yytext);
	return REGISTER;
}

[0-9]+ {
	yylval.lbl = (short) (atoi(yytext));
	return IMMEDIATE;
}

[A-z]+\: {
	yylval.lbl = (char*) strdup(yytext);
	return LABEL;
}

. {
	fprintf(stderr, "Error: Unknown token %s\n", yytext);
	return ERROR;
}
%%

int yywrap() {
	return 1;
}

