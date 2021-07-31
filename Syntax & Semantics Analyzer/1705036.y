%{

#include<bits/stdc++.h>
#include "1705036_symbolTable.cpp"


using namespace std;
//#define YYSTYPE SymbolInfo*
ofstream logfile("log.txt");
ofstream errorfile("error.txt");


int yyparse(void);
int yylex(void);
extern FILE *yyin;
extern int line_count;
extern int error_count;

SymbolTable *table = new SymbolTable(30);
vector <SymbolInfo*> tem_params;
bool params_insert = false;


void yyerror(char *s)
{
	//write your code
	errorfile << "Error at line " << line_count << ": Syntax Error " << endl << endl;
	logfile << "Error at line " << line_count << ": Syntax Error " << endl << endl;
	error_count++;
}





%}

%union{
	SymbolInfo* si;
	vector <SymbolInfo*> *symvec; 


}

%token <si> ID CONST_INT CONST_FLOAT MULOP ADDOP RELOP LOGICOP IF FOR WHILE INT FLOAT VOID RETURN ASSIGNOP NOT 
LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA SEMICOLON PRINTLN INCOP DECOP
/*
%left 
%right
*/
%nonassoc <si> LOWER_THAN_ELSE
%nonassoc <si> ELSE


%type <si> type_specifier
%type <symvec> declaration_list var_declaration unit program variable factor expression argument_list arguments unary_expression term 
simple_expression rel_expression logic_expression expression_statement statement statements compound_statement parameter_list start
func_declaration func_definition

%%

start : program
	{
		//write your code in this block in all the similar blocks below
		logfile << "Line " << line_count << ":  start : program"<< endl << endl;
		$$ = new vector <SymbolInfo*>();

		for(int i = 0; i< $1->size(); i++){
				logfile << $1->at(i)->getName();
				$$->push_back($1->at(i));
			}
			logfile << endl << endl;
			table->PrintAll();	
			logfile << "Total lines : " << line_count << endl << endl;
			logfile << "Total errors : " << error_count << endl << endl;
			errorfile << "Total errors : " << error_count << endl << endl;
	}
	;

program : program unit 
	{
		logfile << "Line " << line_count << ":  program : program unit"<< endl << endl; 
		$$ = new vector <SymbolInfo*>();

		for(int i = 0; i< $1->size(); i++){
				logfile << $1->at(i)->getName();
				$$->push_back($1->at(i));
			}

		for(int i = 0; i< $2->size(); i++){
				logfile << $2->at(i)->getName();
				$$->push_back($2->at(i));
			}

			logfile << endl << endl;

	}
	| unit
	{
		logfile << "Line " << line_count << ":  program : unit"<< endl << endl;
			$$ = new vector <SymbolInfo*>();
			
			for(int i = 0; i< $1->size(); i++){
				$$->push_back($1->at(i));
				logfile << $1->at(i)->getName();
			}

			logfile << endl << endl;
	}
	;
	
unit : var_declaration 
	{
		logfile << "Line " << line_count << ":  unit : var_declaration" << endl << endl; 
		$$ = new vector <SymbolInfo*>();
			//TYPE SPECIFIER PRINT
		for(int i = 0; i< $1->size(); i++){
			$$->push_back($1->at(i));
			logfile << $1->at(i)->getName();
		}

		logfile << endl << endl;


	}

	| func_declaration
	{
		$$ = new vector <SymbolInfo*>();
		logfile << "Line " << line_count << ":  unit : func_declaration"<< endl << endl;
	
		
		for(int i = 0; i< $1->size(); i++){
			$$->push_back($1->at(i));
			logfile << $1->at(i)->getName();
		}

		logfile << endl << endl;
	}
	| func_definition
	{
		logfile << "Line " << line_count << ":  unit : func_definition"<< endl << endl;
		$$ = new vector <SymbolInfo*>();
		
		for(int i = 0; i< $1->size(); i++){
			$$->push_back($1->at(i));
			logfile << $1->at(i)->getName();
		}

		logfile << endl << endl;
	}
	;
     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON
		{	
			if(table->getCurrentScope()->scope_lookup($2->getName()) != nullptr){
				errorfile << "Error at line " << line_count << ": Multiple declaration of " << $2->getName() << endl << endl;
				logfile << "Error at line " << line_count << ": Multiple declaration of " << $2->getName() << endl << endl;
				error_count++;
			}

			logfile << "Line " << line_count << ":  func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON"<< endl << endl;
			$$ = new vector <SymbolInfo*>();

			///Insert in SYMBOLTABLE
			SymbolInfo* sinf = new SymbolInfo($2->getName(), $2->getType(), $1->getName(), false, true);
			
			
			$$->push_back($1);
			$$->push_back($2);
			$$->push_back($3);
			logfile << $1->getName() << $2->getName() << $3->getName();

			for(int i = 0; i< $4->size(); i++){
				logfile << $4->at(i)->getName();
				$$->push_back($4->at(i));

				///Insert params in table sinf
				sinf->addParam($4->at(i));


			}

			$$->push_back($5);
			logfile << $5->getName();

			$6->setName($6->getName() + "\n");
			$$->push_back($6);



			logfile << $6->getName() << endl << endl;
			table->symbol_insert(sinf);

			//logfile << "Param count: " << sinf->getParamCount() << endl << endl;
			//logfile << "Return Type: " << sinf->getReturnType() << endl << endl;


		}
		| type_specifier ID LPAREN RPAREN SEMICOLON
		{

			if(table->getCurrentScope()->scope_lookup($2->getName()) != nullptr){
				errorfile << "Error at line " << line_count << ": Multiple declaration of " << $2->getName() << endl << endl;
				logfile << "Error at line " << line_count << ": Multiple declaration of " << $2->getName() << endl << endl;
				error_count++;
			}


			logfile << "Line " << line_count << ":  func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON"<< endl << endl;
			$$ = new vector <SymbolInfo*>();
			
			$$->push_back($1);
			$$->push_back($2);
			$$->push_back($3);
			$$->push_back($4);

			$5->setName($5->getName() + "\n");
			$$->push_back($5);



			logfile << $1->getName() << $2->getName() << $3->getName() << $4->getName() << $5->getName() << endl << endl;


			///symboltable
			SymbolInfo* sinf = new SymbolInfo($2->getName(), $2->getType(), $1->getName(), false, true);
			table->symbol_insert(sinf);
		}
		;
		 
