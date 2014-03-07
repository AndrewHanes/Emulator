#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MEMSIZE 65000

#define MSK_OPCODE 0xff00
#define MSK_OPERAND1 0xf0
#define MSK_OPERAND2 0xf
#define true 1
#define false 2
#define DUMP 10

#define lookup(reg, mem) (mem[(unsigned short) reg])

typedef short size_a;
typedef char bool;

size_a* mem;
size_a ac, pc, sp, bc;

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
			return NULL;
		case 1:
			return &ac;
		case 2:
			return &sp;
		case 3:
			return &bc;
		default:
			return NULL;
	}
	return NULL;
}

void debug() {
	printf("===DEBUG===\npc: %d\t%d\nac: %d\t%d\nbc: %d\t%d\n%sp: %d\t%d\n",
			pc, (unsigned short) pc, ac, (unsigned short) ac, bc, 
			(unsigned short) bc, sp, (unsigned short) sp);
	printf("Stack dump of %d elements", DUMP);
	for(int i = 0; i < DUMP; ++i) {
		printf("%d) %d\t%d", i, mem[(unsigned short) sp - i], 
				(unsigned short)mem[(unsigned short) sp -i]);
	}
}

/**
 * Executes
 */
bool execute() {
	size_a instr = lookup(pc, mem);
	unsigned char opcode = (instr & MSK_OPCODE) >> 8;
	unsigned char op1 = (instr & MSK_OPERAND1)  >> 4;
	unsigned char op2 = (instr & MSK_OPERAND2);
	size_a* r1 = lkOp(op1);
	size_a* r2 = lkOp(op2);
	#ifdef DEBUG
	printf("opcode: %d\top1:%d\top2:%d\n", opcode, op1, op2);
	debug();
	#endif
	switch(opcode) {
		case 0:
			//load from mem @ op1 into op2
			*r2 = mem[(unsigned short) *r1];
		case 1:
			//store op1  to mem @ op2 
			mem[(unsigned short) *r2] = *r1;
		case 2:
			//skip next instr based on comp
			//op1 => value, op2 => comp
			//	-1 => less
			//	0 => equal
			//	+1 => greater
			//isz
			switch(*r2) {
				case -1:
					(*r1 < 0) ? ++pc: pc;
					break;
				case 0:
					(*r1 == 0) ? ++pc: pc;
					break;
				case 1:
					(*r1 > 0) ? ++pc: pc;
				default:
					//TODO ERROR
					break;
			}
		case 3:
			//jmp
			// op1 is offset
			pc += *r1 - 1;
			break;
		case 4:
			return false;
		case 5:
			//add
			// add op1 to op2, store in op2
			*r2 = *r1 + * r2;
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
		default:
			//TODO ERROR
			break;
	}
}

int main(int argc, char** argv) {
	mem = (size_a*) malloc(MEMSIZE);
	pc = 0;
	sp = MEMSIZE - 1;
	ac = 0;
	bc = 0;
	while(execute()) {
		++pc;
	}
}
