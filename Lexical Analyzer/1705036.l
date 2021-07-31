%option noyywrap

%x MULTILINE
%x SINGLE
%x STRING

%{
#include<bits/stdc++.h>
#include "1705036_symbolTable.cpp"
using namespace std;
int line_count=1;
int error_count = 0;
int error_line=0;
string sentence;
string logsent;
bool insert;

ofstream tokenfile;
SymbolTable st(7);
%}

WHITESPACE [ \t\f\r\v]+ 
LETTER [a-zA-Z]
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
		
	//UNTERMINATEDCHAR2 '({REGCHARSET}|{SPECIALCHARSET})[^\']
		
		/*fprintf(tokenfile,"<IF>");		
		
		SPECIALCHARSET	('\\t')|('\\n')|('\\\\')|('\\\'')|('\\a')|('\\f')|('\\r')|('\\b')|('\\v')|('\\0')
		CHARSET ('[A-z]{1}')|{SPECIALCHARSET}{1}
		MULTICOMM (\/\*)(.*|[ \t\n]*)*(\*\/)
		COMMENT (\/\/)[^\n\r]*[\n\r]|{MULTICOMM}
		fprintf(logfile,"Line no %d: Token <IF> Lexeme %s found\n",line_count,yytext);
		
		*/
		tokenfile << "<IF> ";
		logfile << "Line no " << line_count << ": Token <IF> Lexeme " << yytext << " found\n\n";
		}

"else"		{
		tokenfile << "<ELSE> ";
		logfile << "Line no " << line_count << ": Token <ELSE> Lexeme " << yytext << " found\n\n";
		}
		
"for"		{	
		tokenfile << "<FOR> ";
		logfile << "Line no " << line_count << ": Token <FOR> Lexeme " << yytext << " found\n\n";
		
		}
	
"while"	{	
		tokenfile << "<WHILE> ";
		logfile << "Line no " << line_count << ": Token <WHILE> Lexeme " << yytext << " found\n\n";
		
		}
	
"do"  	{	
		tokenfile << "<DO> ";
		logfile << "Line no " << line_count << ": Token <DO> Lexeme " << yytext << " found\n\n";
		
		}
	
"break"  	{	
		tokenfile << "<BREAK> ";
		logfile << "Line no " << line_count << ": Token <BREAK> Lexeme " << yytext << " found\n\n";
		
		}

"int"  	{	
		tokenfile << "<INT> ";
		logfile << "Line no " << line_count << ": Token <INT> Lexeme " << yytext << " found\n\n";
		
		}
		
"char"  	{	
		tokenfile << "<CHAR> ";
		logfile << "Line no " << line_count << ": Token <CHAR> Lexeme " << yytext << " found\n\n";
			
		}
	
"float"	{	
		tokenfile << "<FLOAT> ";
		logfile << "Line no " << line_count << ": Token <FLOAT> Lexeme " << yytext << " found\n\n";
		
		}
		
"double"	{	
		tokenfile << "<DOUBLE> ";
		logfile << "Line no " << line_count << ": Token <DOUBLE> Lexeme " << yytext << " found\n\n";
		
		}
	
"void"		{	
		tokenfile << "<VOID> ";
		logfile << "Line no " << line_count << ": Token <VOID> Lexeme " << yytext << " found\n\n";
		
		}	
		
"return"	{	
		tokenfile << "<RETURN> ";
		logfile << "Line no " << line_count << ": Token <RETURN> Lexeme " << yytext << " found\n\n";
		}
		
"switch"	{	
		tokenfile << "<SWITCH> ";
		logfile << "Line no " << line_count << ": Token <SWITCH> Lexeme " << yytext << " found\n\n";
		
		}
		
"case"		{	
		tokenfile << "<CASE> ";
		logfile << "Line no " << line_count << ": Token <CASE> Lexeme " << yytext << " found\n\n";
		
		}
		
"continue"	{	
		tokenfile << "<CONTINUE> ";
		logfile << "Line no " << line_count << ": Token <CONTINUE> Lexeme " << yytext << " found\n\n";
		
		}
		
"default"	{	
		tokenfile << "<DEFAULT> ";
		logfile << "Line no " << line_count << ": Token <DEFAULT> Lexeme " << yytext << " found\n\n";
		
		}
		
		