func_definition : type_specifier ID LPAREN parameter_list RPAREN 
	{	
		if(table->getCurrentScope()->scope_lookup($2->getName()) != nullptr){

			SymbolInfo* temp = table->getCurrentScope()->scope_lookup($2->getName());
			
			if(!temp->isFunc()){
				errorfile << "Error at line " << line_count << ": Multiple declaration of " << $2->getName() << endl << endl;
				logfile << "Error at line " << line_count << ": Multiple declaration of " << $2->getName() << endl << endl;
				error_count++;
			}
			
			else if(temp->isFunc() && temp->getDefined()){
				errorfile << "Error at line " << line_count << ": Multiple declaration of " << $2->getName() << endl << endl;
				logfile << "Error at line " << line_count << ": Multiple declaration of " << $2->getName() << endl << endl;
				error_count++;
			}

			else if(temp->isFunc() && !temp->getDefined()){
				//logfile << "FUNCTION WAS DECLARED EARLIER\n\n";
				temp->setDefined();
				//check type_specifier
				if(temp->getReturnType() != $1->getName()){
					errorfile << "Error at line " << line_count << ": Return type mismatch with function declaration in function " << $2->getName() << endl << endl;
					logfile << "Error at line " << line_count << ": Return type mismatch with function declaration in function " << $2->getName() << endl << endl;
					error_count++;
				}

				//check param_list
				vector <SymbolInfo*> oldParam = temp->getParamList();
				if($4->size() == oldParam.size()){
					for(int i = 0; i< oldParam.size(); i++)
					{
						if((oldParam.at(i)->getName() != $4->at(i)->getName())){
							errorfile << "Error at line " << line_count << ": Arguments mismatch with declaration in function " << $2->getName() << endl << endl;
							logfile << "Error at line " << line_count << ": Arguments mismatch with declaration in function " << $2->getName() << endl << endl;
							error_count++;	
						}
					}
				}
				else{
					errorfile << "Error at line " << line_count << ": Total number of arguments mismatch with declaration in function " << $2->getName() << endl << endl;
					logfile << "Error at line " << line_count << ": Total number of arguments mismatch with declaration in function " << $2->getName() << endl << endl;
					error_count++;	

				}




			}
		}

		else{//FUNCTION WAS NOT DECLARED BEFORE
			SymbolInfo* sinf = new SymbolInfo($2->getName(), $2->getType(), $1->getName(), false, true);
			sinf->setDefined();
			for(int i = 0; i< $4->size(); i++){
				sinf->addParam($4->at(i));
			}
			table->symbol_insert(sinf);
			//logfile << "Parameters Count: " << sinf->getParamCount() << endl << endl;
			//logfile << "Return Type : " << sinf->getReturnType() << endl << endl;
		}
		for(int i = 0; i< $4->size(); i++){
			if($4->at(i)->getType() == "ID"){
					//cout << $4->at(i)->getName() << " : " <<  $4->at(i)->getType() << endl;
					SymbolInfo* sinf = new SymbolInfo($4->at(i)->getName(), $4->at(i)->getType(), $4->at(i)->getReturnType());
					
					tem_params.push_back(sinf);
				}
		}
		
		params_insert = true;
		
		/*table->EnterScope();
		for(int i = 0; i< $4->size(); i++){
			//cout << $4->at(i)->getName() << " : " <<  $4->at(i)->getType() << endl;
				if($4->at(i)->getType() == "ID"){
					//cout << $4->at(i)->getName() << " : " <<  $4->at(i)->getType() << endl;
					SymbolInfo* sinf = new SymbolInfo($4->at(i)->getName(), $4->at(i)->getType(), $4->at(i)->getReturnType());
					
					table->symbol_insert(sinf);
				}
			}*/

		//logfile << "DUMMY STATE AFTER RPAREN"<< endl << endl;
	}
	compound_statement
		{	

			//Exit scope
				//logfile << "PRINTED" << endl;
				/*table->PrintAll();
				
				table->ExitScope();*/
				//logfile << "SCOPE THEKE BER?"<< endl << endl;
			

			logfile << "Line " << line_count << ":  func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement" << endl << endl;
			$$ = new vector <SymbolInfo*>();
			
			$$->push_back($1);
			$$->push_back($2);
			$$->push_back($3);
			logfile << $1->getName() << $2->getName() << $3->getName();

			for(int i = 0; i< $4->size(); i++){
				logfile << $4->at(i)->getName();
				$$->push_back($4->at(i));
			}
			$$->push_back($5);
			logfile << $5->getName();

			for(int i = 0; i< $7->size(); i++){
				logfile << $7->at(i)->getName();
				$$->push_back($7->at(i));
			}

			logfile << endl << endl;





		}
		| type_specifier ID LPAREN RPAREN 
		{	
			if(table->getCurrentScope()->scope_lookup($2->getName()) != nullptr){

				SymbolInfo* temp = table->getCurrentScope()->scope_lookup($2->getName());
				if(!temp->isFunc()){
					errorfile << "Error at line " << line_count << ": Multiple declaration of " << $2->getName() << endl << endl;
					logfile << "Error at line " << line_count << ": Multiple declaration of " << $2->getName() << endl << endl;
					error_count++;
				}

				else{
					//logfile << "FUNCTION WAS DECLARED EARLIER\n\n";

					//check type_specifier
					if(temp->getReturnType() != $1->getName()){
						errorfile << "Error at line " << line_count << ": Return type mismatch with function declaration in function " << $2->getName() << endl << endl;
						logfile << "Error at line " << line_count << ": Return type mismatch with function declaration in function " << $2->getName() << endl << endl;
						error_count++;
					}


				}
		    }

		else{//FUNCTION WAS NOT DECLARED BEFORE
			SymbolInfo* sinf = new SymbolInfo($2->getName(), $2->getType(), $1->getName(), false, true);
			sinf->setDefined();
			table->symbol_insert(sinf);
			//logfile << "Parameters Count: " << sinf->getParamCount() << endl << endl;
			//logfile << "Return Type : " << sinf->getReturnType() << endl << endl;
		}
			//table->EnterScope();
			//logfile << "DUMMY STATE AFTER RPAREN"<< endl << endl;
		}
		 compound_statement
		{	
			
				/*table->PrintAll();
				table->ExitScope();*/
				//logfile << "current scope id: " << table->getCurrentScope()->getid() << endl;
				//logfile << "SCOPE THEKE BER?"<< endl << endl;
			



			logfile << "Line " << line_count << ":  func_definition : type_specifier ID LPAREN RPAREN compound_statement"<< endl << endl;
			$$ = new vector <SymbolInfo*>();
			
			$$->push_back($1);
			$$->push_back($2);
			$$->push_back($3);
			$$->push_back($4);

			logfile << $1->getName() << $2->getName() << $3->getName() << $4->getName();

			for(int i = 0; i< $6->size(); i++){
				logfile << $6->at(i)->getName();
				$$->push_back($6->at(i));
			}
			logfile << endl << endl;

		}
 		;				


parameter_list  : parameter_list COMMA type_specifier ID
		{
			for(int i = $1->size() - 1; i>0; i--){
				if($1->at(i)->getType() == "ID")
				{
					if($1->at(i)->getName() == $4->getName()){
						errorfile << "Error at line " <<  line_count << ": Multiple declaration of " <<  $4->getName() << " in parameter" << endl << endl;
						logfile << "Error at line " <<  line_count << ": Multiple declaration of " <<  $4->getName() << " in parameter" << endl << endl;
						error_count++;
						break;
					}
				}
			}

			logfile << "Line " << line_count << ":  parameter_list  : parameter_list COMMA type_specifier ID"<< endl << endl;
			$$ = new vector <SymbolInfo*>();
			
			for(int i = 0; i< $1->size(); i++){
				logfile << $1->at(i)->getName();
				$$->push_back($1->at(i));
			}

			$$->push_back($2);
			$$->push_back($3);
			$4->setReturnType($3->getName());
			$$->push_back($4);
			logfile << $2->getName() << $3->getName() << $4->getName() << endl << endl;

			
		}
		| parameter_list COMMA type_specifier
		{
			logfile << "Line " << line_count << ":  parameter_list  : parameter_list COMMA type_specifier"<< endl << endl;
			$$ = new vector <SymbolInfo*>();
			
			for(int i = 0; i< $1->size(); i++){
				logfile << $1->at(i)->getName();
				$$->push_back($1->at(i));
			}

			$$->push_back($2);
			logfile << $2->getName();

			$$->push_back($3);
			logfile << $3->getName() << endl << endl;

		}
 		| type_specifier ID
		{
			logfile << "Line " << line_count << ":  parameter_list  : type_specifier ID"<< endl << endl;
			$$ = new vector <SymbolInfo*>();
			$$->push_back($1);
			$2->setReturnType($1->getName());
			$$->push_back($2);
			
			logfile << $1->getName() << $2->getName() << endl << endl;
			//logfile << "Type: " << $2->getReturnType() << endl;
		
		}
		| type_specifier
		{	
			logfile << "Line " << line_count << ":  parameter_list  : type_specifier"<< endl << endl;
			$$ = new vector <SymbolInfo*>();
			$$->push_back($1);
			logfile << $1->getName() << endl << endl;
		}
 		;

 		
