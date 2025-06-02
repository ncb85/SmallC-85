/*      File code8080.h */

/**
 * print all assembler info before any code is generated
 */
void header ();

/**
 * prints new line
 * @return
 */
void newline ();

void initmac();

/**
 * Output internal generated label prefix
 */
void output_label_prefix();

/**
 * Output a label definition terminator
 */
void output_label_terminator ();

/**
 * begin a comment line for the assembler
 */
void gen_comment();

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
void output_number(int num);

/**
 * fetch a static memory cell into the primary register
 * @param sym
 */
void gen_get_memory(SYMBOL *sym);

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
void gen_put_memory(SYMBOL *sym);

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
void gen_immediate();

/**
 * push the primary register onto the stack
 */
void gen_push(int reg);

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
void gen_call(char *sname);

/**
 * declare entry point
 */
void declare_entry_point(char *symbol_name);

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
void gen_jump(int label);

/**
 * test the primary register and jump if false to label
 * @param label the label
 * @param ft if true jnz is generated, jz otherwise
 */
void gen_test_jump(int label, int ft);

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
int gen_modify_stack(int newstkp);

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
void gen_add(LVALUE *lval, LVALUE *lval2);

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
void gnargs(int d);

int assemble(char *s);

// linking files not implemented
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
void add_offset(int val);

/**
 * multiply the primary register by the length of some variable
 * @param type
 * @param size
 */
void gen_multiply(int type, int size);

