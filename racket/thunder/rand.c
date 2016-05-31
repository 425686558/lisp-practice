#include <stdlib.h>
#include <stdio.h>
#include <time.h>

int huix_rand(int num)
{
  static int i=0;
  i+=30;
  srand(num + i);
  return rand();
}

int get_rand_num()
{
  int seed=time(NULL);
  return huix_rand(seed);
}
