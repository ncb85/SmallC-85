/*
 * File extern.h: 1.0 (2018/12/29,22:45)
 */

/**
 * The functions created to implement this C compiler have wide and diverse
 * couplings and dependencies.
 * In order to silence pedantic warnings by very modern compilers, this module
 * creates the external declarations required for everybody to cross connect.
 *
 * This is a list of all declarations used outside of the various modules.
 * The modules are listed in alphabetical order.
 * An attempt has been made to list the procedures in the same order they
 * appear in the module.
 *
 * To make the breaks between module listings easier, comment
 * formatting adds a long row of asterisks.
 *
 * Descriptive comments, if any, appearing in the module are copied
 * here along with the declaration.
 *
 * Prodedures not used outside the scope of a module may appear as forward
 * declarations in the module.  Ideally no prodcure local to a module
 * should be listed here.
 */

/*************************************************************************
 * c8080.c (Target routines.)
 */

/**
 * print all assembler info before any code is generated
 */
void header ();

void initmac();

/**
 * prints new line
 * @return
 */
void newline ();

/**
 * Output internal generated label prefix
 */
void output_label_prefix();

/**
 * Output a label definition terminator
 */
void output_label_terminator ();

/**
 * print any assembler stuff needed after all code
 */
void trailer();

/**
 * text (code) segment
 */
void code_segment_gtext();

/**
 * data segment
 */
void data_segment_gdata();

/**
 * begin a comment line for the assembler
 */
void gen_comment();

/**
 * Output the variable symbol at scptr as an extrn or a public
 * @param scptr
 */
void ppubext(SYMBOL *scptr);

/**
 * Output the function symbol at scptr as an extrn or a public
 * @param scptr
 */
void fpubext(SYMBOL *scptr);

/**
 * Output a decimal number to the assembler file, with # prefix
 * @param num
 */
void output_number();

/**
 * fetch a static memory cell into the primary register
 * @param sym
 */
void gen_get_memory (SYMBOL *sym);

/**
 * asm - fetch the address of the specified symbol into the primary register
 * @param sym the symbol name
 * @return which register pair contains result
 */
int gen_get_locale(SYMBOL *sym);

/**
 * asm - store the primary register into the specified static memory cell
 * @param sym
 */
void gen_put_memory (SYMBOL *sym);

/**
 * fetch the specified object type indirect through the primary
 * register into the primary register
 * @param typeobj object type
 */
/**
 * store the specified object type in the primary register
 * at the address in secondary register (on the top of the stack)
 * @param typeobj
 */
void gen_put_indirect(char typeobj);

/**
 * fetch the specified object type indirect through the primary
 * register into the primary register
 * @param typeobj object type
 */
void gen_get_indirect(char typeobj, int reg);

/**
 * swap the primary and secondary registers
 */
void gen_swap();

/**
 * print partial instruction to get an immediate value into
 * the primary register
 */
void gen_immediate ();

/**
 * push the primary register onto the stack
 */
void gen_push();

/**
 * pop the top of the stack into the secondary register
 */
void gen_pop();

/**
 * swap the primary register and the top of the stack
 */
void gen_swap_stack();

/**
 * call the specified subroutine name
 * @param sname subroutine name
 */
void gen_call();

/**
 * declare entry point
 */
void declare_entry_point();

/**
 * return from subroutine
 */
void gen_ret();

/**
 * perform subroutine call to value on top of stack
 */
void callstk();

/**
 * jump to specified internal label number
 * @param label the label
 */
void gen_jump();

/**
 * test the primary register and jump if false to label
 * @param label the label
 * @param ft if true jnz is generated, jz otherwise
 */
void gen_test_jump();

/**
 * print pseudo-op  to define a byte
 */
void gen_def_byte();

/**
 * print pseudo-op to define storage
 */
void gen_def_storage();

/**
 * print pseudo-op to define a word
 */
void gen_def_word();

/**
 * modify the stack pointer to the new value indicated
 * @param newstkp new value
 */
int gen_modify_stack();

/**
 * multiply the primary register by INTSIZE
 */
void gen_multiply_by_two();

/**
 * divide the primary register by INTSIZE, never used
 */
void gen_divide_by_two();

/**
 * Case jump instruction
 */
void gen_jump_case();

