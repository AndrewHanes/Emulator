%{
#define YYDEBUG 1
#include <inttypes.h>
#include "shared.h"
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
		$$.op2 = $3.op2;
	 }
	 | OPERATION REGISTER IMMEDIATE {
	 	$$.instr = $1.instr;
		$$.op1 = $1.op1;
		$$.op2 = $2.op2;
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
	return yyparse();
}
