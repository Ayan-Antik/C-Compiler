#include <bits/stdc++.h>
using namespace std;
ofstream logfile("1705036_log.txt");



class SymbolInfo{

    string name;
    string type;
    SymbolInfo* next_symbol;

public:
    SymbolInfo(string n, string t, SymbolInfo* next = nullptr)
    {
        name = n;
        type = t;
        next_symbol = next;
    }
    void setName(string n){
        name = n;
    }
    string getName(){
        return name;
    }
    void setType(string t){
        type = t;
    }
    string getType(){
        return type;
    }

    void setNextSymbol(SymbolInfo* next)
    {
        next_symbol = next;
    }

    SymbolInfo* getNextSymbol(){
        return next_symbol;
    }

    ~SymbolInfo(){
        ///NOT SURE YET
        next_symbol = nullptr;
    }
};


class ScopeTable{

    int total_buckets;
    SymbolInfo** hash_table;
    ScopeTable* parentScope;
    string table_id;

public:
    ScopeTable(int n){
        total_buckets = n;
        hash_table = new SymbolInfo*[total_buckets];

        for(int i = 0; i< total_buckets; i++)
        {
            hash_table[i] = nullptr;
        }
        ///INITIATE TABLE ID TO INFINITY, PARENT SCOPE TO NULL, [CHANGE LATER]
        table_id = -1;
        parentScope = nullptr;
    }

    void setid(string parentid, int curr_level_deleted){
        ///do stuff
        if(parentid != "")
        table_id = parentid + "." + to_string(curr_level_deleted + 1);
        else{
            table_id = "1";
        }
    }

    string getid()
    {
        return table_id;
    }

    void setParent(ScopeTable* parent)
    {
        parentScope = parent;
    }

    ScopeTable* getParent()
    {
        return parentScope;
    }

    int hash_value(string word)
    {
        int sum_ascii = 0;
        char p;

        for(int i = 0; i < word.length(); i++)
        {
            p = word[i];
            //cout << "p: " << p << endl;
            sum_ascii += p;
        }
        //cout << "sum ascii: " << sum_ascii << endl;

        return sum_ascii%total_buckets;
    }

    bool scopetable_insert(SymbolInfo* sinfo)
    {
        string tem_name = sinfo->getName();
        int position = hash_value(tem_name);

        //cout << "I " << tem_name << " " << sinfo->getType() << endl;

        if(hash_table[position] != nullptr)
        {
            SymbolInfo* head = hash_table[position];
            int chain_position = 0;
            if(head->getName() == tem_name)
            {
               /* cout << "< " <<tem_name << ", " << sinfo->getType() <<" > already exists in current ScopeTable\n";
                logfile << "< " <<tem_name << ", " << sinfo->getType() <<" > already exists in current ScopeTable\n";*/
                logfile << tem_name << " already exists in current ScopeTable\n\n";
                return false;
            }
            while(head->getNextSymbol() != nullptr)
            {
                head = head->getNextSymbol();
                chain_position++;
                if(head->getName() == tem_name)
                {
                    /*cout << "< " <<tem_name << ", " << sinfo->getType() <<" > already exists in current ScopeTable\n";
                    logfile << "< " <<tem_name << ", " << sinfo->getType() <<" > already exists in current ScopeTable\n";*/
                    logfile << tem_name << " already exists in current ScopeTable\n\n";
                    return false;
                }
            }

            ///FOUND POSITION TO INSERT
            head->setNextSymbol(sinfo);
            chain_position++;
            /*cout << "Inserted in ScopeTable# " << table_id << " at position " << position << ", " << chain_position << endl;*/
            //logfile << "Inserted in ScopeTable# " << table_id << " at position " << position << ", " << chain_position << endl;
            return true;

        }

        else{
            hash_table[position] = sinfo;
            /*cout << "Inserted in ScopeTable# " << table_id << " at position " << position << ", 0" << endl;
            logfile << "Inserted in ScopeTable# " << table_id << " at position " << position << ", 0" << endl;*/

            return true;
        }

    }