"++"		|
"--"		{
			/*fprintf(tokenfile,"<INCOP,%s>",yytext);
			fprintf(logfile,"Line no %d: Token <INCOP> Lexeme %s found\n",line_count,yytext);*/
			
			tokenfile << "<INCOP, " << yytext << "> ";
			logfile << "Line no " << line_count << ": Token <INCOP> Lexeme " << yytext << " found\n\n";
		}
		
"*"		|
"/"		|
"%"		{
			/*fprintf(tokenfile,"<MULOP,%s>",yytext);
			fprintf(logfile,"Line no %d: Token <MULOP> Lexeme %s found\n",line_count,yytext);*/
			
			tokenfile << "<MULOP, " << yytext << "> ";
			logfile << "Line no " << line_count << ": Token <MULOP> Lexeme " << yytext << " found\n\n";
		}	

"+"		|

"-"		{
			
			tokenfile << "<ADDOP, " << yytext << "> ";
			logfile << "Line no " << line_count << ": Token <ADDOP> Lexeme " << yytext << " found\n\n";
			//insert in symbol table and print symbol table content(only non empty buckets)
			// There is a '|' in "+"'s rule, this means match execute the action for following rule
			
		}
		
"<"		|
"<="		|
">"		|
">="		|
"=="		|
"!="		{
			tokenfile << "<RELOP, " << yytext << "> ";
			logfile << "Line no " << line_count << ": Token <RELOP> Lexeme " << yytext << " found\n\n";			
		}
		
"="		{
			tokenfile << "<ASSIGNOP, " << yytext << "> ";
			logfile << "Line no " << line_count << ": Token <ASSIGNOP> Lexeme " << yytext << " found\n\n";		
		}
		
"&&"		|
"||"		{
			tokenfile << "<LOGICOP, " << yytext << "> ";
			logfile << "Line no " << line_count << ": Token <LOGICOP> Lexeme " << yytext << " found\n\n";		
		}
		
"!"		{
			tokenfile << "<NOT, " << yytext << "> ";
			logfile << "Line no " << line_count << ": Token <NOT> Lexeme " << yytext << " found\n\n";		
		}
		
"("		{
			tokenfile << "<LPAREN, " << yytext << "> ";
			logfile << "Line no " << line_count << ": Token <LPAREN> Lexeme " << yytext << " found\n\n";	
		}
		
")"		{
			tokenfile << "<RPAREN, " << yytext << "> ";
			logfile << "Line no " << line_count << ": Token <RPAREN> Lexeme " << yytext << " found\n\n";	
		}
		
"{"		{
			tokenfile << "<LCURL, " << yytext << "> ";
			logfile << "Line no " << line_count << ": Token <LCURL> Lexeme " << yytext << " found\n\n";	
			//ENTER SCOPE
			st.EnterScope();
		}
		
"}"		{
			tokenfile << "<RCURL, " << yytext << "> ";
			logfile << "Line no " << line_count << ": Token <RCURL> Lexeme " << yytext << " found\n\n";	
			// EXIT SCOPE
			st.ExitScope();
		}
		
"["		{
			tokenfile << "<LTHIRD, " << yytext << "> ";
			logfile << "Line no " << line_count << ": Token <LTHIRD> Lexeme " << yytext << " found\n\n";	
		}
		
"]"		{
			tokenfile << "<RTHIRD, " << yytext << "> ";
			logfile << "Line no " << line_count << ": Token <RTHIRD> Lexeme " << yytext << " found\n\n";	
		}
		
","		{
			tokenfile << "<COMMA, " << yytext << "> ";
			logfile << "Line no " << line_count << ": Token <COMMA> Lexeme " << yytext << " found\n\n";	
		}
		
";"		{
			tokenfile << "<SEMICOLON, " << yytext << "> ";
			logfile << "Line no " << line_count << ": Token <SEMICOLON> Lexeme " << yytext << " found\n\n";	
		}

			
{DIGIT}+ 	{
			/*fprintf(tokenfile,"<CONST_INT,%s>",yytext);
			fprintf(logfile,"Line no %d: Token <CONST_INT> Lexeme %s found\n",line_count,yytext);*/
			
			tokenfile << "<CONST_INT, " << yytext << "> ";
			logfile << "Line no " << line_count << ": Token <CONST_INT> Lexeme " << yytext << " found\n\n";
			//insert in symbol table and print symbol table content(only non empty buckets)
			SymbolInfo* sinf = new SymbolInfo(yytext, "CONST_INT");
			insert = st.symbol_insert(sinf);
			if(insert)st.PrintAll();
			
		}

