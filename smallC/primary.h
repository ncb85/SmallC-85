/*
 * File primary.h
 */


 #include "defs.h"

int primary (LVALUE *lval);

/**
 * true if val1 -> int pointer or int array and val2 not pointer or array
 * @param val1
 * @param val2
 * @return
 */
int dbltest (LVALUE *val1, LVALUE *val2);

/**
 * determine type of binary operation
 * @param lval
 * @param lval2
 * @return
 */
void result (LVALUE *lval, LVALUE *lval2);

int constant (int val[]);

int number (int val[]);

/**
 * Test if we have one char enclosed in single quotes
 * @param value returns the char found
 * @return 1 if we have, 0 otherwise
 */
int quoted_char (int *value);

/**
 * Test if we have string enclosed in double quotes. e.g. "abc".
 * Load the string into literal pool.
 * @param position returns beginning of the string
 * @return 1 if such string found, 0 otherwise
 */
int quoted_string (int *position);

/**
 * decode special characters (preceeded by back slashes)
 */
int spechar();

/**
 * perform a function call
 * called from "hier11", this routine will either call the named
 * function, or if the supplied ptr is zero, will call the contents
 * of HL
 * @param ptr name of the function
 */
void callfunction (char *ptr);

void needlval ();
