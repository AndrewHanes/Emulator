/*
 * Shared header file for Assembler.Emulator
 * @Author Andrew Hanes <ahanes@csh.rit.edu>
 */
#ifndef __SHARED_H__
#define __SHARED_H__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MEMSIZE 65000

// Masks for parsing an instruction
#define MSK_OPCODE 0xff00
#define MSK_OPERAND1 0xf0
#define MSK_OPERAND2 0xf

#define true 1
#define false 0
#define DUMP 10

/looks up a mem location
#define lookup(reg, mem) (mem[(unsigned short) reg])

//size of arch
typedef short size_a;
// so i can use bool
typedef char bool;

//generates an instr
size_a geninstr(short code, short op1, short op2);

#define ARRAY_SIZE(foo) (sizeof(foo)/sizeof(foo[0]))
#define LOOKUP_ERR -1

// look up opcode
short lookupOpcode(char* operand);

// look up operand
short lookupOperand(char* operand);

//store n instruction (as bitfield)
typedef struct instr {
	unsigned short instr : 8;
	unsigned short op1: 4;
	unsigned short op2: 4;
} instr_t;

// node in the label linked list
typedef struct node {
	struct node* next;
	unsigned short address;
	char* label;
	char; //padding
} lbl_t;


#endif
