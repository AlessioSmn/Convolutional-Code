#include <iostream>
#include <fstream>
#include <string>
#include <bitset>

using namespace std;

// Funzione che genera tutti i test per input a 4 bit
void generateTests(ofstream &outputFile) {
    // Ciclo su tutti i valori possibili da 0000 a 1111
    for (int i = 0; i < 16; ++i) {
        bitset<4> inputBits(i);
        int onesCount = inputBits.count()%2;

        // Genera il test nel formato richiesto
        outputFile << "\t\ta_ext <= \"" << inputBits.to_string() << "\";\n";
        outputFile << "\t\ts_e_ext <= '" << onesCount << "';\n";
        outputFile << "\t\twait for clk_period;\n\n";
    }
}

int main() {
    // Crea e apre il file di output
    ofstream outputFile("C:\\intelFPGA\\18.1\\projects\\ConvolutionalCoder\\modelsim\\codeTester\\lines\\adderTB.vhdl");


    // Controllo se il file è stato aperto correttamente
    if (!outputFile.is_open()) {
        cerr << "Errore nell'aprire il file.\n";
        return 1;
    }

    // Genera i test e li scrive nel file
    generateTests(outputFile);

    // Chiudi il file
    outputFile.close();

    cout << "Test generati e salvati nel file 'tests.vhdl'.\n";
    return 0;
}
