#include "tree.h"
queue<TreeNode*> tree_q;
int nodeID=0;
void TreeNode::addChild(TreeNode* child) {
    if (this->child!=nullptr)
    {
        this->child->addSibling(child);
    }
    else{
        this->child=child;
    }
    return;
}

void TreeNode::addSibling(TreeNode* sibling){
    if(this->sibling==nullptr){
        this->sibling=sibling;
    }
    else
    {
        TreeNode* cursib=this->sibling;
        TreeNode* nextsib=cursib->sibling;
        while (nextsib!=nullptr)
        {
            cursib=nextsib;
            nextsib=cursib->sibling;
        }
        cursib->sibling=sibling;
    }
    
}

TreeNode::TreeNode(int lineno, NodeType type) {
    this->lineno=lineno;
    this->nodeType=type;
    
}

void TreeNode::genNodeId() {
    this->nodeID=nodeID;
    nodeID++;
    TreeNode* child=this->child;
    while (child!=nullptr)
    {
        tree_q.push(child);
        child=child->sibling;
    }
    if(!tree_q.empty()){
        TreeNode* next=tree_q.front();
        tree_q.pop();
        next->genNodeId();
    }
    return;
}

void TreeNode::printNodeInfo() {
    cout<<"@"<<this->nodeID<<" ";
    this->printSpecialInfo();
    this->printChildrenId();
    cout<<endl;
}

void TreeNode::printChildrenId() {
    TreeNode* child=this->child;
    cout<<"child:  ";
    while (child!=nullptr)
    {
        cout<<child->nodeID<<" ";
        child=child->sibling;
    }
    return;
}

void TreeNode::printAST() {
    this->printNodeInfo();
    TreeNode* child=this->child;
    while (child!=nullptr)
    {
        tree_q.push(child);
        child=child->sibling;
    }
    if(!tree_q.empty()){
        TreeNode* next=tree_q.front();
        tree_q.pop();
        next->printAST();
    }
    return;
}


// You can output more info...
void TreeNode::printSpecialInfo() {
    switch(this->nodeType){
        case NODE_CONST:
            cout<<"CONST  ";
            cout<<"type:"<<this->type->getTypeInfo()<<"  ";
            break;
        case NODE_VAR:
            cout<<"VAR  ";
            cout<<"type:"<<this->type->getTypeInfo()<<"  ";
            cout<<"var name:"<<this->var_name<<"  ";
            break;
        case NODE_EXPR:
            cout<<"EXPR  ";
            switch (this->etype)
            {
            case EXPR_ADD2:
                cout<<"EXPR_ADD2  ";
                cout<<"value:"<<this->int_val<<"  ";
                break;
             case EXPR_EQUAL:
                cout<<"EXPR_EQUAL  ";
                cout<<"value:"<<this->b_val<<"  ";
                break;
             case EXPR_NOT:
                cout<<"EXPR_NOT  ";
                cout<<"value:"<<this->b_val<<"  ";
                break; 
             case EXPR_LT:
                cout<<"EXPR_LT  ";
                cout<<"value:"<<this->b_val<<"  ";
                break;   
             case EXPR_LE:
                cout<<"EXPR_LE  ";
                cout<<"value:"<<this->b_val<<"  ";
                break;  
             case EXPR_GT:
                cout<<"EXPR_GT  ";
                cout<<"value:"<<this->b_val<<"  ";
                break; 
             case EXPR_GE:
                cout<<"EXPR_GE  ";
                cout<<"value:"<<this->b_val<<"  ";
                break; 
             case EXPR_NE:
                cout<<"EXPR_NE  ";
                cout<<"value:"<<this->b_val<<"  ";
                break; 
             case EXPR_ADD:
                cout<<"EXPR_ADD  ";
                cout<<"value:"<<this->int_val<<"  ";
             case EXPR_SUB:
                cout<<"EXPR_SUB  ";
                cout<<"value:"<<this->int_val<<"  ";
                break; 
             case EXPR_SUB2:
                cout<<"EXPR_SUB2  ";
                cout<<"value:"<<this->int_val<<"  ";
                break;
             case EXPR_MUL:
                cout<<"EXPR_MUL  ";
                cout<<"value:"<<this->int_val<<"  ";
                break;
             case EXPR_DIV:
                cout<<"EXPR_DIV  ";
                cout<<"value:"<<this->int_val<<"  ";
                break;
             case EXPR_MOD:
                cout<<"EXPR_MOD  ";
                cout<<"value:"<<this->int_val<<"  ";
                break;
             case EXPR_POS:
                cout<<"EXPR_POS  ";
                cout<<"value:"<<this->int_val<<"  ";
                break;
             case EXPR_NEG:
                cout<<"EXPR_NEG  ";
                cout<<"value:"<<this->int_val<<"  ";
                break;
             case EXPR_AND:
                cout<<"EXPR_AND  ";
                cout<<"value:"<<this->b_val<<"  ";
                break;
             case EXPR_OR:
                cout<<"EXPR_OR  ";
                cout<<"value:"<<this->b_val<<"  ";
                break;
             case EXPR_CONTENT:
                cout<<"EXPR_CONTENT  ";
                break;
             case EXPR_QUOTE:
                cout<<"EXPR_QUOTE  ";
                break;
            default:
                break;
            }
            break;
        case NODE_STMT:
            cout<<"STMT  ";
            cout<<sType2String(this->stype);
        case NODE_TYPE:
            cout<<"TYPE  ";
            cout<<this->type->getTypeInfo()<<"  ";  
            break;
        default:
            break;
    }
}

string TreeNode::sType2String(StmtType type) {
     switch (type)
            {
            case STMT_SKIP:
                return"STMT_SKIP  ";
                break;
            case STMT_DECL:
                return"STMT_DECL  ";
                break;
            case STMT_ASSIGN:
                return"STMT_ASSIGN  ";
                break;
            case STMT_IF:
                return"STMT_IF  ";
                break;
            case STMT_WHILE:
                return"STMT_WHILE  ";
                break;
            case STMT_FOR:
                return"STMT_FOR  ";
                break;
            case STMT_RET:
                return"STMT_RET  ";
                break;
            case STMT_PRINTF:
                return"STMT_PRINTF  ";
                break;
            case STMT_SCANF:
                return"STMT_SCANF  ";
                break;
            default:
                break;
            }     
    return"?";      
}


void TreeNode::nodeType2String (NodeType type){
    return ;
}
