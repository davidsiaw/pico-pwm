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
  Tests that the state_from_char function returns 0 when 0 is typed
*/

int main()
{
  if (state_from_char('0') == 0)
  {
    /* return 0 when the test succeeds */
    return 0;
  }
  return 1;
}
