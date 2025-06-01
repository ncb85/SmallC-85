/*
 * File sym.h
 */

#include "defs.h"

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
void declare_global(int type, int storage, TAG_SYMBOL *mtag, int otag, int is_struct);

/**
 * initialize global objects
 * @param symbol_name
 * @param type char or integer or struct
 * @param identity
 * @param dim
 * @return 1 if variable is initialized
 */
int initials(char *symbol_name, int type, int identity, int dim, int otag);

/**
 * initialise structure
 * @param tag
 */
void struct_init(TAG_SYMBOL *tag, char *symbol_name);

/**
 * evaluate one initializer, add data to table
 * @param symbol_name
 * @param type
 * @param identity
 * @param dim
 * @param tag
 * @return
 */
int init(char *symbol_name, int type, int identity, int *dim, TAG_SYMBOL *tag);

/**
 * declare local variables
 * works just like "declglb", but modifies machine stack and adds
 * symbol table entry with appropriate stack offset to find it again
 * @param typ
 * @param stclass
 * @param otag index of tag in tag_table
 */
void declare_local(int typ, int stclass, int otag);

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
int find_global (char *sname);

/**
 * search local table for given symbol name
 * @param sname
 * @return table index
 */
int find_locale (char *sname);

/**
 * add new symbol to global table
 * @param sname
 * @param identity
 * @param type
 * @param offset size in bytes
 * @param storage
 * @return new index
 */
int add_global (char *sname, int identity, int type, int offset, int storage);

/**
 * add new symbol to local table
 * @param sname
 * @param identity
 * @param type
 * @param offset size in bytes
 * @param storage_class
 * @return
 */
int add_local(char *sname, int identity, int type, int offset, int storage_class);

/**
 * test if next input string is legal symbol name
 */
int symname(char *sname);

/**
 * print error message
 */
void illname();

/**
 * print error message
 * @param symbol_name
 * @return
 */
void multidef (char *symbol_name);