    SymbolInfo* scope_lookup(string n)
    {
        int position = hash_value(n);

        //cout << "L " << n << endl;
        /// IF THE POSITION IN TABLE IS EMPTY
        if(hash_table[position] == nullptr)
        {
            //cout << "Not found\n";
            return nullptr;
        }

        else{
            SymbolInfo* head = hash_table[position];
            int chain_position = 0;

            if(head->getName() == n)
            {
                /*cout << "Found in ScopeTable# " << table_id << " at position " << position << ", 0\n";
                logfile << "Found in ScopeTable# " << table_id << " at position " << position << ", 0\n";*/
                return head;
            }

            while(head->getNextSymbol() != nullptr)
            {
                head = head->getNextSymbol();
                chain_position++;
                if(head->getName() == n){
                    /*cout << "Found in ScopeTable# " << table_id << " at position " << position << ", " << chain_position << endl;
                    logfile << "Found in ScopeTable# " << table_id << " at position " << position << ", " << chain_position << endl;*/
                    return head;
                }

            }
            //cout << "Not found\n";
            return nullptr;
        }
    }


    bool scope_delete(string n)
    {
        int position = hash_value(n);
        //cout << "D " << n << endl;

        int chain_position = 0;
        if(hash_table[position] == nullptr)
        {
            /*cout << "Not found\n";
            logfile << "Not found\n";*/
            return false;
        }
        SymbolInfo* head = hash_table[position];
        if(head->getName() == n){
            ///Delete from head.
            hash_table[position] = head->getNextSymbol();
            head->setNextSymbol(nullptr);
            delete head;

            /*cout << "Deleted Entry " << position << ", 0 from current ScopeTable\n";
            logfile << "Deleted Entry " << position << ", 0 from current ScopeTable\n";*/
            return true;
        }

        else{
            while(head->getNextSymbol() != nullptr)
            {
                SymbolInfo* tem_symbol = head->getNextSymbol();
                chain_position++;
                if(tem_symbol->getName() == n){
                    head->setNextSymbol(tem_symbol->getNextSymbol());///prev pointer now points to next of the symbol to be deleted.
                    tem_symbol->setNextSymbol(nullptr);
                    delete tem_symbol;
                    /*cout << "Deleted Entry " << position << ", " << chain_position << " from current ScopeTable\n";
                    logfile << "Deleted Entry " << position << ", " << chain_position << " from current ScopeTable\n";*/
                    return true;
                }
                head = head->getNextSymbol();
            }

            /*cout << "Not found\n";
            logfile << "Not found\n";*/
            return false;

        }


    }

    void scope_print()
    {
        /*cout << "ScopeTable # " << table_id << endl;*/
        //logfile << "ScopeTable # " << table_id << endl;
        bool tid = false;
        SymbolInfo* head;
        for(int i = 0; i< total_buckets; i++)
        {
            head = hash_table[i];
            /*cout << i << " -->";
            logfile << i << " -->";*/
            if(head == nullptr){
                /*cout << endl;
                logfile << endl;*/
                continue;
            }
            if(!tid){
                logfile << "ScopeTable # " << table_id << endl;
                tid = true;
            }
            /*cout << "  < " << head->getName() << " : " << head->getType() << " >";*/
            logfile << " " << i << " --> ";
            logfile << "< " << head->getName() << " : " << head->getType() << "> ";
            while(head->getNextSymbol()!=nullptr)
            {
                head = head->getNextSymbol();
                /*cout << "  < " << head->getName() << " : " << head->getType() << " >";*/
                logfile << "< " << head->getName() << " : " << head->getType() << "> ";
            }
            /*cout << endl;*/
            logfile << endl;
        }
        logfile << endl;

    }

    ~ScopeTable(){
        //cout << "Scope Table destructor: " << endl;
        for(int i = 0; i< total_buckets; i++)
        {
            SymbolInfo* temp = hash_table[i];
            while(temp != nullptr)
            {
                SymbolInfo* temp2 = temp;
                //cout << "Before del: " <<temp->getName() << endl;
                //cout << &temp << " " << temp2 << endl;
                temp = temp->getNextSymbol();
                //cout << "Deleting: <" << temp2->getName() << " : " << temp2->getType() << " >\n";
                delete temp2;
                /*if(temp)
                cout << "After del: " <<temp->getName() << endl;*/
            }

        }
        delete[] hash_table;
    }


};


class SymbolTable{

    ScopeTable* currentScope;
    int bucket_size;
    int scope_deleted;
public:
    SymbolTable(int n)
    {
        ///create global scope
        bucket_size = n;
        scope_deleted = 0;

        currentScope = new ScopeTable(bucket_size);
        currentScope->setid("", scope_deleted);

    }

