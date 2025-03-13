#include <iostream>
#include <fstream>
#include <string>
#include <bitset>

using namespace std;

// Funzione che genera tutti i test per input a 4 bit
void generateTests(ofstream &outputFile) { 
      int mask[6] = {0, 1, 5, 7, 10, 15};
      // loop su tutte le mask
      for (int j = 0; j < 6; ++j) {
            bitset<4> maskBits(mask[j]);

            outputFile << "\t\twait for clk_period*4;\n";
            outputFile << "\n\t\t-- new mask: " << maskBits.to_string() << "\n";
            outputFile << "\t\tm_ext <= \"" << maskBits.to_string() << "\";\n";

            for (int i = 0; i < 16; ++i) {
                  bitset<4> inputBits(i);
                  bitset<4> expected_out = maskBits & inputBits;

                  // Genera il test nel formato richiesto
                  outputFile << "\t\ti_ext <= \"" << inputBits.to_string() << "\";\n";
                  outputFile << "\t\ts_e_ext <= \"" << expected_out.to_string() << "\";\n";
                  outputFile << "\t\twait for clk_period;\n";
            }
      }
}

int main() {
    // Crea e apre il file di output
    ofstream outputFile("C:\\intelFPGA\\18.1\\projects\\ConvolutionalCoder\\modelsim\\codeTester\\lines\\maskTB.vhdl");

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
