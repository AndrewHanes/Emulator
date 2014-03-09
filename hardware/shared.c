#include "shared.h"

char* opcodes[]= {"load", "store", "skip", "jmp", "halt", 
	"add", "push", "pop", "mul", "li",
	"sub", "negate"};

char* operandcode[] = {"%zo", "%ac", "%sp", "%bc" "%pc", "%dc", 
	"%cc", "%ec", "%fc"};

size_a geninstr(short code, short op1, short op2) {
	code <<= 8;
	op1 <<= 4;
	code = code & MSK_OPCODE;
	op1 = op1 & MSK_OPERAND1;
	op2 = op2 & MSK_OPERAND2;
	return code | op1 | op2;
}

short lookupOpcode(char* operand) {
	for(int i = 0; i < ARRAY_SIZE(opcodes); ++i) {
		if(strncmp(opcodes[i], operand, 2) == 0) {
			return i;
		}
	}
	return LOOKUP_ERR;
}

short lookupOperand(char* operand) {
	for(int i = 0; i < ARRAY_SIZE(operandcode); ++i) {
		if(strncmp(operandcode[i], operand, 3) == 0) {
			return i;
		}
	}
	return LOOKUP_ERR;
}


