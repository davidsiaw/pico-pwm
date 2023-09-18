/*
  these comments starting with "+test+" tell Makefile to include
  these sources whhen
  compiling this test.
*/

/*+test+src/state.c*/

#include "state.h"

/*******************
 Example test file
 *******************/

/*
  Tests that the state_from_char function returns 0 for other inputs
*/

int main()
{
  if (state_from_char('a') == 0)
  {
    return 0;
  }
  return 1;
}
