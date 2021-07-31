%option noyywrap

%x MULTILINE
%x SINGLE
%x STRING

%{
#include<bits/stdc++.h>
#include "1705036_symbolTable.cpp"
#include "y.tab.h"


using namespace std;
int line_count=1;
int error_count = 0;
int error_line=0;
string sentence;
string logsent;
bool insert;

extern SymbolTable *table;
extern YYSTYPE yylval;
extern ofstream logfile;

SymbolInfo* si_create(string name, string type){
	SymbolInfo *s = new SymbolInfo(name, type);
	//cout << "CREATING................" << name << " " << type << endl;
	return s;

	}
%}

WHITESPACE [ \t\f\r\v]+ 
DIGIT [0-9]
NEWLINE ((\r)?\n)
FLOATNUM {DIGIT}*(\.{DIGIT}+)?((E|e)[+-]?{DIGIT}+)?
ID [a-zA-Z_][a-zA-Z0-9_]*
SPECIALCHARSET	((\\t)|(\\n)|(\\\\)|(\\\')|(\\a)|(\\f)|(\\r)|(\\b)|(\\v)|(\\0)|(\\\"))
REGCHARSET [^\n\t\a\f\r\b\v\0']
CHARSET '{REGCHARSET}'|'{SPECIALCHARSET}'
DECIMALERROR {DIGIT}*(\.{DIGIT}+){2,}((E|e)[+-]?{DIGIT}*(\.{DIGIT}+)+)?
ILLNUMERROR ({DIGIT}*(\.{DIGIT}+)?((E|e)[+-]?{DIGIT}*(\.{DIGIT}+)+))|({DIGIT}+\.((E|e)[+-]?{DIGIT}+)?)
INVALIDSUFFIX {DIGIT}+[0-9a-zA-Z_]+
MULTICHAR '({REGCHARSET}{2,}|{SPECIALCHARSET}{2,}|({REGCHARSET}+{SPECIALCHARSET}+)|({SPECIALCHARSET}+{REGCHARSET}+))'
EMPTYCHARERROR ''

UNTERMINATEDCHAR '({REGCHARSET}*|{SPECIALCHARSET}*|({REGCHARSET}*{SPECIALCHARSET}*)|({SPECIALCHARSET}*{REGCHARSET}*))((\r)?\n)




%%

{NEWLINE} {line_count++;}


"if"		{
		yylval.si = si_create(yytext, "IF");
		return IF;}

"else"		{
		yylval.si = si_create(yytext, "ELSE");
		return ELSE;}
		
"for"		{
		yylval.si = si_create(yytext, "FOR");
		return FOR;}
	
"while"		{
		yylval.si = si_create(yytext, "WHILE");
		return WHILE;}
	
	
"int"  	{
		yylval.si = si_create(yytext, "INT"); 
		return INT;}
		
"char"  	{
		}
	
"float"	{
		yylval.si = si_create(yytext, "FLOAT");
		return FLOAT;}
		
	
"void"		{
			yylval.si = si_create(yytext, "VOID");
			return VOID;}	
		
"return"	{yylval.si = si_create(yytext, "RETURN");
			return RETURN;}


"printf"	{yylval.si = si_create(yytext, "PRINTLN");
			return PRINTLN;}
	
		

"++" 	{
	yylval.si = si_create(yytext, "INCOP");
	return INCOP;}
"--" 	{
	yylval.si = si_create(yytext, "DECOP");
	return DECOP;}
		
"*"		|
"/"		|
"%"		{
		
		yylval.si = si_create(yytext, "MULOP");
		return MULOP;}	

"+"		|
"-"		{
		
		
		yylval.si = si_create(yytext, "ADDOP");
		return ADDOP;}
		
"<"		|
"<="		|
">"		|
">="		|
"=="		|
"!="		{	
			
		
		yylval.si = si_create(yytext, "RELOP");
			return RELOP;	
		}
		
"="		{	yylval.si = si_create(yytext, "ASSIGNOP");
			return ASSIGNOP;}
		
"&&"		|
"||"		{
		
		yylval.si = si_create(yytext, "LOGICOP");
		return LOGICOP;}
		
"!"		{
		yylval.si = si_create(yytext, "NOT");
		return NOT;}
		
"("		{
		yylval.si = si_create(yytext, "LPAREN");
		return LPAREN;}
		
")"		{
		yylval.si = si_create(yytext, "RPAREN");
		return RPAREN;}
		
"{"		{
		yylval.si = si_create(yytext, "LCURL");
		return LCURL;}
		
"}"		{
		yylval.si = si_create(yytext, "RCURL");
		return RCURL;}
		
"["		{		
		yylval.si = si_create(yytext, "LTHIRD");
		return LTHIRD;}
		
"]"		{
	yylval.si = si_create(yytext, "RTHIRD");
	return RTHIRD;}
		
","		{
		yylval.si = si_create(yytext, "COMMA");
		return COMMA;}
		
";"		{
		yylval.si = si_create(yytext, "SEMICOLON"); 
		return SEMICOLON;}

			
{DIGIT}+ 	{	
			
			yylval.si = si_create(yytext, "CONST_INT");
				
			return CONST_INT;}

{FLOATNUM}	{	
			yylval.si = si_create(yytext, "CONST_FLOAT");
			
			return CONST_FLOAT;}
		
{DECIMALERROR}	{

			/*logfile << "Error at line no " << line_count << ": Too many decimal points " << yytext << endl<< endl;
			error_count++;*/

		}

{ILLNUMERROR}	{
			/*logfile << "Error at line no " << line_count << ": Ill formed number " << yytext << endl<< endl;
			error_count++;*/


		}
		
{INVALIDSUFFIX}	{
			/*logfile << "Error at line no " << line_count << ": Invalid prefix on ID or invalid suffix on Number " << yytext << endl<< endl;
			error_count++;*/


		}

		
{CHARSET}	{	/*

			logfile << "Line no " << line_count << ": Token <CONST_CHAR> Lexeme " << yytext << " found --> <CHAR_CONST, ";
			char ch;
			if(strlen(yytext) == 4){
				string str(yytext);
				
				if(!str.compare("\'\\0\'"))
				{
			        	logfile << '\n' << " > \n\n";
			        	tokenfile << "<CHAR_CONST, " << '\n' << "> ";
				}
				
				else{
				
					if(!str.compare("\'\\n\'"))
					{	
						ch = '\n';
					}
					else if(!str.compare("\'\\t\'"))ch = '\t';
					else if(!str.compare("\'\\\\\'"))ch = '\\';
					else if(!str.compare("\'\\\'\'"))ch = '\'';
					else if(!str.compare("\'\\a\'"))ch = '\a';
					else if(!str.compare("\'\\f\'"))ch = '\f';
					else if(!str.compare("\'\\r\'"))ch = '\r';
					else if(!str.compare("\'\\b\'"))ch = '\b';
					else if(!str.compare("\'\\v\'"))ch = '\v';
					else if(!str.compare("\'\\\"\'"))ch = '\"';
					
					
					
					
					logfile << ch << " > \n\n";
					tokenfile << "<CHAR_CONST, " << ch << "> ";
					
				}
			}
			
			
			
			if(strlen(yytext) == 3){
				tokenfile << "<CHAR_CONST, " << yytext[1] << "> ";
				logfile << yytext[1] << "> \n\n";
					
			}
			
			SymbolInfo* sinf = new SymbolInfo(yytext, "CONST_CHAR");
			insert = st.symbol_insert(sinf);
			if(insert)st.PrintAll();*/
			
			
		}
		
		
{MULTICHAR}	{
			/*logfile << "Error at line no " << line_count << ": Multi character constant error " << yytext << endl<< endl;
			error_count++;*/

		}
		
{UNTERMINATEDCHAR} {	

		
			/*logfile << "Error at line no " << line_count << ": Unterminated character " << yytext << endl;
			error_count++;
			line_count++;*/
		}
		
{EMPTYCHARERROR} {
			/*logfile << "Error at line no " << line_count << ": Empty character constant error " << yytext << endl<< endl;
			error_count++;
			//line_count++;*/
		


		}		
		
{ID}		{	
			/*tokenfile << "<ID, " << yytext << "> ";
			logfile << "Line no " << line_count << ": Token <ID> Lexeme " << yytext << " found\n\n";
			SymbolInfo* sinf = new SymbolInfo(yytext, "ID");
			insert = st.symbol_insert(sinf);
			if(insert)st.PrintAll();
			*/
			
			/*SymbolInfo *s= table->symbol_lookup(yytext);
				if(s==NULL)
				{					
					s= new SymbolInfo(yytext, "ID");
				}*/
				SymbolInfo *s = new SymbolInfo(yytext, "ID");
				yylval.si = s;	
				return ID;

		}
		
		
(\/\*)		{
			/*BEGIN MULTILINE;
			sentence.clear();
			sentence = yytext;
			//cout << "Multiline state started at " << yytext << endl;
			//logfile << "Line no " << line_count << ": Token <COMMENT> Lexeme " << yytext;
			error_line = line_count;*/
			
		}
		
<MULTILINE>(\*\/)	{	//cout << "Exiting MULTILINE\n";
				/*sentence += yytext;
				logfile << "Line no " << error_line << ": Token <COMMENT> Lexeme " << sentence << " found\n\n";
				sentence.clear();
				BEGIN INITIAL;*/

			}
		
<MULTILINE>[^\n\r\*\/]	{
					//cout << "Line no " << line_count << ": Token <COMMENT> Lexeme " << yytext << " found\n";
					
				/*sentence += yytext;*/
					
			}
			
<MULTILINE>[\*\/]	{
				
				//sentence += yytext;

			}
		
<MULTILINE>((\r)?\n)	{
				/*line_count++;
				
				sentence += yytext;*/
			}
			
<MULTILINE><<EOF>>	{
				
				/*error_count++;
				logfile << "Error at line no " << error_line << ": Unterminated Comment " << sentence << endl << endl;
				sentence.clear();
				BEGIN INITIAL;*/
			}
		
(\/\/)		{
			BEGIN SINGLE;
			//cout << "single line state started at " << yytext << endl;
			//logfile << "Line no " << line_count << ": Token <COMMENT> Lexeme " << yytext;*/
			
		}
		
<SINGLE>((\r)?\n) {
			line_count++;
			//cout << "Exiting Single quote\n";
			//logfile << " found\n\n";
			BEGIN INITIAL;

		}
		
<SINGLE>(\\((\r)?\n)) {
			//cout << " special " << yytext;
			/*line_count++;
			logfile << yytext;*/
		}
		
<SINGLE>[^\n\r] {	
			
			//cout << yytext;
			//logfile << yytext;
		}

["]	{

		//cout << "Enter String State\n";
		//cout << yytext;
		/*BEGIN STRING;
		error_line = line_count;
		sentence = yytext;
		logsent = yytext;*/

	}
	
<STRING>{SPECIALCHARSET}	{/*
				//cout << "(String special)";	
				//cout << yytext;
				
				
				logsent += yytext;
				string stryy(yytext);
				
				if(!stryy.compare("\\\""))sentence += '"';
				else if(!stryy.compare("\\n"))sentence += '\n';
				else if(!stryy.compare("\\t"))sentence += '\t';
				else if(!stryy.compare("\\\\"))sentence += '\\';
				else if(!stryy.compare("\\\'"))sentence += '\'';
				else if(!stryy.compare("\\a"))sentence += '\a';
				else if(!stryy.compare("\\f"))sentence += '\f';
				else if(!stryy.compare("\\r"))sentence += '\r';
				else if(!stryy.compare("\\b"))sentence += '\b';
				else if(!stryy.compare("\\v"))sentence += '\v';
				else if(!stryy.compare("\\0"))sentence += '\0';
				

				//cout << "\nmid sent:" << sentence << endl;

				*/}	

<STRING>(\\((\r)?\n))	{/*	
				//cout << "Strin continue to next line\n";
				line_count++;
				logsent += yytext;
			
			*/}
			
<STRING>((\r)?\n)	{/*

				line_count++;
				error_count++;
				logfile << "Error at line no " << error_line << ": Unterminated String " << logsent << endl << endl;
				BEGIN INITIAL;


			*/}
			
<STRING><<EOF>>	{/*

				line_count++;
				error_count++;
				logfile << "Error at line no " << error_line << ": Unterminated String " << logsent << endl << endl;
				BEGIN INITIAL;

			*/}
			
			
			
<STRING>["]	{	/*
			
			//cout << yytext;
			//cout << "\nString end\n";
			logsent += yytext;
			sentence += yytext;
			logfile << "Line no " << error_line << ": Token <STRING> Lexeme " << logsent << " found --> <STRING, " << sentence << "> \n\n";
			tokenfile << "<STRING, " << sentence << "> ";
			//cout << "Final Sent: " << sentence << endl;
			BEGIN INITIAL;
			

		*/}
		
		
<STRING>.	{/*
				//cout << yytext;	
				sentence += yytext;
				logsent += yytext;


			*/}
			
{WHITESPACE}	{}	
.		{/*
			logfile << "Error at line no " << line_count << ": Unrecognized character " << yytext << endl << endl;
			error_count++;
				
		*/}
<<EOF>>	{/*
	st.PrintAll();
	//line_count--;
	logfile << "Total lines: " << line_count << endl;
	logfile << "Total errors: " << error_count << endl;
	return 0;

		
*/	//table->PrintAll();	
	return 0;

}
%%