compound_statement : LCURL
			{
				//DUMMY STATE
				table->EnterScope();
				if(params_insert){
					for(int i = 0; i<tem_params.size(); i++){
						table->symbol_insert(tem_params.at(i));
					}
					tem_params.clear();
					params_insert = false;
				}

			} statements RCURL
			{
				logfile << "Line " << line_count << ":  compound_statement : LCURL statements RCURL"<< endl << endl;
				$$ = new vector <SymbolInfo*>();
				$1->setName($1->getName() + "\n");
				$4->setName($4->getName() + "\n");
				$$->push_back($1);
				logfile << $1->getName();

				for(int i = 0; i< $3->size();i++){
					$$->push_back($3->at(i));
					logfile << $3->at(i)->getName();
				}


				$$->push_back($4);
				logfile << $4->getName() << endl << endl;
				table->PrintAll();
				table->ExitScope();
			}
 		    | LCURL{
				 table->EnterScope();
				if(params_insert){
					for(int i = 0; i<tem_params.size(); i++){
						table->symbol_insert(tem_params.at(i));
					}
					tem_params.clear();
					params_insert = false;
				}

			 } RCURL
			{
				logfile << "Line " << line_count << ":  compound_statement : LCURL RCURL"<< endl << endl;
				$$ = new vector <SymbolInfo*>();
				$1->setName($1->getName() + "\n");
				$3->setName($3->getName() + "\n");

				$$->push_back($1);
				$$->push_back($3);

				logfile << $1->getName() << $3->getName() << endl << endl;
				table->PrintAll();
				table->ExitScope();
			}
			;
 		    
var_declaration : type_specifier declaration_list SEMICOLON
		{ 	

			//VARIABLE TYPE CANNOT BE VOID
			
			if($1->getName() == "void "){
				errorfile << "Error at line " <<  line_count << ": Variable type cannot be void "  << endl << endl;
				logfile << "Error at line " <<  line_count << ": Variable type cannot be void " << endl << endl;
				error_count++;
			}

			logfile << "Line " << line_count << ":  var_declaration : type_specifier declaration_list SEMICOLON" << endl << endl; 
			$$ = new vector <SymbolInfo*>();
			$$->push_back($1);
			logfile << $1->getName();
			
			for(int i = 0; i< $2->size();i++){
				if($2->at(i)->getReturnType() == "error"){
					//logfile << "Error in " << $2->at(i)->getName() << endl;
				}


				//ENTER IN SYMBOLTABLE
				//logfile << "return type in var_dec: " <<  $2->at(i)->getReturnType() << endl;
				if(($2->at(i)->getType() == "ID") && ($2->at(i)->getReturnType() != "error") && ($1->getName() != "void "))
				{	
					//logfile << "Inserting in table: " << $2->at(i)->getName() << endl;
					SymbolInfo* sinf = new SymbolInfo($2->at(i)->getName(), $2->at(i)->getType(), $1->getName());
					//$2->at(i)->setReturnType($1->getName());
					if($2->at(i)->isArray()){
						sinf->setArray();
					}
					bool ins = table->symbol_insert(sinf);
					
				}


				$$->push_back($2->at(i));
				logfile << $2->at(i)->getName();
					/*if($2->at(i)->isArray()){
						logfile << " (array) ";
					}*/
			}

			$3->setName($3->getName() + "\n"); //new line after SEMICOLON		 
			$$->push_back($3);
			logfile << $3->getName() << endl << endl;

		 	
			//table->PrintCurr();

		
				
		}
 		;
 		 
type_specifier	: INT { logfile << "Line " << line_count << ":  type specifier : INT"<< endl << endl << $1->getName() << endl << endl;
			$1->setName($1->getName() + " ");
			$$ = new SymbolInfo($1->getName(), $1->getType());
			//$$ = $1;		
			}
 		| FLOAT{ logfile << "Line " << line_count << ":  type specifier : FLOAT"<< endl << endl << $1->getName() << endl << endl;
			$1->setName($1->getName() + " ");
			
			$$ = new SymbolInfo($1->getName(), $1->getType());	
			}
 		| VOID{ logfile << "Line " << line_count << ":  type specifier : VOID"<< endl << endl<< $1->getName() << endl << endl;
			$1->setName($1->getName() + " ");
			
			$$ = new SymbolInfo($1->getName(), $1->getType());		
			}
 		;
 		
declaration_list : declaration_list COMMA ID {

			for(int i = $1->size() - 1; i>=0; i--){
				if($1->at(i)->getType() == "ID")
				{
					if($1->at(i)->getName() == $3->getName()){
						errorfile << "Error at line " <<  line_count << ": Multiple declaration of " <<  $3->getName()  << endl << endl;
						logfile << "Error at line " <<  line_count << ": Multiple declaration of " <<  $3->getName()  << endl << endl;
						$3->setReturnType("error");
						error_count++;
						break;
					}
				}
			}

	
			if(table->getCurrentScope()->scope_lookup($3->getName()) != nullptr){
				   errorfile << "Error at line " << line_count << ": Multiple declaration of " << $3->getName() << endl << endl;
				   logfile << "Error at line " << line_count << ": Multiple declaration of " << $3->getName() << endl << endl;
				   $3->setReturnType("error");
				   error_count++;
			}  


			logfile << "Line " << line_count << ":  declaration_list : declaration_list COMMA ID" << endl << endl; 
			$$ = new vector <SymbolInfo*>();
			for(int i = 0; i< $1->size();i++){
			     $$->push_back($1->at(i));
			     logfile << $1->at(i)->getName();
		 	}
		 	
		 	$$->push_back($2);
			$$->push_back($3);
 		  	logfile <<$2->getName() << $3->getName() << endl << endl;
			

		  }
 		  | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
 		  
 		  {

			for(int i = $1->size() - 1; i>=0; i--){
				if($1->at(i)->getType() == "ID")
				{
					if($1->at(i)->getName() == $3->getName()){
						errorfile << "Error at line " <<  line_count << ": Multiple declaration of " <<  $3->getName()  << endl << endl;
						logfile << "Error at line " <<  line_count << ": Multiple declaration of " <<  $3->getName()  << endl << endl;
						$3->setReturnType("error");
						error_count++;
						break;
					}
				}
			}   	


			if(table->getCurrentScope()->scope_lookup($3->getName()) != nullptr){
				   errorfile << "Error at line " << line_count << ": Multiple declaration of " << $3->getName() << endl << endl;
				   logfile << "Error at line " << line_count << ": Multiple declaration of " << $3->getName() << endl << endl;
				   $3->setReturnType("error");
				   error_count++;
			}   


 		  	logfile << "Line " << line_count << ":  declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD" << endl << endl; 
 		  	$$ = new vector <SymbolInfo*>();
			for(int i = 0; i< $1->size();i++){
			     $$->push_back($1->at(i));
			     logfile << $1->at(i)->getName();
		 	}
		 	
		 	$$->push_back($2);
			$3->setArray();

			$$->push_back($3);
			$$->push_back($4);
			$$->push_back($5);
			$$->push_back($6);
 		  	logfile <<$2->getName() << $3->getName() << $4->getName() << $5->getName() << $6->getName() << endl << endl;
		 	
 		  }
 		  | ID { 

			   if(table->getCurrentScope()->scope_lookup($1->getName()) != nullptr){
				   errorfile << "Error at line " << line_count << ": Multiple declaration of " << $1->getName() << endl << endl;
				   logfile << "Error at line " << line_count << ": Multiple declaration of " << $1->getName() << endl << endl;
				   //logfile << "Ret type; " << $1->getReturnType() << endl;
				   $1->setReturnType("error");
				   error_count++;
			   }
		
			   logfile << "Line " << line_count << ":  declaration_list : ID " << endl << endl; 
 		  		$$ = new vector <SymbolInfo*>();
 		  		$$->push_back($1);
 		  		logfile << $1->getName() << endl << endl;
				
 		  	}
 		  	
 		  | ID LTHIRD CONST_INT RTHIRD
 		  	{ 	
				if(table->getCurrentScope()->scope_lookup($1->getName()) != nullptr){
				   errorfile << "Error at line " << line_count << ": Multiple declaration of " << $1->getName() << endl << endl;
				   logfile << "Error at line " << line_count << ": Multiple declaration of " << $1->getName() << endl << endl;
				   $1->setReturnType("error");
				   error_count++;
			    }   


				logfile << "Line " << line_count << ":  declaration_list : ID LTHIRD CONST_INT RTHIRD" << endl << endl; 
				$$ = new vector <SymbolInfo*>();
				$1->setArray();

				$$->push_back($1);
				$$->push_back($2);
				$$->push_back($3);
				$$->push_back($4);
				logfile << $1->getName() << $2->getName() << $3->getName() << $4->getName() << endl << endl;
				
 		  	}

 		  ;
 		  
