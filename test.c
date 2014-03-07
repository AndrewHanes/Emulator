#include <stdio.h>

int main() {
	short s = -1;
	unsigned short r = (unsigned short) s;
	printf("%d\n%d\n",s, r);
}
