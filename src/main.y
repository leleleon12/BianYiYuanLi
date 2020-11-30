%{
    #include "common.h"
    #define YYSTYPE TreeNode *  
    TreeNode* root;
    extern int lineno;
    int yylex();
    int yyerror( char const * );
%}
%token T_CHAR T_INT T_STRING T_BOOL 

%token LOP_ASSIGN 

%token EQ LT LE GT GE NE 

%token AND OR NOT 

%token ADD ADD2 SUB SUB2 MUL DIV MOD QUOTE CONTENT

%token SEMICOLON LPAREN LBRACE RPAREN RBRACE COMMA

%token IDENTIFIER INTEGER CHAR BOOL STRING

%token IF ELSE

%token TRUE FALSE

%token WHILE FOR

%token PRINTF SCANF

%token RETURN

%left LOP_ASSIGN
%left ADD SUB
%left MUL DIV MOD
%right UMIMUS ADD2 SUB2 QUOTE CONTENT
%left EQ NE
%right NOT
%left AND
%left OR
%nonassoc LOWER_THEN_ELSE
%nonassoc ELSE 
%%

program
: statements {root = new TreeNode(0, NODE_PROG); root->addChild($1);};

statements
:  statement {$$=$1;}
|  statements statement {$$=$1; $$->addSibling($2);}
;

statement
: SEMICOLON  {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_SKIP;}
| declaration SEMICOLON {$$ = $1;}
| expr SEMICOLON{$$=$1;}
| assign SEMICOLON{$$=$1;}
| LBRACE statements RBRACE {$$=2;}
| if_else {$$=$1;}
| while {$$=$1;}
| for {$$=$1;}
;