statements : statement
		{
			logfile << "Line " << line_count << ":  statements : statement"<< endl << endl;
			
			$$ = new vector <SymbolInfo*>();
			for(int i = 0; i< $1->size(); i++){
				$$->push_back($1->at(i));

				logfile << $1->at(i)->getName();
			}

			logfile << endl << endl;


		}
	   | statements statement
	   {
		   logfile << "Line " << line_count << ":  statements : statements statement"<< endl << endl;
			$$ = new vector <SymbolInfo*>();
			
			for(int i = 0; i< $1->size(); i++){
				$$->push_back($1->at(i));
				logfile << $1->at(i)->getName();
			}

			for(int i = 0; i< $2->size(); i++){
				$$->push_back($2->at(i));
				logfile << $2->at(i)->getName();
			}

			logfile << endl << endl;



	   }
	   ;
	   
statement : var_declaration
		{
			logfile << "Line " << line_count << ":  statement : var_declaration"<< endl << endl;
			
			$$ =  new vector<SymbolInfo*>();
			for(int i = 0; i< $1->size(); i++){
				$$->push_back($1->at(i));
				logfile << $1->at(i)->getName();
			}

			logfile << endl << endl;


		}
		| expression_statement

		{
			logfile << "Line " << line_count << ":  statement : expression_statement"<< endl << endl;
			$$ =  new vector<SymbolInfo*>();
			
			for(int i = 0; i< $1->size(); i++){
				$$->push_back($1->at(i));
				logfile << $1->at(i)->getName();
			}

			logfile << endl << endl;

		}
		| compound_statement
		{
			logfile << "Line " << line_count << ":  statement : compound_statement"<< endl << endl;
			$$ =  new vector<SymbolInfo*>();
			
		
			
			for(int i = 0; i< $1->size(); i++){
				$$->push_back($1->at(i));
				logfile << $1->at(i)->getName();
			}

			logfile << endl << endl;

		}
		| FOR LPAREN expression_statement expression_statement expression RPAREN statement
		{
			logfile << "Line " << line_count << ":  statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement"<< endl << endl;
			$$ =  new vector<SymbolInfo*>();
			$$->push_back($1);
			$$->push_back($2);
			logfile << $1->getName() << $2->getName();
			//expression_statement
			for(int i = 0; i< $3->size(); i++){
				if($3->at(i)->getType() == "SEMICOLON"){
					$3->at(i)->setName(";");
				}
				$$->push_back($3->at(i));
				logfile << $3->at(i)->getName();
			
			}
			//expression_statement
			for(int i = 0; i< $4->size(); i++){
				if($4->at(i)->getType() == "SEMICOLON"){
					$4->at(i)->setName(";");
				}
				$$->push_back($4->at(i));
				logfile << $4->at(i)->getName();
			
			}
			//expression
			for(int i = 0; i< $5->size(); i++){
				$$->push_back($5->at(i));
				logfile << $5->at(i)->getName();
			
			}

			$$->push_back($6);
			logfile << $6->getName();

			//statement
			for(int i = 0; i< $7->size(); i++){
				$$->push_back($7->at(i));
				logfile << $7->at(i)->getName();
			
			}

			logfile << endl << endl;


		}
		| IF LPAREN expression RPAREN statement	%prec LOWER_THAN_ELSE
		{
			logfile << "Line " << line_count << ":  statement: IF LPAREN expression RPAREN statement"<< endl << endl;
			$$ =  new vector<SymbolInfo*>();
			$$->push_back($1);
			$$->push_back($2);
			logfile << $1->getName() << $2->getName();
			
			//expression
			for(int i = 0; i< $3->size(); i++){
				$$->push_back($3->at(i));
				logfile << $3->at(i)->getName();
			
			}
			$$->push_back($4);
			logfile << $4->getName();
			//statement
			for(int i = 0; i< $5->size(); i++){
				$$->push_back($5->at(i));
				logfile << $5->at(i)->getName();
			
			}

			logfile << endl << endl;

		}
		| IF LPAREN expression RPAREN statement ELSE statement

		{
			logfile << "Line " << line_count << ":  statement: IF LPAREN expression RPAREN statement ELSE statement"<< endl << endl;
			$$ =  new vector<SymbolInfo*>();
			$$->push_back($1);
			$$->push_back($2);
			logfile << $1->getName() << $2->getName();
			
			//expression
			for(int i = 0; i< $3->size(); i++){
				$$->push_back($3->at(i));
				logfile << $3->at(i)->getName();
			
			}
			$$->push_back($4);
			logfile << $4->getName();
			//statement
			for(int i = 0; i< $5->size(); i++){
				$$->push_back($5->at(i));
				logfile << $5->at(i)->getName();
			
			}
			$6->setName($6->getName() + "\n");
			$$->push_back($6);
			logfile << $6->getName();

			for(int i = 0; i< $7->size(); i++){
				$$->push_back($7->at(i));
				logfile << $7->at(i)->getName();
			
			}

			logfile << endl << endl;

		}
		| WHILE LPAREN expression RPAREN statement
		{
			logfile << "Line " << line_count << ":  statement: WHILE LPAREN expression RPAREN statement"<< endl << endl;
			$$ =  new vector<SymbolInfo*>();
			$$->push_back($1);
			$$->push_back($2);
			logfile << $1->getName() << $2->getName();
			//expression
			for(int i = 0; i< $3->size(); i++){
				$$->push_back($3->at(i));
				logfile << $3->at(i)->getName();
			
			}
			$$->push_back($4);
			logfile << $4->getName();
			//statement
			for(int i = 0; i< $5->size(); i++){
				$$->push_back($5->at(i));
				logfile << $5->at(i)->getName();
			
			}

			logfile << endl << endl;




		}

		| PRINTLN LPAREN ID RPAREN SEMICOLON
		{
			logfile << "Line " << line_count << ":  statement: PRINTLN LPAREN ID RPAREN SEMICOLON"<< endl << endl;

			if(table->symbol_lookup($3->getName()) == nullptr){

				errorfile << "Error at line " << line_count << ": Undeclared variable " << $3->getName() << endl << endl;
				logfile << "Error at line " << line_count << ": Undeclared variable " << $3->getName() << endl << endl;
				error_count++;
				$3->setReturnType("error");

			}


			$$ =  new vector<SymbolInfo*>();
			$$->push_back($1);
			$$->push_back($2);
			$$->push_back($3);
			$$->push_back($4);
			
			$5->setName($5->getName() + "\n"); //new line after SEMICOLON	
			$$->push_back($5);

			logfile << $1->getName() << $2->getName() << $3->getName() << $4->getName() << $5->getName() << endl << endl;
		}
		| RETURN expression SEMICOLON
		{
			logfile << "Line " << line_count << ":  statement: RETURN expression SEMICOLON"<< endl << endl;
			$$ =  new vector<SymbolInfo*>();
			$1->setName($1->getName() + " "); //return 0; including the space here
			$$->push_back($1);

			logfile << $1->getName();
			for(int i = 0; i< $2->size(); i++){
				$$->push_back($2->at(i));
				logfile << $2->at(i)->getName();
			
			}
			
			$3->setName($3->getName() + "\n"); //new line after SEMICOLON	
			$$->push_back($3);

			logfile << $3->getName() << endl << endl;
			

		}
		;
	  
