/*
 * File expr.h
 */

 #include "defs.h"

/**
 * unsigned operand ?
 */
int nosign(LVALUE *is);

/**
 * lval.symbol - symbol table address, else 0 for constant
 * lval.indirect - type indirect object to fetch, else 0 for static object
 * lval.ptr_type - type pointer or array, else 0
 * @param comma
 * @return
 */
void expression(int comma);

/**
 * assignment operators
 * @param lval
 * @return
 */
int hier1 (LVALUE *lval);

/**
 * processes ? : expression
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
int hier1a (LVALUE *lval);

/**
 * processes logical or ||
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
int hier1b (LVALUE *lval);

/**
 * processes logical and &&
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
int hier1c (LVALUE *lval);

/**
 * processes bitwise or |
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
int hier2 (LVALUE *lval);

/**
 * processes bitwise exclusive or
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
int hier3 (LVALUE *lval);

/**
 * processes bitwise and &
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
int hier4 (LVALUE *lval);

/**
 * processes equal and not equal operators
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
int hier5 (LVALUE *lval);

/**
 * comparison operators
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
int hier6 (LVALUE *lval);

/**
 * bitwise left, right shift
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
int hier7 (LVALUE *lval);

/**
 * addition, subtraction
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
int hier8 (LVALUE *lval);

/**
 * multiplication, division, modulus
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
int hier9 (LVALUE *lval);

/**
 * increment, decrement, negation operators
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
int hier10 (LVALUE *lval);

/**
 * array subscripting
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
int hier11(LVALUE *lval);