if_else
: IF bool_statment statement %prec LOWER_THEN_ELSE {
    TreeNode *s=new TreeNode(lineno,NODE_STMT);
    node->stype=STMT_IF;
    node->addChild($2);
    node->addChild($3);
    $$=node;
}
| IF bool_statment statement ELSE statement {
    TreeNode *node=new TreeNode(lineno,NODE_STMT);
    node->stmtType=STMT_IF;
    node->addChild($2);
    node->addChild($3);
    node->addChild($5);
    $$=node;
}
;
while
: WHILE bool_statment statement {
    TreeNode *node=new TreeNode(lineno,NODE_STMT);
    node->stype=STMT_WHILE;
    node->addChild($2);
    node->addChild($3);
    $$=node;
}
;
for
: FOR for_con statement{
    TreeNode* node=new TreeNode(lineno,NODE_STMT);
    node->stype=STMT_FOR;
    node->addChild($2);
    node->addChild($3);
    $$=node;
}
;
for_con
: LPAREN assign SEMICOLON bool_expr SEMICOLON cal_expr RPAREN{
    TreeNode* node=new TreeNode(lineno,NODE_STMT);
    node->addChild($2);
    node->addChild($4);
    node->addChild($6);
    $$=node;
}
| LPAREN declaration SEMICOLON bool_expr SEMICOLON cal_expr RPAREN{
    TreeNode* node=new TreeNode(lineno,NODE_STMT);
    node->addChild($2);
    node->addChild($4);
    node->addChild($6);
    $$=node;
} 
;
bool_statment
: LPAREN bool_expr RPAREN {$$=$2;}
;
declaration
: T IDENTIFIER LOP_ASSIGN expr{  // declare and init
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    switch($1->type){
        case TYPE_INT:
            $2->type=TYPE_INT;
            break;
        case TYPE_BOOL:
            $2->type=TYPE_BOOL;
            break;
        case TYPE_CHAR:
            $2->type=TYPE_CHAR;
            break;
    }
    node->stype = STMT_DECL;
    node->addChild($1);
    node->addChild($2);
    node->addChild($4);
    $$ = node;   
} 
| T IDENTIFIER {
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_DECL;
    node->addChild($1);
    node->addChild($2);
    $$ = node;   
}
;
assign
: IDENTIFIER LOP_ASSIGN expr{
    TreeNode* node = new TreeNode($1->lineno,NODE_EXPR);
    node->stype = STMT_ASSIGN;
    node->addChild($1);
    node->addChild($2);
    $$=node;
}
;
expr
: IDENTIFIER {
    $$ = $1;
}
| INTEGER {
    $$ = $1;
}
| CHAR {
    $$ = $1;
}
| STRING {
    $$ = $1;
}
| bool_expr{
    $$=$1;
}
| logit_expr{
    $$=$1;
}
| cal_expr{
    $$=$1;
}
| ptr_expr{
    $$=$1;
}
;
bool_expr
: TRUE {$$=$1;}
| FALSE {$$=$1;}
| expr EQ expr {
    TreeNode *node=new TreeNode($1->lineno,NODE_EXPR);
    node->etype=EXPR_EQUAL;
    node->b_val=$1->int_val==$3->int_val;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| expr LT expr{
    TreeNode * node=new TreeNode($1->lineno,NODE_EXPR);
    node->b_val=$1->int_val < $3->int_val;
    node->etype=EXPR_LT;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| expr LE expr{
    TreeNode * node=new TreeNode($1->lineno,NODE_EXPR);
    node->b_val=$1->int_val <=$3->int_val;
    node->etype=EXPR_LE;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| expr GT expr{
    TreeNode * node=new TreeNode($1->lineno,NODE_EXPR);
    node->b_val=$1->int_val>$3->int_val;
    node->etype=EXPR_GT;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| expr GE expr{
    TreeNode * node=new TreeNode($1->lineno,NODE_EXPR);
    node->b_val=$1->int_val>=$3->int_val;
    node->etype=EXPR_GE;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| expr NE expr{
    TreeNode * node=new TreeNode($1->lineno,NODE_EXPR);
    node->b_val=$1->int_val != $3->int_val;
    node->etype=EXPR_NE;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
;
logit_expt
: bool_expr AND bool_expr{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->etype=EXPR_AND;
    node->b_val=$1->b_val && $3->b_val;
    node->addChild($1);
    node->addChild($3)
}
| bool_expr OR bool_expr{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->etype=EXPR_OR;
    node->b_val=$1->b_val || $3->b_val;
    node->addChild($1);
    node->addChild($3)
}
| NOT bool_expr {
    TreeNode *node=new TreeNode(lineno,NODE_EXPR);
    node->b_val=!$2->b_val;
    node->etype=EXPR_NOT;
    node->addChild($2);
    $$=node;        
}
;
ptr_expr
: QUOTE IDENTIFIER{
    TreeNode *node=new TreeNode(lineno,NODE_EXPR);
    node->etype=EXPR_QUOTE;
    node->addChild($2);
    $$=node;
}
| CONTENT IDENTIFIER{
    TreeNode* node=new TreeNode(lineno,NODE_EXPR);
    node->etype=EXPR_CONTENT;
    node->addChild($2);
    $$=node;
}
;
printf
: PRINTF LPAREN expr RPAREN {
    TreeNode *node=new TreeNode(lineno,NODE_STMT);
    node->stype=STMT_PRINTF;
    node->addChild($3);
    $$=node;
}
| PRINTF LPAREN STRING COMMA expr RPAREN {
    TreeNode *node=new TreeNode(lineno,NODE_STMT);
    node->stype=STMT_PRINTF;
    node->addChild($3)
    node->addChild($5);
    $$=node;
}
;
scanf
: SCANF LPAREN expr RPAREN {
    TreeNode *node=new TreeNode(lineno,NODE_STMT);
    node->stype=STMT_SCANF;
    node->addChild($3);
    $$=node;
}
| SCANF LPAREN STRING COMMA expr RPAREN {
    TreeNode *node=new TreeNode(lineno,NODE_STMT);
    node->stype=STMT_SCANF;
    node->addChild($3)
    node->addChild($5);
    $$=node;
}
;
cal_expr
: expr ADD expr{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->etype=EXPR_ADD;
    node->int_val=$1->int_val+$3->int_val;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| expr ADD2{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->etype=EXPR_ADD2;
    node->int_val=$1->int_val++;
    node->addChild($1);
    $$=node;
}
| ADD2 expr{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->etype=EXPR_ADD2;
    node->int_val=++$2->int_val;
    node->addChild($2);
    $$=node;
}
| expr SUB2{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->etype=EXPR_SUB2;
    node->int_val=$1->int_val--;
    node->addChild($1);
    $$=node;
}
| SUB2 expr{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->etype=EXPR_SUB2;
    node->int_val=--$2->int_val;
    node->addChild($2);
    $$=node;
}
| expr SUB expr{
    TreeNode* node =new TreeNode($1->lineno,NODE_EXPR);
    node->etype=EXPR_SUB;
    node->int_val=$1->int_val-$3->int_val;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| expr MUL expr{
    TreeNode* node =new TreeNode($1->lineno,NODE_EXPR);
    node->etype=EXPR_MUL;
    node->int_val=$1->int_val*$3->int_val;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| expr DIV expr{
    TreeNode* node =new TreeNode($1->lineno,NODE_EXPR);
    node->etype=EXPR_DIV;
    node->int_val=$1->int_val/$3->int_val;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| expr MOD expr{
    TreeNode* node =new TreeNode($1->lineno,NODE_EXPR);
    node->etype=EXPR_MOD;
    node->int_val=$1->int_val % $3->int_val;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| ADD expr %prec UMIMUS {
    TreeNode* node =new TreeNode(lineno,NODE_EXPR);
    node->etype=EXPR_POS;
    node->int_val=$2->int_val;
    node->addChild($2);
    $$=node;
}
| SUB expr %prec UMIMUS {
    TreeNode* node =new TreeNode(lineno,NODE_EXPR);
    node->etype=EXPR_NEG;
    node->int_val=-($2->int_val);
    node->addChild($2);
    $$=node;
}
;
return
: RETURN expr{
    TreeNode* node = new TreeNode(lineno,NODE_STMT);
    node->stype=STMT_RET;
    node->addChild($2);
    $$=node;
}
;
T: T_INT {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_INT;} 
| T_CHAR {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_CHAR;}
| T_BOOL {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_BOOL;}
;

%%

int yyerror(char const* message)
{
  cout << message << " at line " << lineno << endl;
  return -1;
}