/*      File lex.h */


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
void needbrack(char *str);

/**
 *
 * @param str1
 * @return
 */
int sstreq(char *str1);

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
int streq(char str1[], char str2[]);

/**
 * compares two string both must be zero ended, otherwise no match found
 * ensures that the entire token is examined
 * @param str1
 * @param str2
 * @param len
 * @return
 */
int astreq (char str1[], char str2[], int len);

/**
 * looks for a match between a literal string and the current token in
 * the input line. It skips over the token and returns true if a match occurs
 * otherwise it retains the current position in the input line and returns false
 * there is no verification that all of the token was matched
 * @param lit
 * @return
 */
int match (char *lit);

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
int amatch(char *lit, int len) ;

/**
 * reads whitespace characters from input
 */
void blanks();

/**
 * returns declaration type
 * @return CCHAR, CINT, UCHAR, UINT
 */
int get_type();