{FLOATNUM}	{	
			tokenfile << "<CONST_FLOAT, " << yytext << "> ";
			logfile << "Line no " << line_count << ": Token <CONST_FLOAT> Lexeme " << yytext << " found\n\n";
			SymbolInfo* sinf = new SymbolInfo(yytext, "CONST_FLOAT");
			insert = st.symbol_insert(sinf);
			if(insert)st.PrintAll();
					
		}
		
{DECIMALERROR}	{

			logfile << "Error at line no " << line_count << ": Too many decimal points " << yytext << endl<< endl;
			error_count++;

		}

{ILLNUMERROR}	{
			logfile << "Error at line no " << line_count << ": Ill formed number " << yytext << endl<< endl;
			error_count++;


		}
		
{INVALIDSUFFIX}	{
			logfile << "Error at line no " << line_count << ": Invalid prefix on ID or invalid suffix on Number " << yytext << endl<< endl;
			error_count++;


		}

		
{CHARSET}	{	

			logfile << "Line no " << line_count << ": Token <CONST_CHAR> Lexeme " << yytext << " found --> <CHAR_CONST, ";
			char ch;
			if(strlen(yytext) == 4){
				/*cout << yytext[1] << endl;
				cout <<yytext[2] << endl;*/
				string str(yytext);
				
				if(!str.compare("\'\\0\'"))
				{
			        	logfile << '\n' << " > \n\n";
			        	//line_count++;
			        	tokenfile << "<CHAR_CONST, " << '\n' << "> ";
				}
				
				else{
				
					if(!str.compare("\'\\n\'"))
					{	
						ch = '\n';
						//line_count++;
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
			//cout << strlen(yytext) << " " << yytext << endl; 
			
			//yytext[0] = '\0';
			//cout << yytext << endl;
			//yytext[strlen(yytext)-1] = '\0';
			
			/*tokenfile << "<CONST_CHAR, ";
			
				logfile << "Line no " << line_count << ": Token <CONST_CHAR> Lexeme " << yytext <<" found\n"; 	
			
			logfile << "Line no " << line_count << ": Token <CONST_CHAR> Lexeme "; 
			for(int i = 1; i< (strlen(yytext)-1); i++){
				tokenfile << yytext[i];
				logfile << yytext[i];		
				
			}
			/*tokenfile << "<CONST_CHAR," << yytext << ">";
			logfile << "Line no " << line_count << ": Token <CONST_CHAR> Lexeme " << yytext << " found\n";*/
			//tokenfile <<  ">";
			
			SymbolInfo* sinf = new SymbolInfo(yytext, "CONST_CHAR");
			insert = st.symbol_insert(sinf);
			if(insert)st.PrintAll();
			
			
		}
		
		
{MULTICHAR}	{
			logfile << "Error at line no " << line_count << ": Multi character constant error " << yytext << endl<< endl;
			error_count++;

		}
		
{UNTERMINATEDCHAR} {	

		
			logfile << "Error at line no " << line_count << ": Unterminated character " << yytext << endl;
			error_count++;
			line_count++;
		}
		
{EMPTYCHARERROR} {
			logfile << "Error at line no " << line_count << ": Empty character constant error " << yytext << endl<< endl;
			error_count++;
			//line_count++;
		


		}		
		
{ID}		{	
			tokenfile << "<ID, " << yytext << "> ";
			logfile << "Line no " << line_count << ": Token <ID> Lexeme " << yytext << " found\n\n";
			SymbolInfo* sinf = new SymbolInfo(yytext, "ID");
			insert = st.symbol_insert(sinf);
			if(insert)st.PrintAll();
			
		}
		/*
{COMMENT}	{

			//logfile << "Line no " << line_count << ": Token <COMMENT> Lexeme " << yytext << " found\n";
			cout << "HELLO\n";
			logfile << "Line no " << line_count << ": Token <COMMENT> Lexeme " << yytext << " found\n";
		}*/
		
		
(\/\*)		{
			BEGIN MULTILINE;
			sentence.clear();
			sentence = yytext;
			//cout << "Multiline state started at " << yytext << endl;
			//logfile << "Line no " << line_count << ": Token <COMMENT> Lexeme " << yytext;
			error_line = line_count;
			
		}
		
<MULTILINE>(\*\/)	{	//cout << "Exiting MULTILINE\n";
				sentence += yytext;
				logfile << "Line no " << error_line << ": Token <COMMENT> Lexeme " << sentence << " found\n\n";
				sentence.clear();
				BEGIN INITIAL;

			}
		
<MULTILINE>[^\n\r\*\/]	{
					//cout << "Line no " << line_count << ": Token <COMMENT> Lexeme " << yytext << " found\n";
					
				sentence += yytext;
					
			}
			
<MULTILINE>[\*\/]	{
				
				sentence += yytext;

			}
		
<MULTILINE>((\r)?\n)	{
				line_count++;
				
				sentence += yytext;
			}
			
<MULTILINE><<EOF>>	{
				
				error_count++;
				logfile << "Error at line no " << error_line << ": Unterminated Comment " << sentence << endl << endl;
				sentence.clear();
				BEGIN INITIAL;
			}
		
(\/\/)		{
			BEGIN SINGLE;
			//cout << "single line state started at " << yytext << endl;
			logfile << "Line no " << line_count << ": Token <COMMENT> Lexeme " << yytext;
			
		}
		
<SINGLE>((\r)?\n) {
			line_count++;
			//cout << "Exiting Single quote\n";
			logfile << " found\n\n";
			BEGIN INITIAL;

		}
		
<SINGLE>(\\((\r)?\n)) {
			//cout << " special " << yytext;
			line_count++;
			logfile << yytext;
		}
		
<SINGLE>[^\n\r] {	
			
			//cout << yytext;
			logfile << yytext;
		}

["]	{

		//cout << "Enter String State\n";
		//cout << yytext;
		BEGIN STRING;
		error_line = line_count;
		sentence = yytext;
		logsent = yytext;

	}
	
<STRING>{SPECIALCHARSET}	{
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

				}	

<STRING>(\\((\r)?\n))	{	
				//cout << "Strin continue to next line\n";
				line_count++;
				logsent += yytext;
			
			}
			
<STRING>((\r)?\n)	{

				line_count++;
				error_count++;
				logfile << "Error at line no " << error_line << ": Unterminated String " << logsent << endl << endl;
				BEGIN INITIAL;


			}
			
<STRING><<EOF>>	{

				line_count++;
				error_count++;
				logfile << "Error at line no " << error_line << ": Unterminated String " << logsent << endl << endl;
				BEGIN INITIAL;

			}
			
			
			
<STRING>["]	{	
			
			//cout << yytext;
			//cout << "\nString end\n";
			logsent += yytext;
			sentence += yytext;
			logfile << "Line no " << error_line << ": Token <STRING> Lexeme " << logsent << " found --> <STRING, " << sentence << "> \n\n";
			tokenfile << "<STRING, " << sentence << "> ";
			//cout << "Final Sent: " << sentence << endl;
			BEGIN INITIAL;
			

		}
		
		
<STRING>.	{
				//cout << yytext;	
				sentence += yytext;
				logsent += yytext;


			}
			
{WHITESPACE}	{}	
.		{
			logfile << "Error at line no " << line_count << ": Unrecognized character " << yytext << endl << endl;
			error_count++;
				
		}
<<EOF>>	{
	st.PrintAll();
	//line_count--;
	logfile << "Total lines: " << line_count << endl;
	logfile << "Total errors: " << error_count << endl;
	return 0;


}
%%

int main(int argc,char *argv[]){
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	

	
	//logfile.open("lexlog.txt");
	tokenfile.open("1705036_token.txt");
	logfile << endl;

	yyin= fin;
	yylex();
	fclose(yyin);
	/*fclose(tokenfile);
	fclose(logfile);*/
	
	//logfile.close();
	tokenfile.close();
	
	return 0;
}
