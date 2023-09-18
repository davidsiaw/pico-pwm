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
  Tests that the state_from_char function returns 1
*/

int main()
{
  if (state_from_char('1') == 1)
  {
    return 0;
  }
  return 1;
}
