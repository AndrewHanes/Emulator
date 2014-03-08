%{
#define YYDEBUG 1
#include <inttypes.h>
#include "../hardware/shared.h"
#include "Assembler.yy.c"
#include <glib.h>

instr_t* instr;
int yyerror(char* s);
int yylex();
int addr = 0;

%}

%union {
	instr_t i;
	short lbl;
}

%token<i> IGNORE LABEL OPERATION REGISTER IMMEDIATE ERROR
%type<i> statement 

%%

program: program statement { ++addr; }
       | /* e */
       ;

statement: OPERATION REGISTER REGISTER {
	 	//TODO
		$$.instr = $1.instr;
		$$.op1 = $2.op1;
		$$.op2 = $3.op1;
		printf("%d\t%d\t%d\t\n", $$.instr, $$.op1, $$.op2);
	 }
	 | OPERATION REGISTER IMMEDIATE {
	 	$$.instr = $1.instr;
		$$.op1 = $2.op1;
		$$.op2 = $3.op1;
	 	//TODO
	 
	 }
	 | OPERATION REGISTER {
	 	//TODO
	 	$$.instr = $1.instr;
		$$.op1 = $1.op1;
		$$.op2 = 0;
	 }
	 | LABEL {
		//TODO add label
	 }
	 | IGNORE {} ;

%%

int yyerror(char* s) {
	fprintf(stderr, "Error: %s\n", s);
	return 1;
}

int main(int argc, char** argv) {
	if(argc == 0) {
		yyin = stdin;
		yyout = stdout;
	}
	else if (argc == 1) {
		yyin = fopen(argv[1], "r");
		yyout = stdout;
	}
	else {
		yyin = fopen(argv[1], "r");
		yyout = fopen(argv[2], "r");
	}
	int n = yyparse();
	if(yyin != stdin) {
		fclose(yyin);
	}
	if(yyout != stdout) {
		fclose(yyout);
	}
}
