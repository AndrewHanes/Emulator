%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "../hardware/shared.h"
#include "Assembler.tab.h"

%}

%%

\;* ;

[ \t] ;

[\n] { return NEWLINE; }

\%[A-z][A-z] {
	short reg = lookupOperand(yytext);
	yylval.i.op1 = reg;
	return REGISTER;
}

[0-9]+ {
	yylval.i.op1 = (short) (atoi(yytext));
	return IMMEDIATE;
}

[A-z]+: {
	yylval.label.label = (char*) strdup(yytext);
	int len = strlen(yylval.label.label);
	yylval.label.label[len - 1] = 0; //remove the ':'
	return LABEL;
}

[A-z]+ {
	short opcode = lookupOpcode(yytext);
	yylval.i.instr = opcode;
	return OPERATION;
}

\$[A-z]+ {
	yylval.lbl_goto = (char*) strdup(yytext);
	yylval.lbl_goto = yylval.lbl_goto+1; //get rid of the '$'
	return LBLNAME;
}

. {
	fprintf(stderr, "Error: Unknown token %s\n", yytext);
	return ERROR;
}

%%

int yywrap() {
	return 1;
}