    void setCurrentScope(ScopeTable* curr){
        currentScope = curr;
    }
    ScopeTable* getCurrentScope(){return  currentScope;}

    void EnterScope(){
            //cout << "Enter Scope CALLED\n";
            ScopeTable* temp = currentScope;
            currentScope = new ScopeTable(bucket_size);///Init MEMORY
            currentScope->setParent(temp);

            currentScope->setid(temp->getid(), scope_deleted);
            /*cout << "New ScopeTable with id " << currentScope->getid() << " created\n";
            logfile << "New ScopeTable with id " << currentScope->getid() << " created\n";*/
            scope_deleted = 0;

    }

    void ExitScope(){
        //cout << endl << currentScope->getid().back() << endl;
        if(currentScope == nullptr){
            //cout << "Not inside any scope\n";
            //logfile << "Not inside any scope\n";
            return;
        }

        int last_occ = currentScope->getid().find_last_of(".");

        string curr_level = "";
        for(int i = last_occ+1; i<currentScope->getid().length();i++)
        {
            curr_level += currentScope->getid()[i];
        }

        scope_deleted = stoi(curr_level); ///CHAR TO INT ?

        ScopeTable* temp = currentScope->getParent();
        /*cout << "ScopeTable with id " << currentScope->getid() << " removed\n";
        logfile << "ScopeTable with id " << currentScope->getid() << " removed\n";*/
        delete currentScope;
        currentScope = temp;



    }

    bool symbol_insert(SymbolInfo* sinf){
        return currentScope->scopetable_insert(sinf);

    }

    bool symbol_remove(string n){
        return currentScope->scope_delete(n);
    }

    SymbolInfo* symbol_lookup(string n){
        ScopeTable* curr = currentScope;
        while(curr != nullptr){
            SymbolInfo* temp = curr->scope_lookup(n);
            if(temp == nullptr)curr = curr->getParent();
            else{
                return temp;
            }
        }
        /*cout <<"Not found\n";
        logfile <<"Not found\n";*/
        return nullptr;

    }

    void PrintCurr(){currentScope->scope_print();}
    void PrintAll(){
        ScopeTable* tem = currentScope;
        while(tem != nullptr){
            tem->scope_print();
            tem = tem->getParent();
        }


    }

    ~SymbolTable(){
        ScopeTable* parent = currentScope->getParent();
        while(parent != nullptr){
            //cout << "Deleting scopetable " << currentScope->getid() << endl;
            delete currentScope;
            currentScope = parent;
            parent = currentScope->getParent();
        }

        //cout << "Deleting scopetable " << currentScope->getid() << endl;
        delete currentScope;///DELETE GLOBAL SCOPE
    }



};/*
int main(int argc, char*argv[]){

    ifstream ifile;
    ifile.open("input.txt");

    string line;
    getline(ifile, line);
    int b_size = stoi(line);
    SymbolTable *st = new SymbolTable(b_size);

    while(getline(ifile, line)){
        cout << line << endl;
        logfile << line << endl;
        stringstream ss(line);
        string token;
        vector <string> words;
        while(getline(ss, token, ' ')){
            //cout << "TOKEN: " << token.length() << endl;
            if(token.at(token.length() - 1) == '\r'){
                // HANDLING CARRIAGE RETURN
                token = token.substr(0, token.length() - 1);
            }
            words.push_back(token);
        }

        string ip = words.at(0);
        //cout << "AT 0:" << ip << endl;
        //cout << "Length: " << ip.length() << endl;
        if(ip == "I"){
            SymbolInfo* sinf = new SymbolInfo(words.at(1), words.at(2));
            //cout << "Word Length: " << words.at(1).length() << ", 2nd word: " << words.at(2).length() << endl;
            bool status = st->symbol_insert(sinf);
        }

        else if(ip == "L"){
            SymbolInfo* look_symbol = st->symbol_lookup(words.at(1));
        }
        else if(ip == "D"){
            bool status = st->symbol_remove(words.at(1));
        }
        else if(ip == "P"){
            if(words.at(1) == "A")
                st->PrintAll();
            else if(words.at(1) == "C")
                st->PrintCurr();
        }

        else if(ip == "S"){
            st->EnterScope();
        }
        else if(ip == "E"){
            st->ExitScope();
        }
        else {
            cout << "Invalid input " << ip << endl;
        }
        words.clear();
        //cout << endl;

    }
    delete st;
    return 0;
}*/
