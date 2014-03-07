#include "shared.h"
size_a geninstr(short code, short op1, short op2) {
	code <<= 8;
	op1 <<= 4;
	code = code & MSK_OPCODE;
	op1 = op1 & MSK_OPERAND1;
	op2 = op2 & MSK_OPERAND2;
	return code | op1 | op2;
}
