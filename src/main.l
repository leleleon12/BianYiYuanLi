%option nounput
%{
#include "common.h"
#include "main.tab.h"  // yacc header
int lineno=1;
%}
BLOCKCOMMENT \/\*([^\*^\/]*|[\*^\/*]*|[^\**\/]*)*\*\/
LINECOMMENT \/\/[^\n]*
EOL	(\r\n|\r|\n)
WHILTESPACE [[:blank:]]

INTEGER [0-9]+

CHAR \'.?\'
STRING \".+\"

IDENTIFIER [[:alpha:]_][[:alpha:][:digit:]_]*
%%

{BLOCKCOMMENT}  /* do nothing */
{LINECOMMENT}  /* do nothing */


"int" return T_INT;
"bool" return T_BOOL;
"char" return T_CHAR;

"=" return LOP_ASSIGN;
"==" return EQ;
"!" return NOT;
"+" return ADD;
"++" return ADD2;
"-" return SUB;
"--" return SUB2;
"*" return MUL;
"/" return DIV;
"%" return MOD;
"<" return LT;
"<=" return LE;
">" return GT;
">=" return GE;
"!=" return NE;

"printf" return PRINTF;
"scanf" return SCANF;

";" return SEMICOLON;
"," return COMMA;
"(" return LPAREN;
")" return RPAREN;
"{" return LBRACE;
"}" return RBRACE;

"&" return QUOTE;
"*" return CONTENT;
 
"if" return IF;
"else" return ELSE; 

"while" return WHILE;
"for" return FOR;
"true" {
    TreeNode *node = new TreeNode(lineno,NODE_CONST);
    node->b_val = true;
    yylval = node;
    return TRUE;
}
"false" {
    TreeNode *node = new TreeNode(lineno,NODE_CONST);
    node->b_val = false;
    yylval = node;
    return FALSE;
}
{INTEGER} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_INT;
    node->int_val = atoi(yytext);
    yylval = node;
    return INTEGER;
}

{CHAR} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_CHAR;
    node->int_val = yytext[1];
    yylval = node;
    return CHAR;
}

{STRING} {
    TreeNode* node =new TreeNode(lineno,NODE_CONST)
    node->type = TYPE_STRING;
    node->str_val=string(yytext);
    yylval = node;
    return STRING
}
{IDENTIFIER} {
    TreeNode* node = new TreeNode(lineno, NODE_VAR);
    node->var_name = string(yytext);
    yylval = node;
    return IDENTIFIER;
}

{WHILTESPACE} /* do nothing */

{EOL} lineno++;

. {
    cerr << "[line "<< lineno <<" ] unknown character:" << yytext << endl;
}
%%