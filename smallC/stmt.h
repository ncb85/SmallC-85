/*
 * File stmt.h
 */


//#include "defs.h"


/**
 * statement parser
 * called whenever syntax requires a statement.  this routine
 * performs that statement and returns a number telling which one
 * @param func func is true if we require a "function_statement", which
 * must be compound, and must contain "statement_list" (even if
 * "declaration_list" is omitted)
 * @return statement type
 */
int statement (int func);

/**
 * declaration
 */
int statement_declare();

/**
 * local declarations
 * @param stclass
 * @return
 */
int do_local_declares(int stclass);

/**
 * non-declaration statement
 */
void do_statement ();

/**
 * compound statement
 * allow any number of statements to fall between "{" and "}"
 * 'func' is true if we are in a "function_statement", which
 * must contain "statement_list"
 */
void do_compound(int func);

/**
 * "if" statement
 */
void doif();

/**
 * "while" statement
 */
void dowhile();

/**
 * "do" statement
 */
void dodo();

/**
 * "for" statement
 */
void dofor();

/**
 * "switch" statement
 */
void doswitch();

/**
 * "case" label
 */
void docase();

/**
 * "default" label
 */
void dodefault();

/**
 * "return" statement
 */
void doreturn();

/**
 * "break" statement
 */
void dobreak();

/**
 * "continue" statement
 */
void docont() ;

/**
 * dump switch table
 */
void dumpsw(WHILE *ws);
