/*
 * File function.h
 */


/**
 * begin a function
 * called from "parse", this routine tries to make a function out
 * of what follows
 * modified version.  p.l. woods
 */
void newfunc();

/**
 * declare argument types
 * called from "newfunc", this routine adds an entry in the local
 * symbol table for each named argument
 * completely rewritten version.  p.l. woods
 * @param t argument type (char, int)
 * @return
 */
void getarg(int t);

int doAnsiArguments();

void doLocalAnsiArgument(int type);