expression_statement : SEMICOLON	
		{	
			
			$1->setName($1->getName() + "\n"); //new line after SEMICOLON	
			logfile << "Line " << line_count << ":  expression_statement : SEMICOLON"<< endl << endl << $1->getName() << endl << endl << endl; 
			$$ = new vector<SymbolInfo*>();
			$$->push_back($1);

		}	
		| expression SEMICOLON 
		{
			logfile << "Line " << line_count << ":  expression_statement : expression SEMICOLON"<< endl << endl;
			$$ = new vector<SymbolInfo*>();
			for(int i = 0; i< $1->size(); i++){
				$$->push_back($1->at(i));
				logfile << $1->at(i)->getName();
			
			}
			$2->setName($2->getName() + "\n"); //new line after SEMICOLON	
			$$->push_back($2);
			logfile << $2->getName() << endl << endl << endl;

		}
		;
	  
variable : ID 
	{	
		
		logfile << "Line " << line_count << ":  variable : ID"<< endl << endl << $1->getName() << endl << endl; 
		

		if(table->symbol_lookup($1->getName()) == nullptr){

			errorfile << "Error at line " << line_count << ": Undeclared variable " << $1->getName() << endl << endl;
			logfile << "Error at line " << line_count << ": Undeclared variable " << $1->getName() << endl << endl;
			error_count++;
			$1->setReturnType("error");

		}

		else if(table->symbol_lookup($1->getName()) != nullptr){
			string rt = table->symbol_lookup($1->getName())->getReturnType();
			
			//logfile << "return type: " << rt << endl;
			if(table->symbol_lookup($1->getName())->isArray()){
				errorfile << "Error at line " << line_count << ": Type mismatch, " << $1->getName() << " is an array" << endl << endl;
				logfile << "Error at line " << line_count << ":  Type mismatch, " << $1->getName() << " is an array" << endl << endl;
				error_count++;
				
				$1->setReturnType("error");
			}
		}
		$$ = new vector<SymbolInfo*>();
		$$->push_back($1);
		//logfile << $1->getReturnType() << endl;


	}
	| ID LTHIRD expression RTHIRD 
	{	

		//logfile << $1->getReturnType() << " is return type" << endl;
		logfile << "Line " << line_count << ":  variable : ID LTHIRD expression RTHIRD"<< endl << endl;
		$$ = new vector<SymbolInfo*>();
		
		
		bool prev_error = false;
		for(int i = 0; i< $3->size(); i++){
			if($3->at(i)->getReturnType() == "error"){
				prev_error = true;
				break;
			}
		}

		if(!prev_error){

			//1
			if(table->symbol_lookup($1->getName()) == nullptr){

				errorfile << "Error at line " << line_count << ": Undeclared variable " << $1->getName() << endl << endl;
				logfile << "Error at line " << line_count << ": Undeclared variable " << $1->getName() << endl << endl;
				error_count++;
				$1->setReturnType("error");

			}

			//2
					

			else if(table->symbol_lookup($1->getName()) != nullptr){

				if(!table->symbol_lookup($1->getName())->isArray()){
					errorfile << "Error at line " << line_count << ": "  << $1->getName() << " not an Array" << endl << endl;
					logfile << "Error at line " << line_count << ": "  << $1->getName() << " not an Array" << endl << endl;
					error_count++;
					$1->setReturnType("error");
				}


				else{

					for(int i = 0; i< $3->size(); i++){
						if($3->at(i)->getType() == "ID"){
							if($3->at(i)->getReturnType() != "int "){
								errorfile << "Error at line " << line_count << ": Expression inside third brackets not an integer"  << endl << endl;
								logfile << "Error at line " << line_count << ": Expression inside third brackets not an integer"  << endl << endl;
								error_count++;
								$1->setReturnType("error");
								break;
							}
						}

						else if($3->at(i)->getType() == "CONST_FLOAT"){
							errorfile << "Error at line " << line_count << ": Expression inside third brackets not an integer"  << endl << endl;
							logfile << "Error at line " << line_count << ": Expression inside third brackets not an integer"  << endl << endl;
							error_count++;
							$1->setReturnType("error");
							break;
							
						}
					}

				}
			}

		
			


		}


		
		/*if($3->size() == 1){
			string s = $3->at(0)->getName();
			if(s.find_first_not_of("0123456789") != string::npos){
				errorfile << "Error at line " << line_count << ": Expression inside third brackets not an integer"  << endl << endl;
				logfile << "Error at line " << line_count << ": Expression inside third brackets not an integer"  << endl << endl;
				error_count++;
			}

		}*/


		logfile << $1->getName() << $2->getName(); 
		$$->push_back($1);
		$$->push_back($2); 	//ID AND LTHIRD

		for(int i = 0; i < $3->size(); i++){
			logfile << $3->at(i)->getName();
			//logfile << " size: " << $3->size();
			
			$$->push_back($3->at(i));
		}

		$$->push_back($4);	//RTHIRD
		logfile << $4->getName() << endl << endl;

	}
	;
	 
 expression : logic_expression	
		{
			$$ = new vector<SymbolInfo*>();
			logfile << "Line " << line_count << ":  expression : logic_expression"<< endl << endl; 
			for(int i = 0; i< $1->size(); i++){
				$$->push_back($1->at(i));
				logfile << $1->at(i)->getName();
			}	
			logfile << endl << endl;

   		}	
		| variable ASSIGNOP logic_expression 
		{	
			
			bool prev_error = false;
			for(int i = 0; i<$1->size(); i++){
				if($1->at(i)->getReturnType() == "error"){
					//logfile << " ERROR HERE: " << $1->at(i)->getName() << endl;
					prev_error = true;
					break;
				}
			}
			
			if(!prev_error){
				for(int i = 0; i<$3->size(); i++){
					if($3->at(i)->getReturnType() == "error"){
						prev_error = true;
						break;
					}
				}
			}
			if(!prev_error){

				string var_type;
				for(int i = 0; i< $1->size(); i++){
					if($1->at(i)->getType() == "ID"){
						var_type = table->symbol_lookup($1->at(i)->getName())->getReturnType();
						break;
					}
				}
				string right_type;
				SymbolInfo* curr;
				for(int i = 0; i<$3->size(); i++){
					curr = $3->at(i);
						//logfile << "Ret type:" <<  curr->getReturnType() << endl;

					if(curr->getType() == "logrel "){
						right_type = "int ";
						continue;
					}
					
					if(curr->getType() == "ID"){
						curr = table->symbol_lookup(curr->getName());
						if(curr->isFunc()){
							
							if(curr->getReturnType() == "void "){
								errorfile << "Error at line " << line_count << ": Void function used in expression" << endl << endl;
								logfile << "Error at line " << line_count << ": Void function used in expression" << endl << endl;
								error_count++;
								prev_error = true;
								break;
							}
							else if(curr->getReturnType() == "float "){
								right_type = "float ";
								break;
							}
							else if(curr->getReturnType() == "int "){
								right_type = "int ";
								while(curr->getType() != "RPAREN"){
									i++;
									curr = $3->at(i);
								}
							}
						}

						else if(curr->isArray()){

							if(curr->getReturnType() == "float "){
								right_type = "float ";
								break;
							}
							else if(curr->getReturnType() == "int "){
								right_type = "int ";
								while(curr->getType() != "RTHIRD"){
									i++;
									curr = $3->at(i);
								}
							}

						}

						else{
							if(curr->getReturnType() == "float "){
								right_type = "float ";
								break;
							}
							else if(curr->getReturnType() == "int "){
								right_type = "int ";
							}

						}


					}

					else if(curr->getType() == "CONST_FLOAT"){
						right_type = "float ";
						break;
					}

					else if(curr->getType() == "CONST_INT"){
						right_type = "int ";
					}
				}
				if(!prev_error){
					//logfile <<"Types " << var_type << right_type << endl;
					
					if(!((right_type == var_type) || (right_type == "int " && var_type == "float "))){
						errorfile << "Error at line " << line_count << ": Type Mismatch" << endl << endl;
						logfile << "Error at line " << line_count << ": Type Mismatch" << endl << endl;
						error_count++;
					}
				}


			}


			logfile << "Line " << line_count << ":  expression : variable ASSIGNOP logic_expression"<< endl << endl;
			$$ = new vector<SymbolInfo*>();
			
			for(int i = 0; i< $1->size(); i++){
				$$->push_back($1->at(i));
				logfile << $1->at(i)->getName();
			
			}

			$$->push_back($2);
			logfile << $2->getName(); //ASSIGNOP

			for(int i = 0; i< $3->size(); i++){
				$$->push_back($3->at(i));
				logfile << $3->at(i)->getName();
			
			}

			logfile << endl << endl;

		}		
		;
			
