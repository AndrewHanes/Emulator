/*
* Assembler.y
* Andrew Hanes <ahanes@csh.rit.edu>
*/

%{
#define YYDEBUG 1
#include <stdlib.h>
#include <inttypes.h>
#include "../hardware/shared.h"
#include "Assembler.yy.c"
#define PARSE_ERROR 0xabcd

/*
* Globals
*/
instr_t* instr;
int yyerror(char* s); // func prototype
int yylex();
int addr = 0; //current addr (for labels)
int line = 0; //current line (for error handler)
size_a* mem; //mem ptr
size_a* ptr; //ptr to next free loc in mem
int runNum = 1; //which pass?
lbl_t* labels; //head of the label linked list

%}

%union {
	instr_t i;
	lbl_t label;
	short lbl;
	char* lbl_goto;
}

%token<i> IGNORE OPERATION REGISTER IMMEDIATE ERROR NEWLINE
%token <label> LABEL
%token <lbl_goto> LBLNAME
%type <i> statement
%%

program: program statement NEWLINE  {
       	++addr;
		++line;
        if(runNum == 2) {
            *(ptr++) = geninstr($2.instr, $2.op1, $2.op2);
            printf("instr: %d\top1: %d\top2: %d\n", $2.instr, $2.op1, $2.op2);
            if($2.instr == LOOKUP_ERR) {
                yyerror("Invalid instruction\n");
                return PARSE_ERROR;
            }
		}
	}
	| /* e */
	| program LABEL NEWLINE {
		++line;
		if(runNum == 1) {
			lbl_t* ptr = labels;
			while(ptr->next != 0) {
				ptr = ptr->next;
			}
			ptr->next = (lbl_t*) calloc(1, sizeof(lbl_t));
			ptr->label = $2.label;
			ptr->address = addr;
			printf("created label %s at %d\n", ptr->label, addr);
		}
	}
	| program IGNORE NEWLINE {
		++line;
	}
   ;

statement: OPERATION REGISTER REGISTER {
		$$.instr = $1.instr;
		$$.op1 = $2.op1;
		$$.op2 = $3.op1;
	 }
	 | OPERATION REGISTER IMMEDIATE {
		$$.instr = $1.instr;
		$$.op1 = $2.op1;
		$$.op2 = $3.op1;
	 
	 }
	 | OPERATION REGISTER {
	 	$$.instr = $1.instr;
		$$.op1 = $2.op1;
		$$.op2 = 0;
	 }
	 | OPERATION LBLNAME {
        if(runNum == 2) {
            $$.instr = $1.instr;
            $$.op1 = 0;
            $$.op2 = 0;
            lbl_t* ptr = labels;
            while(ptr != 0) {
                printf("%s =?= %s\n", ptr->label, $2);
                if(ptr->label != NULL && strcmp(ptr->label, $2) == 0) {
                    $$.op1 = ptr->address;
                    printf("YEP jmp label %s to %d\n", ptr->label, ptr->address);
                    break;
                } else {
                    printf("nope\n");
                }
                ptr = ptr->next;
            }
		}
	 }
	 | OPERATION {
		$$.instr = $1.instr;
		$$.op1 = 0;
		$$.op2 = 0;
	 }
	 | ERROR {
		yyerror("Error");
	} 
	;

%%

int yyerror(char* s) {
	fprintf(stderr, "Error: %s\n on line %d", s, line);
	return 1;
}

/*
* allocate mem for instr buffer, handles file IO
*/
int main(int argc, char** argv) {
    runNum = 1;
	mem = (size_a*) calloc(1, MEMSIZE);
	ptr = mem;
	labels = (lbl_t*) calloc(1, sizeof(lbl_t));
	labels->label="__top__";
	if(argc != 3) {
		fprintf(stderr, "Usage: %s in out\n", argv[0]);
		return -1;
	}
	yyin = fopen(argv[1], "r");
	yyout = fopen(argv[2], "w+");
	int n = yyparse();
	fclose(yyin);
	yyin = fopen(argv[1], "r");
	line = 0;
	addr = 0;
	runNum = 2;
	n = yyparse();
	if(n != PARSE_ERROR)
		fwrite(mem,MEMSIZE, 1, yyout);
	if(yyin != stdin) {
		fclose(yyin);
	}
	if(yyout != stdout) {
		fclose(yyout);
	}
	free(mem);
	return n;
}
