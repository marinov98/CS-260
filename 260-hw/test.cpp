#include <iostream>

int main()
{
    int x = 5;
    int *q = &x;
    int *p;

    std::cout << *q << '\n';
    p = q + 1;
    std::cout << *p << '\n';

    return 0;
}