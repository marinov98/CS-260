// PASSWORD: culber

#include <iostream>
using namespace std;

int main()
{
    struct foo_t
    {
        int x[100];
        int var1;
        int y[10];

    } foo;
    int var2;
    long i;
    int *p, *q;
    short int *s;
    long int *l;
    struct foo_t bar[50];

    for (i = 0; i < 100; i++)
        foo.x[i] = 100 + i;
    for (i = 0; i < 10; i++)
        foo.y[i] = 200 + i;
    foo.var1 = 250;

    cout << sizeof(*s) << "\n";
    cout << sizeof(*p) << "\n";
    cout << sizeof(*l) << "\n";
    // MOD
    cout << sizeof(s) << '\n';
    cout << sizeof(p) << '\n';
    cout << sizeof(l) << '\n';
    // MOD end
    q = (int *)&foo;   
    p = &(foo.x[5]);    cout << *p << "\n";
    // POINT 1
    q = (int *)&var2;   cout << q << "\n";
    q = p + 16;         cout << *q << "\n";
    i = ((long)p) + 16;
    q = (int *)i;       cout << *q << "\n";
    s = (short *)i;     cout << *s << "\n";
    l = (long *)i;      cout << *l << "\n";
    q = p + 95;         cout << *q << "\n";
    q = p + 98;         cout << *q << "\n";
    i = ((long)p) + 17;
    q = (int *)i;       cout << *q << "\n";
    q = p + 101;        cout << *q << "\n";
    q = (int *)(((long) p) + 404); cout << *q << "\n";
    p = (int *)bar;
    *(p + 988) = 500;    cout << bar[8].var1 << "\n";
}

/*
  ANSWERS TO HOMEWORK
  done together with chapel and keiko

 */

//// QUESTION 1
/*
  Compiler: 
  gcc (Ubuntu 7.3.0-27ubuntu~18.04) 7.3.0

  Computer used:
  HP spectre 2017 13.3-inch
  Intel(R) Core(TM) i7-7500u CPU @2.7 GHZ
  OS: Linux (Ubuntu 18.04)
  x86_64

  OUTPUT:
 2              
 4
 8
 0x7fff27da88f0
 105
 0x7fff27da88c4
 121
 109
 109
 472446402669
 250
 202
 1845493760
*/

//// QUESTION 2
/*
  2x8 = 16 bits for shorts
  4x8 = 32 bits for regular ints
  8x8 = 64 bits for long ints
*/

//// QUESTION 3
/*
  Based on the code used to test:
  Regardless of type, each pointer was the size of 8 bytes,
  meaning my system stores 8x8 = 64 bits for pointers.
*/

//// QUESTION 4 

/* Table:

  Address:        Value:            Variable:
0x7ffd86961310 |   100          |     foo.x[0] <-q
               |   100 + i      |     foo.x[i]
0x7ffd8696149c |   199          |     foo.x[99]
0x7ffd869614a0 |   250          |     foo.var1
0x7ffd869614a4 |   200          |     foo.y[0]
0x7ffd869774c8 |   209          |     foo.[9]
               |   200 + i      |     foo.y[i]
0x7ffd87977324 |   105          |     foo.x[5] <-p 

 */


//// QUESTION 5
/*
  The output that is odd comes from the line l = (long* i); The problem is that we are casting an integer pointer to a long pointer.
The original p is pointing to an array of integers. casting it to long causes it to view the bits of two ints as one long. This causes overflow. 
 */


//// QUESTION 6

/*
 They are not the same. When adding two integers, only the value gets updated, while the address stays the same. Pointers,on the other hand, updates the memory address by the #bytes times value of the pointer being added. It also takes into the account the original type declaration of the pointer, if we are casting it into a different type, it will add a different amount of bits. 

*/

//// QUESTION 7 (Solved in the code)
/*
Answer: 101
Answer#2: 404
 */


//// QUESTION 8 (Solved in the code)
/*
Answer: 988 ->  (8x111) + 100 (offset)
 */

//// QUESTION 9
/*
The program allocates scalar variables going down. As the allocation progresses, the memory addresses had decreasing hex values. For example, the foo(made from the struct foo_t) has a higher memory of address of the var2 whose address is exactly 4 less than the address of foo. 
*/



//// FINAL OUTPUT
/*
 2
 4
 8
 8
 8
 8
 105
 0x7ffc368ca434
 121
 109
 109
 472446402669
 250
 202
 1845493760
 205           
 205
 500
*/
