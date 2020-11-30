#ifndef TREE_H
#define TREE_H

#include "pch.h"
#include "type.h"

enum NodeType
{
    NODE_CONST, 
    NODE_VAR,
    NODE_EXPR,
    NODE_TYPE,

    NODE_STMT,
    NODE_PROG,
 
};

enum OperatorType
{
    OP_EQ,  // ==
};

enum StmtType {
    STMT_SKIP,
    STMT_DECL,
    STMT_ASSIGN,
    STMT_IF,
    STMT_WHILE,
    STMT_FOR,
    STMT_RET,
    STMT_PRINTF,
    STMT_SCANF,
}
;
enum ExprType{
    EXPR_EQUAL,
    EXPR_NOT,
    EXPR_LT,
    EXPR_LE,
    EXPR_GT,
    EXPR_GE,
    EXPR_NE,
    EXPR_ADD,
    EXPR_ADD2,
    EXPR_SUB,
    EXPR_SUB2,
    EXPR_MUL,
    EXPR_DIV,
    EXPR_MOD,
    EXPR_POS,
    EXPR_NEG,
    EXPR_AND,
    EXPR_OR,
    EXPR_CONTENT,
    EXPR_QUOTE,
}
;

struct TreeNode {
public:
    int nodeID;  // 用于作业的序号输出
    int lineno;
    NodeType nodeType;

    TreeNode* child = nullptr;
    TreeNode* sibling = nullptr;

    void addChild(TreeNode*);
    void addSibling(TreeNode*);
    
    void printNodeInfo();
    void printChildrenId();

    void printAST(); // 先输出自己 + 孩子们的id；再依次让每个孩子输出AST。
    void printSpecialInfo();

    void genNodeId();

public:
    OperatorType optype;  // 如果是表达式
    Type* type;  // 变量、类型、表达式结点，有类型。
    StmtType stype;//语句类型
    ExprType etype;//表达式类型
    int int_val;
    char ch_val;
    bool b_val;
    string str_val;
    string var_name;
public:
    static void nodeType2String (NodeType type);
    static string opType2String (OperatorType type);
    static string sType2String (StmtType type);

public:
    TreeNode(int lineno, NodeType type);
};

#endif