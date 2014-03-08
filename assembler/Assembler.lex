%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "../hardware/shared.h"
#include "Assembler.tab.h"

%}

%%

\;* ;

[ \n\t] ;

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
	return LABEL;
}

[A-z]+ {
	short opcode = lookupOpcode(yytext);
	yylval.i.instr = opcode;
	return OPERATION;
}

. {
	fprintf(stderr, "Error: Unknown token %s\n", yytext);
	return ERROR;
}

%%

int yywrap() {
	return 1;
}