/**
 * add the primary and secondary registers
 * if lval2 is int pointer and lval is not, scale lval
 * @param lval
 * @param lval2
 */
void gen_add();

/**
 * subtract the primary register from the secondary
 */
void gen_sub();

/**
 * multiply the primary and secondary registers (result in primary)
 */
void gen_mult();

/**
 * divide the secondary register by the primary
 * (quotient in primary, remainder in secondary)
 */
void gen_div();

/**
 * unsigned divide the secondary register by the primary
 * (quotient in primary, remainder in secondary)
 */
void gen_udiv();

/**
 * compute the remainder (mod) of the secondary register
 * divided by the primary register
 * (remainder in primary, quotient in secondary)
 */
void gen_mod();

/**
 * compute the remainder (mod) of the secondary register
 * divided by the primary register
 * (remainder in primary, quotient in secondary)
 */
void gen_umod();

/**
 * inclusive 'or' the primary and secondary registers
 */
void gen_or();

/**
 * exclusive 'or' the primary and secondary registers
 */
void gen_xor();

/**
 * 'and' the primary and secondary registers
 */
void gen_and();
/**
 * arithmetic shift right the secondary register the number of
 * times in the primary register (results in primary register)
 */
void gen_arithm_shift_right();

/**
 * logically shift right the secondary register the number of
 * times in the primary register (results in primary register)
 */
void gen_logical_shift_right();

/**
 * arithmetic shift left the secondary register the number of
 * times in the primary register (results in primary register)
 */
void gen_arithm_shift_left();

/**
 * two's complement of primary register
 */
void gen_twos_complement();

/**
 * logical complement of primary register
 */
void gen_logical_negation();

/**
 * one's complement of primary register
 */
void gen_complement();

/**
 * Convert primary value into logical value (0 if 0, 1 otherwise)
 */
void gen_convert_primary_reg_value_to_bool();

/**
 * increment the primary register by 1 if char, INTSIZE if int
 */
void gen_increment_primary_reg(LVALUE *lval);

/**
 * decrement the primary register by one if char, INTSIZE if int
 */
void gen_decrement_primary_reg(LVALUE *lval);

/**
 * following are the conditional operators.
 * they compare the secondary register against the primary register
 * and put a literal 1 in the primary if the condition is true,
 * otherwise they clear the primary register
 */

/**
 * equal
 */
void gen_equal();

/**
 * not equal
 */
void gen_not_equal();

/**
 * less than (signed)
 */
void gen_less_than();

/**
 * less than or equal (signed)
 */
void gen_less_or_equal();

/**
 * greater than (signed)
 */
void gen_greater_than();

/**
 * greater than or equal (signed)
 */
void gen_greater_or_equal();

/**
 * less than (unsigned)
 */
void gen_unsigned_less_than();

/**
 * less than or equal (unsigned)
 */
void gen_unsigned_less_or_equal();

/**
 * greater than (unsigned)
 */
void gen_usigned_greater_than();

/**
 * greater than or equal (unsigned)
 */
void gen_unsigned_greater_or_equal();

char *inclib();

/**
 * Squirrel away argument count in a register that modstk doesn't touch.
 * @param d
 */
void gnargs();

int assemble();

int link();

/**
 * print partial instruction to get an immediate value into
 * the secondary register
 */
void gen_immediate2();

/**
 * add offset to primary register
 * @param val the value
 */
void add_offset();

/**
 * multiply the primary register by the length of some variable
 * @param type
 * @param size
 */
void gen_multiply();

/*************************************************************************
 * error.c
 */

void error ();

void doerror ();

/*************************************************************************
 * expr.c
 */

/**
 * unsigned operand ?
 */
int nosign(LVALUE *is);

/**
 * assignment operators
 * @param lval
 * @return
 */
int hier1 (LVALUE *lval);


/*************************************************************************
 * function.c
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
void getarg();


/*************************************************************************
 * gen.c
 */

/**
 * return next available internal label number
 */
int getlabel();

/**
 * print specified number as label
 * @param label
 */
void print_label();

/**
 * glabel - generate label
 * not used ?
 * @param lab label number
 */
void glabel();

/**
 * gnlabel - generate numeric label
 * @param nlab label number
 * @return 
 */
void generate_label();

