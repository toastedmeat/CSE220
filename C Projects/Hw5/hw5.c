/*
Homework #5
name: Eric Loo
sbuid: 108818998
*/

#include <stdlib.h>
#include <stdio.h>

/* Function prototypes */
int promptForId(void);
int scrambleId(int id);
int xor(int v, int id);
int shift(int v, int n);
int printResults(int original, int scrambled);

/* Ask the user for their SBUID */
int promptForId(void) {
    int id, valid;
    char line[256];
    /* Loop until valid input is given */
    do {
        printf("Please enter your SBUID: ");
        /* Read in the whole line */
        fgets(line, sizeof(line), stdin);
        /* If we were not able to parse the string, tell the user */
        if( !(valid = sscanf(line, "%d", &id)) ) {
            printf("Invalid id entered.\n");
        }
    } while(!valid);
    return id;
}

/* Scramble the SBUID */
int scrambleId(int id) {
    int scrambled = id, i;
    int rounds;
    int r;
    srand(id);
    r = rand();
    /* Bound this random number between 1-10 */
    rounds = (rand() % 10) + 1;
    printf("Performing %d rounds of shifting and xoring.\n", rounds);
    /* Go through some crazy shifting operations */
    for(i = 0; i < rounds; i++) {
        scrambled = shift(scrambled, r >>= 1);
    }
    return scrambled;
}

/* Perform bitwise XOR on the SBU ID */
int xor(int v, int id) {
    int result;
    result = v ^ id;
    return result;
}

/* Shift the value right and xor */
int shift(int v, int r) {
    int shamt = 0x08000000;
    int results = 0;
    while(shamt) {
         results += xor(v, r); /* add the return value of xor to result */
		shamt = shamt >> 1; /* Shift right by 1 */
    }
    return results;
}

int printResults(int original, int scrambled) {
    /* If the scrambled number is even */
    int isEven;
    printf("%d -> %d\n", original, scrambled);
    isEven = scrambled % 2;
    if((isEven == 0)) {
        printf("The scrambled result is even!\n");
        return 0;
    }
    else /* it is odd */
        printf("The scrambled result is odd!\n");
    return 127;
}

/* The program starts here */
int main() {
    int id;
    int scrambled;
    id = promptForId();
    printf("SBUID: %d\n", id);
    /*  Scramble the SBUID */
    scrambled = scrambleId(id);
    /* Print out the scrambled value */
    printResults(id, scrambled);
    return 0;
}

/* @@GDB_OUTPUT_HERE@@

sparky% gdb a.out
GNU gdb (GDB) 7.8
Copyright (C) 2014 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "sparc-sun-solaris2.10".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from a.out...done.
(gdb) break 27
Breakpoint 1 at 0x10c08: file hw5.c, line 27.
(gdb) break 46
Breakpoint 2 at 0x10cf8: file hw5.c, line 46.
(gdb) break 54
Breakpoint 3 at 0x10d54: file hw5.c, line 54.
(gdb) run
Starting program: /export/home1/e/l/eloo/a.out
[Thread debugging using libthread_db enabled]
[New Thread 1 (LWP 1)]
Please enter your SBUID: 123456789
[Switching to Thread 1 (LWP 1)]

Breakpoint 1, promptForId () at hw5.c:27
27              if( !(valid = sscanf(line, "%d", &id)) ) {
(gdb) print line
$1 = "123456789\n", '\000' <repeats 38 times>, "\377\377\377\377\377\377\377\377\377:\000\000\377\277\373\360\377:@L\000\000\000\f\000\001\000\064\377\277\377\335\377\377\377\377\000\000\000\000\377\277\374\334\000\000\000\002\377\377\377\377\377\377\377\377\377\277\373\370\377:X\350\000\000\000\000\000\000\000\000\377\277\375(\000\000\000\000\000\000\000\001\000\001\005\v\377\067\np\377 \267\200\000\001\005\v\377\067\004 \377\067\004 \000\000\000\002\006\212\317\004\000\000\000\021\000\001\003L\025\001\377\377\000\001\000\000\000\000\000\000\000\000\000\002\377\277\373\360\377>\311\204\377\277\374\344"...
(gdb) continue
Continuing.
SBUID: 123456789
Performing 6 rounds of shifting and xoring.

Breakpoint 2, scrambleId (id=123456789) at hw5.c:46
46              scrambled = shift(scrambled, r >>= 1);
(gdb) print i
$2 = 0
(gdb) continue
Continuing.

Breakpoint 3, xor (v=123456789, id=1768) at hw5.c:54
54          result = v ^ id;
(gdb) backtrace
#0  xor (v=123456789, id=1768) at hw5.c:54
#1  0x00010da4 in shift (v=123456789, r=1768) at hw5.c:63
#2  0x00010d14 in scrambleId (id=123456789) at hw5.c:46
#3  0x00010e9c in main () at hw5.c:90
(gdb) info frame
Stack level 0, frame at 0xffbffb38:
 pc = 0x10d54 in xor (hw5.c:54); saved pc = 0x10da4
 called by frame at 0xffbffba0
 source language c.
 Arglist at 0xffbffb38, args: v=123456789, id=1768
 Locals at 0xffbffb38, Previous frame's sp in fp
 Saved registers:
  l0 at 0xffbffb38, l1 at 0xffbffb3c, l2 at 0xffbffb40, l3 at 0xffbffb44,
  l4 at 0xffbffb48, l5 at 0xffbffb4c, l6 at 0xffbffb50, l7 at 0xffbffb54,
  i0 at 0xffbffb58, i1 at 0xffbffb5c, i2 at 0xffbffb60, i3 at 0xffbffb64,
  i4 at 0xffbffb68, i5 at 0xffbffb6c, fp at 0xffbffb70, i7 at 0xffbffb74
(gdb) clear xor
Deleted breakpoint 3
(gdb) continue
Continuing.

Breakpoint 2, scrambleId (id=123456789) at hw5.c:46
46              scrambled = shift(scrambled, r >>= 1);
(gdb) print i
$3 = 1
(gdb) continue
Continuing.

Breakpoint 2, scrambleId (id=123456789) at hw5.c:46
46              scrambled = shift(scrambled, r >>= 1);
(gdb) print i
$4 = 2
(gdb) continue
Continuing.

Breakpoint 2, scrambleId (id=123456789) at hw5.c:46
46              scrambled = shift(scrambled, r >>= 1);
(gdb) print i
$5 = 3
(gdb) continue print i
No symbol "print" in current context.
(gdb) continue
Continuing.

Breakpoint 2, scrambleId (id=123456789) at hw5.c:46
46              scrambled = shift(scrambled, r >>= 1);
(gdb) print i
$6 = 4
(gdb) continue
Continuing.

Breakpoint 2, scrambleId (id=123456789) at hw5.c:46
46              scrambled = shift(scrambled, r >>= 1);
(gdb) print i
$7 = 5
(gdb) continue
Continuing.
123456789 -> -581685340
The scrambled result is even!
[Inferior 1 (process 24846    ) exited normally]
(gdb)


@@GDB_OUTPUT_HERE@@ */