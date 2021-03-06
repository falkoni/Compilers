%{
	#include <stdio.h>

	int a = 1;
%}

%union{
	int value;
	char *id;
	is_program* 	ip;
	is_dec_meth* 	idm;
	is_fieldDec* 	ifd;
	is_methDec* 	imd;
	is_repValDec* 	irvd;
	is_repStmt* 	irstm;
	is_formPar* 	ifp;
	is_commaTId* 	icti;
	is_varDec* 		ivd;
	is_commaId* 	ici;
	is_type* 		it;
	is_statement* 	istm;
	is_expression* 	iexpr;
	is_args*		ia;
	is_commaExpr*	icexpr;
}
%token<value>NUMBER
%type<ip>Program
%type<idm>DeclMethodField
%type<ifd>FieldDecl
%type<imd>MethodDecl
%type<irvd>RepVarDecl
%type<irstm>RepStatement
%type<ifp>FormalParams
%type<icti>CommaTypeID
%type<ivd>VarDecl
%type<ici>CommaId
%type<it>Type
%type<istm>Statement
%type<iexpr>Expr
%type<ia>Args
%type<icexpr>CommaExpr

%right  Assign
%left   OP1
%left   OP2
%left   OP3
%left   OP4
%right ASSIGN
%left OR
%left AND
%left EQUALITY
%left RELATIONAL
%left OP3
%left OP4
%right NEW
%right NOT	
%left OCURV CCURV OSQUARE CSQUARE

%%


Start : 	Program					{;}
      ;


Program :	CLASS ID OBRACE  CBRACE			{$$ = node($2);} 
	;


DeclMethodField :	FieldDecl DeclMethodField	{;}
		|	MethodDecl DeclMethodField	{;}
		|					{;}
		;


FieldDecl : 	STATIC VarDecl				{;}
	  ;


MethodDecl :	PUBLIC STATIC Type ID OCURV FormalParams CCURV OBRACE RepVarDecl RepStatement CBRACE			{;}
	   |	PUBLIC STATIC Type ID OCURV CCURV OBRACE RepVarDecl RepStatement CBRACE				{;}
	   |	PUBLIC STATIC VOID ID OCURV FormalParams CCURV OBRACE RepVarDecl RepStatement CBRACE			{;}
	   |	PUBLIC STATIC VOID ID OCURV CCURV OBRACE RepVarDecl RepStatement CBRACE				{;}
	   ;


RepVarDecl :	VarDecl	RepVarDecl			{;}
	   |						{;}
	   ;


RepStatement :	Statement RepStatement			{;}
	     |						{;}
	     ;


FormalParams :	Type ID CommaTypeID			{;}
	     |	STRING OSQUARE CSQUARE ID		{;}
	     ;


CommaTypeID :	COMMA Type ID CommaTypeID		{;}
	    |						{;}
	    ;


VarDecl :	Type ID CommaId SEMIC			{;}
	;


CommaId :	COMMA ID CommaId			{;}
	|						{;}
	;

Type :		INT		{;}
     |		BOOL		{;}
     |		INT OSQUARE CSQUARE		{;}
     |		BOOL OSQUARE CSQUARE		{;}
     ;


Statement :	OBRACE	RepStatement CBRACE		{;}
	  |	IF OCURV Expr CCURV Statement		{;}
	  |	IF OCURV Expr CCURV Statement ELSE Statement		{;}
	  |	WHILE OCURV Expr CCURV Statement	{;}
	  |	PRINT OCURV Expr CCURV SEMIC		{;}
	  |	ID ASSIGN Expr SEMIC			{;}
	  |	ID OSQUARE Expr CSQUARE ASSIGN Expr SEMIC			{;}
	  |	RETURN SEMIC				{;}
	  |	RETURN Expr SEMIC				{;}
	  ;

Expr :		Expr AND Expr			{;}
     |		Expr OR Expr			{;}
     |		Expr RELATIONAL Expr		{;}
     |		Expr EQUALITY Expr		{;}
     |		Expr OP3 Expr			{;}
     |		Expr OP4 Expr			{;}
     |		Expr OSQUARE Expr CSQUARE	{;}
     |		ID				{;}
     |		INTLIT				{;}
     |		BOOLLIT				{;}
     |		NEW INT OSQUARE Expr CSQUARE	{;}
     |		NEW BOOL OSQUARE Expr CSQUARE	{;}
     |		OCURV Expr CCURV		{;}
     |		Expr DOTLENGTH			{;}
     |		OP3 Expr			{;}
     |		NOT Expr			{;}
     |		PARSEINT OCURV ID OSQUARE Expr CSQUARE CCURV	{;}
     |		ID OCURV CCURV			{;}
     | 		ID OCURV Args CCURV		{;}
     ;

Args :		Expr CommaExpr			{;}
     ;

CommaExpr :	COMMA Expr CommaExpr		{;}
	  |					{;}
	  ;	

%%
int main(){
	yyparse();
}




void yyerror(char *s) {
    fprintf(stdout, "%s\n", s);
}
