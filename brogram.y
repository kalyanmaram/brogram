%{
#define YYSTYPE long
#include <stdio.h>
#include <stdlib.h>

/* Global variables */
#define null 0

/* Parse tree record structure */
typedef struct node {
    int token;
    int val;
    struct node *ptr1;
    struct node *ptr2;
    struct node *ptr3;
    struct node *ptr4;
} node;

/* Prototypes */
void yyerror(const char* s);
int yylex(void);
long makeNode(int token, int val, long p1, long p2, long p3, long p4);
int evalExpr(node* tree);
void runStmt(long ptr);
void computeStmt(node* tree);
void cleanUp(node* tree);
void systemError(const char* str);

int getVar(int id);
void storeVar(int id, int val);

/* Variable */
int vars[26];

%}

/* BISON Declarations */

%start brogram  /* start rule */

%token NUM STRING VAR

%token STARTBRO ENDBRO BROPRINT BROGIVE BROLOOP BROSWITCH BROCASE BROBREAK
%token EQ GT LT NEQ ASSIGN

%token NAME ID
%token PLUS MINUS MULT DIV NEGATIVE
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON COLON

%left '+' '-'
%left '*' '/'
%right '^'

/* Grammar follows */
%%

brogram: STARTBRO LBRACE code RBRACE ENDBRO                { }
;

code:     statement code
        | statement
;

statement: BROPRINT LPAREN expr RPAREN SEMICOLON          { $$ = makeNode(BROPRINT, 0, $3, null, null, null); runStmt($$); }
        | BROGIVE VAR SEMICOLON                           { $$ = makeNode(BROGIVE, 0, $2, null, null, null); runStmt($$); }
        | BROLOOP LPAREN cond RPAREN LBRACE code RBRACE   { $$ = makeNode(BROLOOP, 0, $3, $6, null, null); runStmt($$); }
        | BROSWITCH LBRACE switch_cases RBRACE            { $$ = makeNode(BROSWITCH, 0, $3, null, null, null); runStmt($$); }
        | VAR ASSIGN expr SEMICOLON                       { $$ = makeNode(ASSIGN, 0, makeNode(VAR,$1,null,null,null,null), $3, null, null); runStmt($$);}
;

switch_cases: case switch_cases
            | case
;

case:     BROCASE cond COLON LBRACE code BROBREAK SEMICOLON RBRACE  { $$ = makeNode(BROCASE, 0, $2, $5, null, null); }
;

expr:     expr '+' term            { $$ = makeNode(PLUS, 0, $1, $3, null, null); }
        | expr '-' term            { $$ = makeNode(MINUS, 0, $1, $3, null, null); }
        | term                     { $$ = $1; }
;


term:     term '*' factor           { $$ = makeNode(MULT, 0, $1, $3, null, null); }
        | term '/' factor            { $$ = makeNode(DIV, 0, $1, $3, null, null); }
        | factor                     { $$ = $1; }
;

factor:   LPAREN expr RPAREN          { $$ = $2; }
        | val                         { $$ = $1; }
        | '-' factor                  { $$ = makeNode(NEGATIVE,0,$2,0,0,0);}
;

cond:     val EQ val                 { $$ = makeNode(EQ, 0, $1, $3, null, null); }
        | val GT val                 { $$ = makeNode(GT, 0, $1, $3, null, null); }
        | val LT val                 { $$ = makeNode(LT, 0, $1, $3, null, null); }
        | val NEQ val                { $$ = makeNode(NEQ, 0, $1, $3, null, null); }
;

val:      NUM                        { $$ = makeNode(NUM, $1, null, null, null, null); }
        | var
;

var:      VAR                        { $$ = makeNode(VAR, (int)$1, null, null, null, null); }
;

%%

int main (){
  yyparse ();
}

void yyerror (const char* s) {
  printf ("%s\n", s);
}