logic_expression : rel_expression 
		{
			$$ = new vector<SymbolInfo*>();
			logfile << "Line " << line_count << ":  logic_expression : rel_expression"<< endl << endl;
			for(int i = 0; i< $1->size(); i++){
				$$->push_back($1->at(i));
				logfile << $1->at(i)->getName();
			}
			logfile << endl << endl;

   		}	
		| rel_expression LOGICOP rel_expression 
		{	
			bool prev_error = false;
			for(int i = 0; i< $1->size(); i++){
				if($1->at(i)->getReturnType() == "error"){
					prev_error = true;
					break;
				}
			}

			if(!prev_error){
				for(int i = 0; i< $3->size(); i++){
					if($3->at(i)->getReturnType() == "error"){
						prev_error = true;
						break;
					}
				}
				
			}

			if(!prev_error){

				for(int i = 0; i< $1->size(); i++){
					if($1->at(i)->getType() == "ID"){
						SymbolInfo *tem = table->symbol_lookup($1->at(i)->getName());
						if(tem->getReturnType() == "void "){
							errorfile << "Error at line " << line_count << ": Void function used in expression " << endl << endl;
							logfile << "Error at line " << line_count << ": Void function used in expression " << endl << endl;
							$1->at(i)->setReturnType("error");
							prev_error = true;
							error_count++;
						}

					}
				}
			}

			if(!prev_error){

				for(int i = 0; i< $3->size(); i++){
					if($3->at(i)->getType() == "ID"){
						SymbolInfo *tem = table->symbol_lookup($3->at(i)->getName());
						if(tem->getReturnType() == "void "){
							errorfile << "Error at line " << line_count << ": Void function used in expression " << endl << endl;
							logfile << "Error at line " << line_count << ": Void function used in expression " << endl << endl;
							$3->at(i)->setReturnType("error");
							prev_error = true;
							error_count++;
						}

					}
				}
			}


			logfile << "Line " << line_count << ":  logic_expression : rel_expression LOGICOP rel_expression"<< endl << endl;
			$$ = new vector<SymbolInfo*>();
			
			for(int i = 0; i< $1->size(); i++){
				$1->at(i)->setType("logrel ");
				$$->push_back($1->at(i));
				logfile << $1->at(i)->getName();
			
			}
			$2->setType("logrel ");
			$$->push_back($2);
			logfile << $2->getName(); //LOGICOP

			for(int i = 0; i< $3->size(); i++){
				$3->at(i)->setType("logrel ");
				$$->push_back($3->at(i));
				logfile << $3->at(i)->getName();
			
			}

			logfile << endl << endl;

		}	
		 ;
			
rel_expression	: simple_expression 
		{
			$$ = new vector<SymbolInfo*>();
			logfile << "Line " << line_count << ":  rel_expression	: simple_expression"<< endl << endl; 
			for(int i = 0; i< $1->size(); i++){
				$$->push_back($1->at(i));
				logfile << $1->at(i)->getName();
			}	
			logfile << endl << endl;

   		}
		| simple_expression RELOP simple_expression	
		{	

			bool prev_error = false;
			for(int i = 0; i< $1->size(); i++){
				if($1->at(i)->getReturnType() == "error"){
					prev_error = true;
					break;
				}
			}

			if(!prev_error){
				for(int i = 0; i< $3->size(); i++){
					if($3->at(i)->getReturnType() == "error"){
						prev_error = true;
						break;
					}
				}
				
			}

			if(!prev_error){

				for(int i = 0; i< $1->size(); i++){
					if($1->at(i)->getType() == "ID"){
						SymbolInfo *tem = table->symbol_lookup($1->at(i)->getName());
						if(tem->getReturnType() == "void "){
							errorfile << "Error at line " << line_count << ": Void function used in expression " << endl << endl;
							logfile << "Error at line " << line_count << ": Void function used in expression " << endl << endl;
							$1->at(i)->setReturnType("error");
							prev_error = true;
							error_count++;
						}

					}
				}
			}

			if(!prev_error){

				for(int i = 0; i< $3->size(); i++){
					if($3->at(i)->getType() == "ID"){
						SymbolInfo *tem = table->symbol_lookup($3->at(i)->getName());
						if(tem->getReturnType() == "void "){
							errorfile << "Error at line " << line_count << ": Void function used in expression " << endl << endl;
							logfile << "Error at line " << line_count << ": Void function used in expression " << endl << endl;
							$3->at(i)->setReturnType("error");
							prev_error = true;
							error_count++;
						}

					}
				}
			}


			logfile << "Line " << line_count << ":  rel_expression : simple_expression RELOP simple_expression"<< endl << endl;
			$$ = new vector<SymbolInfo*>();
			
			for(int i = 0; i< $1->size(); i++){
				$1->at(i)->setType("logrel ");
				$$->push_back($1->at(i));
				logfile << $1->at(i)->getName();
			
			}
			$2->setType("logrel ");
			$$->push_back($2);
			logfile << $2->getName(); //RELOP

			for(int i = 0; i< $3->size(); i++){
				$3->at(i)->setType("logrel ");
				$$->push_back($3->at(i));
				logfile << $3->at(i)->getName();
			
			}

			logfile << endl << endl;

		}
		;
				
simple_expression : term 
		{
			$$ = new vector<SymbolInfo*>();
			logfile << "Line " << line_count << ":  simple_expression : term"<< endl << endl; 
			for(int i = 0; i< $1->size(); i++){
				$$->push_back($1->at(i));
				logfile << $1->at(i)->getName();
			}	
			logfile << endl << endl;

   		}
		| simple_expression ADDOP term 
		{	
			bool prev_error = false;
			for(int i = 0; i< $1->size(); i++){
				if($1->at(i)->getReturnType() == "error"){
					prev_error = true;
					break;
				}
			}

			if(!prev_error){
				for(int i = 0; i< $3->size(); i++){
					if($3->at(i)->getReturnType() == "error"){
						prev_error = true;
						break;
					}
				}
				
			}

			if(!prev_error){

				for(int i = 0; i< $1->size(); i++){
					if($1->at(i)->getType() == "ID"){
						SymbolInfo *tem = table->symbol_lookup($1->at(i)->getName());
						if(tem->getReturnType() == "void "){
							errorfile << "Error at line " << line_count << ": Void function used in expression " << endl << endl;
							logfile << "Error at line " << line_count << ": Void function used in expression " << endl << endl;
							$1->at(i)->setReturnType("error");
							prev_error = true;
							error_count++;
						}

					}
				}
			}

			if(!prev_error){

				for(int i = 0; i< $3->size(); i++){
					if($3->at(i)->getType() == "ID"){
						SymbolInfo *tem = table->symbol_lookup($3->at(i)->getName());
						if(tem->getReturnType() == "void "){
							errorfile << "Error at line " << line_count << ": Void function used in expression " << endl << endl;
							logfile << "Error at line " << line_count << ": Void function used in expression " << endl << endl;
							$3->at(i)->setReturnType("error");
							prev_error = true;
							error_count++;
						}

					}
				}
			}
			



			logfile << "Line " << line_count << ":  simple_expression : simple_expression ADDOP term"<< endl << endl;
			$$ = new vector<SymbolInfo*>();
			
			for(int i = 0; i< $1->size(); i++){
				$$->push_back($1->at(i));
				logfile << $1->at(i)->getName();
			
			}

			$$->push_back($2);
			logfile << $2->getName(); //ADDOP

			for(int i = 0; i< $3->size(); i++){
				$$->push_back($3->at(i));
				logfile << $3->at(i)->getName();
			
			}

			logfile << endl << endl;

		}
		;
					
