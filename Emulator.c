#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MEMSIZE 65000

#define MSK_OPCODE 0xff00
#define MSK_OPERAND1 0xf0
#define MSK_OPERAND2 0xf
#define true 1
#define false 0
#define DUMP 10

#define lookup(reg, mem) (mem[(unsigned short) reg])

typedef short size_a;
typedef char bool;

size_a* mem;
size_a ac, pc, sp, bc, dc, cc, ec, fc;
size_a z = 0;

bool done = false;
/**
 * Populate text section of memory
 * @return MEMSIZE on overflow, or number of bytes read in
 */
int populateText(size_a* mem, char* fname) {
	size_a size = 0;
	FILE* f = fopen(fname, "r");
	int c;
	char* ptr =(char*) mem;
	while((c = fgetc(f)) != EOF) {
		*ptr++ = (char) c;
		if(size == (2/3) * MEMSIZE) {
			return MEMSIZE;
		}
	}
	return size;
}

size_a* lkOp(unsigned char operand) {
	switch(operand) {
		case 0:
			return &z;
		case 1:
			return &ac;
		case 2:
			return &sp;
		case 3:
			return &bc;
		case 4:
			return &pc;
		case 5:
			return &dc;
		case 6:
			return &cc;
		case 7:
			return &ec;
		case 8:
			return &fc;
		default:
			return NULL;
	}
	return NULL;
}

void debug() {
	printf("Registers\nAC: %d\tBC: %d\nPC: %d\tSP: %d\n", ac, bc, 
			(unsigned short) pc, (unsigned short) sp);
}

/**
 * Executes
 */
bool execute() {
	size_a instr = mem[(unsigned short) pc];
	unsigned char opcode = (instr & MSK_OPCODE) >> 8;
	unsigned char op1 = (instr & MSK_OPERAND1)  >> 4;
	unsigned char op2 = (instr & MSK_OPERAND2);
	size_a* r1 = lkOp(op1);
	size_a* r2 = lkOp(op2);

	printf("opcode: %d\top1:%d\top2:%d\n\n\n", opcode, op1, op2);
	debug();
	switch(opcode) {
		case 0:
			//load from mem @ op1 into op2
			*r2 = mem[(unsigned short) *r1];
			break;
		case 1:
			//store op1  to mem @ op2 
			mem[(unsigned short) *r2] = *r1;
			break;
		case 2:
			//skip next instr based on comp
			//op1 => value, op2 => comp
			//	0 => less
			//	1 => equal
			//	2 => greater
			//isz
			switch(*r2) {
				case 0:
					(*r1 < 0) ? ++pc: pc;
					break;
				case 1:
					(*r1 == 0) ? ++pc: pc;
					break;
				case 2:
					(*r1 > 0) ? ++pc: pc;
				default:
					//TODO ERROR
					return false;
			}
			break;
		case 3:
			//jmp
			// op1 is offset
			pc = *r1;
			break;
		case 4:
			//Halt
			printf("Halting Emulator\n");
			return false;
		case 5:
			//add
			// add op1 to op2, store in op2
			*r2 = *r1 + *r2;
			break;
		case 6:
			//push
			//incr sp, put op1 onto stack
			sp++;
			mem[(unsigned short) sp] = *r1;
			break;
		case 7:
			//pop
			// decr sp, put value into op1
			*r1 = mem[(unsigned short) sp];
			sp--;
			break;
		case 8:
			//mul
			// multiple op1 and op2
			*r2 = *r1 + *r2;
			break;
		case 9:
			//load immediate
			*r1 = op2;
			break;
		case 10:
			//sub (see add)
			*r2 = *r1 - *r2;
			break;
		case 11:
			//negate op1
			*r1 = -1**r1;
			break;
		default:
			fprintf(stderr, "Unknown opcode %d.  Terminating", opcode);
			return false;
	}
	return true;
}

size_a genop(short code, short op1, short op2) {
	code <<= 8;
	op1 <<= 4;
	code = code & MSK_OPCODE;
	op1 = op1 & MSK_OPERAND1;
	op2 = op2 & MSK_OPERAND2;
	return code | op1 | op2;
}
int main(int argc, char** argv) {
	mem = (size_a*) malloc(MEMSIZE);
	pc = 0;
	sp = MEMSIZE - 1;
	mem[0] = genop(9, 3, 2);
	mem[1] = genop(9, 1, 15);
	mem[2] = genop(5, 1, 1);
	mem[4] = genop(3, 3, 0);
	mem[5] = genop(4, 0, 0);
	while(execute()) {
		++pc;
	}
}
