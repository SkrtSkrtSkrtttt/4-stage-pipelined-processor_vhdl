#include <iostream>     // For standard input/output
#include <fstream>      // For file handling
#include <string>       // For string operations
#include <sstream>      // For string stream operations
#include <map>          // For map container to store key-value pairs

using namespace std;

// Function to convert a MIPS assembly code word to machine code
// Takes the assembly code as a string and a map for conversion

string convert(const string& code, const map<string, string>& machine) {
    map<string, string>::const_iterator it = machine.find(code);
    if (it != machine.end()) {  //if code exits in the map
        return it->second;
    } 
    return code; //if not found 
}
// code for converting decimal to binary 
string decimal_binary_con(int decimal) {
    string binary;
    if (decimal < 0) {
        decimal = 65536 + decimal;
    }

    do {
        int bit = decimal % 2;
        ostringstream oss;
        oss << bit;
        binary = oss.str() + binary;
        decimal /= 2;
    } while (decimal > 0);

    while (binary.length() < 16) {
        binary = "0" + binary;
    }

    return binary;
}

int main() {
    ifstream MIPSfile("assemblerN.txt");
    ofstream Machinefile("Nmachine_code.txt");

    if (!MIPSfile.is_open()) {
        cerr << "Cannot find nor open input file.\n";
        return 1;
    }

    if (!Machinefile.is_open()) {
        cerr << "Cannot find or make output file.\n";
        return 1;
    }
//MAP OUR INSTRUCTIONS TO BINARY
    map<string, string> converter;
converter["LI"] = "0";
converter["MAL"] = "10000";
converter["MAH"] = "10001";
converter["MSL"] = "10010";
converter["MSH"] = "10011";
converter["LMAL"] = "10100";
converter["LMAH"] = "10101";
converter["LMSL"] = "10110";
converter["LMSH"] = "10111";
converter["NOP"] = "1100000000";
converter["SLHI"] = "1100000001";
converter["AU"] = "1100000010";
converter["CNT1H"] = "1100000011";
converter["AHS"] = "1100000100";
converter["AND"] = "1100000101";
converter["BCW"] = "1100000110";
converter["MAXWS"] = "1100000111";
converter["MINWS"] = "1100001000";
converter["MLHU"] = "1100001001";
converter["MLHCU"] = "1100001010";
converter["OR"] = "1100001011";
converter["CLZH"] = "1100001100";
converter["RLH"] = "1100001101";
converter["SFWU"] = "1100001110";
converter["SFHS"] = "1100001111";
converter["$0"] = "00000";
converter["$1"] = "00001";
converter["$2"] = "00010";
converter["$3"] = "00011";
converter["$4"] = "00100";
converter["$5"] = "00101";
converter["$6"] = "00110";
converter["$7"] = "00111";
converter["$8"] = "01000";
converter["$9"] = "01001";
converter["$10"] = "01010";
converter["$11"] = "01011";
converter["$12"] = "01100";
converter["$13"] = "01101";
converter["$14"] = "01110";
converter["$15"] = "01111";
converter["$16"] = "10000";
converter["$17"] = "10001";
converter["$18"] = "10010";
converter["$19"] = "10011";
converter["$20"] = "10100";
converter["$21"] = "10101";
converter["$22"] = "10110";
converter["$23"] = "10111";
converter["$24"] = "11000";
converter["$25"] = "11001";
converter["$26"] = "11010";
converter["$27"] = "11011";
converter["$28"] = "11100";
converter["$29"] = "11101";
converter["$30"] = "11110";
converter["$31"] = "11111";
converter["0"] = "000";
converter["!1"] = "001";
converter["!2"] = "010";
converter["!3"] = "011";
converter["!4"] = "100";
converter["!5"] = "101";
converter["!6"] = "110";
converter["!7"] = "111";


    string line;
    while (getline(MIPSfile, line)) {
        istringstream iss(line);
        string word;
        string translated_line;

        while (iss >> word) {
            bool is_number = true;

            // Replace range-based for loop with indexed loop
            for (size_t i = 0; i < word.length(); ++i) {
                char c = word[i];
                if (!isdigit(c) && c != '-') {
                    is_number = false;
                    break;
                }
            }

            if (is_number) {
                // Replace stoi with stringstream
                std::stringstream ss(word);
                int decimal;
                ss >> decimal;
                translated_line += decimal_binary_con(decimal);
            } else {
                translated_line += convert(word, converter);
            }
        }

        translated_line.resize(25, '0');
        Machinefile << translated_line << "\n";
    }

    cout << "File mapping and converting is complete.\n";

    MIPSfile.close();
    Machinefile.close();

    return 0;
}