term :	unary_expression
		{
			$$ = new vector<SymbolInfo*>();
			logfile << "Line " << line_count << ":  term :	unary_expression"<< endl << endl;
			for(int i = 0; i< $1->size(); i++){
				$$->push_back($1->at(i));
				logfile << $1->at(i)->getName();
			}	
			logfile << endl << endl;

   		}
		|  term MULOP unary_expression
		{	
			

			
			bool prev_error = false;
			for(int i = 0; i< $1->size(); i++){
				if($1->at(i)->getReturnType() == "error"){
					prev_error = true;
					break;
				}
			}

			if(!prev_error){
				for(int i = 0; i< $3->size(); i++){
					if($3->at(i)->getReturnType() == "error"){
						prev_error = true;
						break;
					}
				}
				
			}

			if(!prev_error){

				for(int i = 0; i< $1->size(); i++){
					if($1->at(i)->getType() == "ID"){
						SymbolInfo *tem = table->symbol_lookup($1->at(i)->getName());
						if(tem->getReturnType() == "void "){
							errorfile << "Error at line " << line_count << ": Void function used in expression " << endl << endl;
							logfile << "Error at line " << line_count << ": Void function used in expression " << endl << endl;
							$1->at(i)->setReturnType("error");
							prev_error = true;
							error_count++;
						}

					}
				}
			}

			if(!prev_error){

				for(int i = 0; i< $3->size(); i++){
					if($3->at(i)->getType() == "ID"){
						SymbolInfo *tem = table->symbol_lookup($3->at(i)->getName());
						if(tem->getReturnType() == "void "){
							errorfile << "Error at line " << line_count << ": Void function used in expression " << endl << endl;
							logfile << "Error at line " << line_count << ": Void function used in expression " << endl << endl;
							$3->at(i)->setReturnType("error");
							prev_error = true;
							error_count++;
						}

					}
				}
			}
			
				
			if($2->getName() == "%"){
				if(!prev_error){
					//modulus operator operands should be integers
					for(int i = 0; i<$1->size(); i++){
						if(($1->at(i)->getType() == "ID" && $1->at(i)->getReturnType() != "int ") ||  $1->at(i)->getType() == "CONST_FLOAT"){

								errorfile << "Error at line " << line_count << ": Non-Integer operand on modulus operator"  << endl << endl;
								logfile << "Error at line " << line_count << ": Non-Integer operand on modulus operator"  << endl << endl;
								error_count++;
								$1->at(0)->setReturnType("error");
								prev_error = true;
								break;

							}
						}

					}


				if(!prev_error){
					for(int i = 0; i<$3->size(); i++){
						if(($3->at(i)->getType() == "ID" && $3->at(i)->getReturnType() != "int ") ||  $3->at(i)->getType() == "CONST_FLOAT"){
							

								errorfile << "Error at line " << line_count << ": Non-Integer operand on modulus operator"  << endl << endl;
								logfile << "Error at line " << line_count << ": Non-Integer operand on modulus operator"  << endl << endl;
								error_count++;
								$1->at(0)->setReturnType("error");
								prev_error = true;
								break;
							
						}

							else if($3->size() == 1 && $3->at(0)->getName() == "0"){
								errorfile << "Error at line " << line_count << ": Modulus by Zero"  << endl << endl;
								logfile << "Error at line " << line_count << ": Modulus by Zero"  << endl << endl;
								error_count++;
								$1->at(0)->setReturnType("error");
								prev_error = true;
								break;
							}
						}
					}


			}

			if(!prev_error && $2->getName() == "/"){
				if($3->size() == 1 && $3->at(0)->getName() == "0"){
					errorfile << "Error at line " << line_count << ": Division by Zero"  << endl << endl;
					logfile << "Error at line " << line_count << ": Division by Zero"  << endl << endl;
					error_count++;
					$1->at(0)->setReturnType("error");
					prev_error = true;
				}
			}


			logfile << "Line " << line_count << ":  term : term MULOP unary_expression"<< endl << endl;
			$$ = new vector<SymbolInfo*>();
			
			for(int i = 0; i< $1->size(); i++){
				$$->push_back($1->at(i));
				logfile << $1->at(i)->getName();
			
			}

			$$->push_back($2);
			logfile << $2->getName(); //MULOP

			for(int i = 0; i< $3->size(); i++){
				$$->push_back($3->at(i));
				logfile << $3->at(i)->getName();
			
			}

			logfile << endl << endl;

		}
     ;

unary_expression : ADDOP unary_expression
		{	

			bool prev_error = false;
			for(int i = 0; i< $2->size(); i++){
				if($2->at(i)->getReturnType() == "error"){
					prev_error = true;
					break;

				}
			}
			if(!prev_error){
				for(int i = 0; i< $2->size(); i++){
					if($2->at(i)->getType() == "ID"){
						SymbolInfo *tem = table->symbol_lookup($2->at(i)->getName());
						if(tem->getReturnType() == "void "){
							errorfile << "Error at line " << line_count << ": Void function used in expression " << endl << endl;
							logfile << "Error at line " << line_count << ": Void function used in expression " << endl << endl;
							$1->setReturnType("error");
							error_count++;
						}

					}
				}
			}


			logfile << "Line " << line_count << ":  unary_expression : ADDOP unary_expression"<< endl << endl << $1->getName();
			$$ = new vector<SymbolInfo*>();
			$$->push_back($1);

			for(int i = 0; i< $2->size(); i++)
			{
				$$->push_back($2->at(i));
				logfile << $2->at(i)->getName();
			}

			logfile << endl << endl;

		}  
		| NOT unary_expression 
		{	
			bool prev_error = false;
			for(int i = 0; i< $2->size(); i++){
				if($2->at(i)->getReturnType() == "error"){
					prev_error = true;
					break;

				}
			}
			if(!prev_error){
				for(int i = 0; i< $2->size(); i++){
					if($2->at(i)->getType() == "ID"){
						SymbolInfo *tem = table->symbol_lookup($2->at(i)->getName());
						if(tem->getReturnType() == "void "){
							errorfile << "Error at line " << line_count << ": Void function used in expression " << endl << endl;
							logfile << "Error at line " << line_count << ": Void function used in expression " << endl << endl;
							$1->setReturnType("error");
							error_count++;
						}

					}
				}
			}

			logfile << "Line " << line_count << ":  unary_expression : NOT unary_expression"<< endl << endl << $1->getName();
			$$ = new vector<SymbolInfo*>();
			$$->push_back($1);

			for(int i = 0; i< $2->size(); i++)
			{
				$$->push_back($2->at(i));
				logfile << $2->at(i)->getName();
			}

			logfile << endl << endl;

		}
		| factor 
		{
			$$ = new vector<SymbolInfo*>();	
			logfile << "Line " << line_count << ":  unary_expression : factor"<< endl << endl;
			for(int i = 0; i< $1->size(); i++){
				$$->push_back($1->at(i));
				logfile << $1->at(i)->getName();
			}
			logfile << endl << endl;


		}
		;

