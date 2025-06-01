#include <stdio.h>
#include <string.h>
#include "defs.h"
#include "data.h"

#include "error.h"
#include "lex.h"

/**
 * erase the data storage
 */
void create_initials();

/**
 * add new symbol to table, initialise begin position in data array
 * @param symbol_name
 * @param type
 */
void add_symbol_initials(char *symbol_name, char type);

/**
 * find symbol in table, count position in data array
 * @param symbol_name
 * @return
 */
int find_symbol_initials(char *symbol_name);

/**
 * add data to table for given symbol
 * @param symbol_name
 * @param type
 * @param value
 * @param tag
 */
void add_data_initials(char *symbol_name, int type, int value, TAG_SYMBOL *tag);

/**
 * get number of data items for given symbol
 * @param symbol_name
 * @return
 */
int get_size(char *symbol_name);

/**
 * get item at position
 * @param symbol_name
 * @param position
 * @param itag index of tag in tag table
 * @return
 */
int get_item_at(char *symbol_name, int position, TAG_SYMBOL *tag);