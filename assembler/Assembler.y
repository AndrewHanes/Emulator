%{
#define YYDEBUG 1
#include <stdlib.h>
#include <inttypes.h>
#include "../hardware/shared.h"
#include "Assembler.yy.c"
#include <glib.h>

instr_t* instr;
int yyerror(char* s);
int yylex();
int addr = 0;
size_a* mem;
size_a* ptr;

%}

%union {
	instr_t i;
	short lbl;
}

%token<i> IGNORE LABEL OPERATION REGISTER IMMEDIATE ERROR
%type<i> statement 

%%

program: program statement { 
		*(ptr++) = geninstr($2.instr, $2.op1, $2.op2);
		printf("%d\t%d\t%d\t\n", $2.instr, $2.op1, $2.op2);
	}
	| /* e */
   ;

statement: OPERATION REGISTER REGISTER {
	 	//TODO
		$$.instr = $1.instr;
		$$.op1 = $2.op1;
		$$.op2 = $3.op1;
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
	 | OPERATION {
		$$.instr = $1.instr;
		$$.op1 = 0;
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
	mem = (size_a*) calloc(1, MEMSIZE);
	ptr = mem;
	if(argc != 3) {
		fprintf(stderr, "Usage: %s in out\n", argv[0]);
	}
	yyin = fopen(argv[1], "r");
	yyout = fopen(argv[2], "w+");
	int n = yyparse();
	*ptr = geninstr(4, 0, 0);
	fwrite(mem,MEMSIZE, 1, yyout);
	if(yyin != stdin) {
		fclose(yyin);
	}
	if(yyout != stdout) {
		fclose(yyout);
	}
	free(mem);
}