factor	: variable
		{
			$$ = new vector<SymbolInfo*>();	
			logfile << "Line " << line_count << ":  factor : variable"<< endl << endl; 
			for(int i = 0; i< $1->size(); i++){
				$$->push_back($1->at(i));
				logfile << $1->at(i)->getName();
			}	
			logfile << endl << endl;

   		}
	| ID LPAREN argument_list RPAREN
	{	
		bool prev_error = false;
		for(int i = 0; i< $3->size(); i++){
			if($3->at(i)->getReturnType() == "error"){
				prev_error = true;
				break;
			}
		}


		if(!prev_error){
			SymbolInfo *temp = table->symbol_lookup($1->getName());
			if((temp == nullptr) || (temp !=nullptr && !temp->isFunc())){
				errorfile << "Error at line " << line_count << ": Undeclared Function " << $1->getName() << endl << endl;
				logfile << "Error at line " << line_count << ": Undeclared Function " << $1->getName() << endl << endl;
				error_count++;
				$1->setReturnType("error");
			}

			else if(temp != nullptr && !temp->getDefined()){
				errorfile << "Error at line " << line_count << ": Undefined Function " << $1->getName() << endl << endl;
				logfile << "Error at line " << line_count << ": Undefined Function " << $1->getName() << endl << endl;
				error_count++;
				$1->setReturnType("error");
			}

			else{
				vector <SymbolInfo*> params = temp->getParamList();
				if(params.size() == 0 && $3->size() == 0){}
				/*for(int i = 0; i< params.size(); i++){
					if(params.at(i)->getType() == "ID"){
						logfile << "Return type of " << params.at(i)->getName() << " is " << params.at(i)->getReturnType() << endl;
					}
				}*/
				else{
				int param_no = 1;
				int arg_idx = 0;
				string current_returntype;
				//logfile << "Function call check" << endl;
				vector <string> arg_type;
				string type;
				for(int i = arg_idx; i<$3->size(); i++){
					
					if($3->at(i)->getType() == "COMMA"){
						arg_idx = i+1;
						param_no++;
						arg_type.push_back(type);
						type = "null";
						continue;
					}

					else{
						/*if($3->at(i)->getType() == "ID")
							SymbolInfo *tem2 = table->symbol_lookup($3->at(i)->getName());
						if(($3->at(i)->getType() == "ID" && tem2->getReturnType() == "float ") || $3->at(i)->getType() == "CONST_FLOAT")
							type = "float ";
						else if(($3->at(i)->getType() == "ID" && tem2->getReturnType() == "int ") || $3->at(i)->getType() == "CONST_INT"){
							if(type != "float ")
								type = "int ";
						}
						else if(tem2->getReturnType() == "void "){
							//error
							type = "void ";
						}*/


						if($3->at(i)->getType() == "ID"){
							SymbolInfo *tem2 = table->symbol_lookup($3->at(i)->getName());
							if(tem2->getReturnType() == "float ")type = "float ";
							else if(tem2->getReturnType() == "int "){
								if(type != "float ")type = "int ";
							}
							else if(tem2->getReturnType() == "void "){
							//error
								type = "void ";
							}
						}
						else if($3->at(i)->getType() == "CONST_FLOAT"){
							type = "float ";
						}
						else if($3->at(i)->getType() == "CONST_INT"){
							if(type != "float ")
								type = "int ";
						}

					}
				}
				arg_type.push_back(type);
				/*logfile << "Size : " << arg_type.size() << endl;
				logfile << "Thingy : " << arg_type.at(0) << endl;
				for(int i = 0; i<arg_type.size(); i++){
					logfile << arg_type.at(i) << endl;
				}*/
				int arg_itr = 0;
				for(int i = 0; i<params.size(); i++){
					if(params.at(i)->getType() == "ID"){
						if(params.at(i)->getReturnType() != arg_type.at(arg_itr)){
							errorfile << "Error at line " <<  line_count << ": " << arg_itr+1 << "th argument mismatch in function " <<  $1->getName()  << endl << endl;
							logfile << "Error at line " <<  line_count << ": " << arg_itr+1 << "th argument mismatch in function " <<  $1->getName()  << endl << endl;
							prev_error = true;
							$1->setReturnType("error");
							error_count++;
							break;
						}
						else{
							arg_itr++;
							if(arg_itr == arg_type.size())
							break;
						}
					}
				}

				if(!prev_error && temp->getParamCount() != param_no){
					errorfile << "Error at line " <<  line_count << ": Total number of argument mismatch in function " <<  $1->getName()  << endl << endl;
					logfile << "Error at line " <<  line_count << ": Total number of argument mismatch in function " <<  $1->getName()  << endl << endl;
					$1->setReturnType("error");
					error_count++;
				}

			}
			}
		}


		logfile << "Line " << line_count << ":  factor : ID LPAREN argument_list RPAREN"<< endl << endl<< $1->getName() << $2->getName() << " ";
		$$ = new vector<SymbolInfo*>();
		$$->push_back($1);
		//$2->setName($2->getName() + " ");
		$$->push_back($2);

		for(int i = 0; i< $3->size(); i++){
			$$->push_back($3->at(i));
			logfile << $3->at(i)->getName();
		
		}
		//$4->setName(" " + $4->getName());
		$$->push_back($4);
		logfile << $4->getName() << endl << endl;


	}
	| LPAREN expression RPAREN
	{
		logfile << "Line " << line_count << ":  factor : LPAREN expression RPAREN"<< endl << endl << $1->getName();
		$$ = new vector<SymbolInfo*>();
		$$->push_back($1);

		for(int i = 0; i< $2->size(); i++){
			$$->push_back($2->at(i));
			logfile << $2->at(i)->getName();
		
		}

		$$->push_back($3);
		logfile << $3->getName() << endl << endl; //RPAREN

	}
	| CONST_INT
	{
		logfile << "Line " << line_count << ":  factor : CONST_INT"<< endl << endl << $1->getName() << endl << endl;
		$$ = new vector<SymbolInfo*>();
		$$->push_back($1);
	}
	| CONST_FLOAT
	{
		logfile << "Line " << line_count << ":  factor : CONST_FLOAT"<< endl << endl<< $1->getName() << endl << endl;
		$$ = new vector<SymbolInfo*>();
		$$->push_back($1);
	}
	| variable INCOP 
	{
		logfile << "Line " << line_count << ":  factor : variable INCOP"<< endl << endl;
		$$ = new vector<SymbolInfo*>();
		for(int i = 0; i< $1->size(); i++){
			$$->push_back($1->at(i));
			logfile << $1->at(i)->getName();
		
		}
		$$->push_back($2);
		logfile << $2->getName() << endl << endl;

	}
	| variable DECOP
	{
		logfile << "Line " << line_count << ":  factor : variable DECOP"<< endl << endl;
		$$ = new vector<SymbolInfo*>();
		for(int i = 0; i< $1->size(); i++){
			$$->push_back($1->at(i));
			logfile << $1->at(i)->getName();
		
		}
		$$->push_back($2);
		logfile << $2->getName() << endl << endl;

	}
	;
	
argument_list : arguments
		{
			$$ = new vector<SymbolInfo*>();
			logfile << "Line " << line_count << ":  argument_list : arguments"<< endl << endl;
			for(int i = 0; i< $1->size(); i++){
				$$->push_back($1->at(i));
				logfile << $1->at(i)->getName();
			}	
			logfile << endl << endl;

   		}
		|
		{
			logfile << "Line " << line_count << ":  argument_list :"<< endl << endl;
			$$ = new vector<SymbolInfo*>(); //NOT SURE
		}
		;
	
arguments : arguments COMMA logic_expression
		{
			logfile << "Line " << line_count << ":  arguments : arguments COMMA logic_expression"<< endl << endl;
			$$ = new vector<SymbolInfo*>();
			
			for(int i = 0; i< $1->size(); i++){
				$$->push_back($1->at(i));
				logfile << $1->at(i)->getName();
			
			}
			//$2->setName(" " + $2->getName() + " ");
			$$->push_back($2);
			logfile << $2->getName(); //COMMA

			for(int i = 0; i< $3->size(); i++){
				$$->push_back($3->at(i));
				logfile << $3->at(i)->getName();
			
			}

			logfile << endl << endl;

		}
	    | logic_expression
		{
			$$ = new vector<SymbolInfo*>();
			logfile << "Line " << line_count << ":  arguments : logic_expression"<< endl << endl; 
			for(int i = 0; i< $1->size(); i++){
				$$->push_back($1->at(i));
				logfile << $1->at(i)->getName();
			}	
			logfile << endl << endl;

   		}
	    ;
 
%%
int main(int argc,char *argv[])
{

	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
	yyin= fin;
	//logfile << "HI MAIN" << endl; 
	yyparse();
	fclose(yyin);
	
	logfile.close();
	
	return 0;
	
}

