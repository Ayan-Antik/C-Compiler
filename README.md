# C-Compiler
A Compiler based on a subset of the C language.
## Stages:
`Symbol Table (C++)`

The Symbol Table stores the **Lexemes & Tokens** found in the C code in a hash table. 

`Lexical Analyzer (Lex)`

Generates Tokens based on Lexemes. It also finds out Lexical Errors.

`Syntax & Semantics Analyzer (YACC/Bison)`

Parses the tokens from the Lexical Analyzer based on the Grammar rules. Report some Syntax & Semantic Errors.

`Intermediate Code Generation`

Generates *intel 8086 Assembly Language* code from the C code. Provides some code optimization.