long makeNode(int token, int val, long p1, long p2, long p3, long p4) {
    node* myNode;
    myNode = (node *) malloc(sizeof(node));
    if (!myNode) {
        systemError("makeNode: Memory allocation failed");
    }
    myNode->token = token;
    myNode->val = val;
    myNode->ptr1 = (node*)p1;
    myNode->ptr2 = (node*)p2;
    myNode->ptr3 = (node*)p3;
    myNode->ptr4 = (node*)p4;
    return (long)myNode;
}
int getVar(int id) {
    return vars[id - 'a'];
}

void storeVar(int id, int val) {
    vars[id - 'a'] = val;
}
void runStmt(long ptr) {
    computeStmt((node*)ptr);
    cleanUp((node*)ptr);
}

void computeStmt(node* tree) {
    if (!tree) {
        systemError("computeStmt: Null tree node");
    }
    int val;
    switch (tree->token) {
        case BROPRINT:
            if (!tree->ptr1) {
                systemError("computeStmt: Null ptr1 in BROPRINT");
            }
            val = evalExpr(tree->ptr1);
            printf("%d\n", val);
            break;
        case BROGIVE:
            if (!tree->ptr1) {
                systemError("computeStmt: Null ptr1 in BROGIVE");
            }
            storeVar(tree->ptr1->val, 0);
            break;
        case ASSIGN:
            if (!tree->ptr1 || !tree->ptr2) {
                systemError("computeStmt: Null pointer in ASSIGN");
            }
            int variable_id = tree->ptr1->val;
            int expr_value = evalExpr(tree->ptr2);
            storeVar(variable_id, expr_value);
            break;
        case BROSWITCH:
            if (!tree->ptr1) {
                systemError("computeStmt: Null pointer in BROSWITCH");
            }
            computeStmt(tree->ptr1);
            break;
        case BROCASE:
            if (!tree->ptr1 || !tree->ptr2) {
                systemError("computeStmt: Null pointer in BROCASE");
            }
            if (evalExpr(tree->ptr1)) {
                computeStmt(tree->ptr2);
            }
            break;
        case BROLOOP:
            if (!tree->ptr1 || !tree->ptr2) {
                systemError("computeStmt: Null pointer in BROLOOP");
            }
            while (evalExpr(tree->ptr1)) {
                computeStmt(tree->ptr2);
            }
            break;
        case ENDBRO:
            return;
        case LBRACE:
            computeStmt(tree->ptr1);
            break;
        default:
            systemError("computeStmt: Unknown token");
    }
}

int evalExpr(node* tree) {
    if (!tree) {
        printf("evalExpr: Null tree node\n");
        exit(1);
    }

    switch (tree->token) {
        case PLUS:
            return evalExpr(tree->ptr1) + evalExpr(tree->ptr2);
        case MINUS:
            return evalExpr(tree->ptr1) - evalExpr(tree->ptr2);
        case MULT:
            return evalExpr(tree->ptr1) * evalExpr(tree->ptr2);
        case DIV:
            return evalExpr(tree->ptr1) / evalExpr(tree->ptr2);
        case VAR:
            return getVar(tree->val);
        case NUM:
            return tree->val;
        case NEGATIVE:
            return -evalExpr(tree->ptr1);
        case STRING:
            printf("%s\n", tree->val);
        case EQ:
            return evalExpr(tree->ptr1) == evalExpr(tree->ptr2);
        case GT:
            return evalExpr(tree->ptr1) > evalExpr(tree->ptr2);
        case LT:
            return evalExpr(tree->ptr1) < evalExpr(tree->ptr2);
        case NEQ:
            return evalExpr(tree->ptr1) != evalExpr(tree->ptr2);
        default:
            printf("evalExpr: Unknown token %d\n", tree->token);
            exit(1);
    }
    return 0;
}



void cleanUp(node* tree) {
    if (!tree) return;
    if (tree->ptr1 != NULL) cleanUp(tree->ptr1);
    if (tree->ptr2 != NULL) cleanUp(tree->ptr2);
    if (tree->ptr3 != NULL) cleanUp(tree->ptr3);
    if (tree->ptr4 != NULL) cleanUp(tree->ptr4);
    free(tree);
}

void systemError(const char* str) {
    printf("ERROR: in \"%s\", something went wrong.\n", str);
    exit(-1);
}


