/*
 * File struct.h
 */

 #include "defs.h"

/**
 * look up a tag in tag table by name
 * @param sname
 * @return index
 */
int find_tag(char *sname);

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
int add_member(char *sname, char identity, char type, int offset, int storage_class, int member_size);

int define_struct(char *sname, int storage, int is_struct);