/**
 * outputs one byte
 * @param c
 * @return 
 */
char output_byte(char c);

/**
 * outputs a string
 * @param ptr the string
 * @return 
 */
void output_string();

/**
 * outputs a tab
 * @return 
 */
void print_tab();

/**
 * output line
 * @param ptr
 * @return 
 */
void output_line();

/**
 * tabbed output
 * @param ptr
 * @return 
 */
void output_with_tab();

/**
 * output decimal number
 * @param number
 * @return 
 */
void output_decimal();

/**
 * stores values into memory
 * @param lval
 * @return 
 */
void store(LVALUE *lval);

int rvalue();

/**
 * parses test part "(expression)" input and generates assembly for jump
 * @param label
 * @param ft : false - test jz, true test jnz
 * @return 
 */
void test();

/**
 * scale constant depending on type
 * @param type
 * @param otag
 * @param size
 * @return 
 */
void scale_const();


/*************************************************************************
 * initials.c
 */

/**
 * erase the data storage
 */
void create_initials();

/**
 * find symbol in table, count position in data array
 * @param symbol_name
 * @return
 */
int find_symbol_initials();

/**
 * add data to table for given symbol
 * @param symbol_name
 * @param type
 * @param value
 * @param tag
 */
void add_data_initials();

/**
 * get number of data items for given symbol
 * @param symbol_name
 * @return
 */
int get_size();

/**
 * get item at position
 * @param symbol_name
 * @param position
 * @param itag index of tag in tag table
 * @return
 */
int get_item_at();

/*************************************************************************
 * io.c
 */

/*
 *      open input file
 */
int openin ();

/*
 *      open output file
 */
int openout ();

/*
 *      change input filename to output filename
 */
void outfname ();

/**
 * remove NL from filenames
 */
void fixname ();

/**
 * check that filename is "*.c"
 */
int checkname ();

void kill ();

void readline ();

char inbyte ();

char inchar ();

/**
 * gets current char from input line and moves to the next one
 * @return current char
 */
char gch ();

/**
 * returns next char
 * @return next char
 */
char nch ();

/**
 * returns current char
 * @return current char
 */
char ch ();

/*
 *      print a carriage return and a string only to console
 *
 */
void pl ();


/*************************************************************************
 * lex.c
 */

/**
 * test if given character is alpha
 * @param c
 * @return
 */
int alpha(char c);

/**
 * test if given character is numeric
 * @param c
 * @return
 */
int numeric(char c);

/**
 * test if given character is alphanumeric
 * @param c
 * @return
 */
int alphanumeric(char c);

/**
 * semicolon enforcer
 * called whenever syntax requires a semicolon
 */
void need_semicolon();

void junk();

int endst();

/**
 * enforces bracket
 * @param str
 * @return
 */
void needbrack();

/**
 *
 * @param str1
 * @return
 */
int sstreq();

/**
 * indicates whether or not the current substring in the source line matches a
 * literal string
 * accepts the address of the current character in the source
 * line and the address of the a literal string, and returns the substring
 * length if a match occurs and zero otherwise
 * @param str1 address1
 * @param str2 address2
 * @return
 */
int streq();

/**
 * compares two string both must be zero ended, otherwise no match found
 * ensures that the entire token is examined
 * @param str1
 * @param str2
 * @param len
 * @return
 */
int astreq ();

/**
 * looks for a match between a literal string and the current token in
 * the input line. It skips over the token and returns true if a match occurs
 * otherwise it retains the current position in the input line and returns false
 * there is no verification that all of the token was matched
 * @param lit
 * @return
 */
int match ();

/**
 * compares two string both must be zero ended, otherwise no match found
 * advances line pointer only if match found
 * it assumes that an alphanumeric (including underscore) comparison
 * is being made and guarantees that all of the token in the source line is
 * scanned in the process
 * @param lit
 * @param len
 * @return
 */
int amatch();

void blanks();

/**
 * returns declaration type
 * @return CCHAR, CINT, UCHAR, UINT
 */
int get_type();

/*************************************************************************
 * main.c
 */

/**
 * parse top level declarations
 * @param stclass storage
 * @param mtag
 * @param is_struct
 * @return
 */
int do_declarations();

/**
 * dump struct data
 * @param symbol struct variable
 * @param position position of the struct in the array, or zero
 */
void dump_struct(SYMBOL *symbol, int position);

/* Writes the frontend version to the output */

void frontend_version();

/*************************************************************************
 * preproc.c
 */

/**
 * open an include file
 */
void doinclude ();

/**
 * "asm" pseudo-statement
 * enters mode where assembly language statements are passed
 * intact through parser
 */
void doasm ();

void dodefine ();

void doundef ();

void preprocess ();

/**
 * "asm" pseudo-statement
 * enters mode where assembly language statements are passed
 * intact through parser
 */
void doasm ();

void defmac();


/*************************************************************************
 * primary.c
 */

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

int constant ();

int number ();

/**
 * Test if we have one char enclosed in single quotes
 * @param value returns the char found
 * @return 1 if we have, 0 otherwise
 */
int quoted_char ();

/**
 * Test if we have string enclosed in double quotes. e.g. "abc".
 * Load the string into literal pool.
 * @param position returns beginning of the string
 * @return 1 if such string found, 0 otherwise
 */
int quoted_string ();

/**
 * decode special characters (preceeded by back slashes)
 */
char spechar();

/**
 * perform a function call
 * called from "hier11", this routine will either call the named
 * function, or if the supplied ptr is zero, will call the contents
 * of HL
 * @param ptr name of the function
 */
void callfunction ();

void needlval ();

/*************************************************************************
 * stmt.c
 */

/**
 * lval.symbol - symbol table address, else 0 for constant
 * lval.indirect - type indirect object to fetch, else 0 for static object
 * lval.ptr_type - type pointer or array, else 0
 * @param comma
 * @return
 */
void expression();

/**
 * statement parser
 * called whenever syntax requires a statement.  this routine
 * performs that statement and returns a number telling which one
 * @param func func is true if we require a "function_statement", which
 * must be compound, and must contain "statement_list" (even if
 * "declaration_list" is omitted)
 * @return statement type
 */
int statement ();

/*************************************************************************
 * struct.c
 */

/**
 * look up a tag in tag table by name
 * @param sname
 * @return index
 */
int find_tag();

/**
 * determine if 'sname' is a member of the struct with tag 'tag'
 * @param tag
 * @param sname
 * @return pointer to member symbol if it is, else 0
 */
SYMBOL *find_member(TAG_SYMBOL *tag, char *sname);

/**
 * add new structure member to table
 * @param sname
 * @param identity - variable, array, pointer, function
 * @param typ
 * @param offset
 * @param storage
 * @return
 */
void add_member(char *sname, char identity, char type, int offset, int storage_class, int member_size);

int define_struct();

/*************************************************************************
 * sym.c
 */

/**
 * declare a static variable
 * @param type
 * @param storage
 * @param mtag tag of struct whose members are being declared, or zero
 * @param otag tag of struct object being declared. only matters if mtag is
 *             non-zero
 * @param is_struct struct or union or no meaning
 * @return
 */
void declare_global();

/**
 * declare local variables
 * works just like "declglb", but modifies machine stack and adds
 * symbol table entry with appropriate stack offset to find it again
 * @param typ
 * @param stclass
 * @param otag index of tag in tag_table
 */
void declare_local();

/**
 * get required array size. [xx]
 * @return array size
 */
int needsub();

/**
 * search global table for given symbol name
 * @param sname
 * @return table index
 */
int find_global ();

/**
 * search local table for given symbol name
 * @param sname
 * @return table index
 */
int find_locale ();

/**
 * add new symbol to global table
 * @param sname
 * @param identity
 * @param type
 * @param offset size in bytes
 * @param storage
 * @return new index
 */
int add_global ();

/**
 * add new symbol to local table
 * @param sname
 * @param identity
 * @param type
 * @param offset size in bytes
 * @param storage_class
 * @return
 */
int add_local();

/**
 * test if next input string is legal symbol name
 */
int symname();

/**
 * print error message
 */
void illname();

/**
 * print error message
 * @param symbol_name
 * @return
 */
void multidef ();

/*************************************************************************
 * while.c
 */

void addwhile (WHILE *ptr);
void delwhile ();
WHILE *readwhile();
WHILE *findwhile();
WHILE *readswitch();
void addcase ();

