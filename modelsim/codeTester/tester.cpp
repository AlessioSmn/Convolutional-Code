#include <iostream>
#include <fstream>
#include <time.h>
#include <random>
using namespace std;

#define CYCLES 30
#define INPUT_REG_DIM 4
#define STATE_REG_DIM 6
#define CURRENT_INPUT_NAME "a_k_ext"
#define EXPECTED_OUTPUT_NAME "c_expected"
#define CURRENT_MASK_NAME "c_m_ext"
#define INPUT_MASK_NAME "i_m_ext"
#define STATE_MASK_NAME "s_m_ext"
#define CLOCK_PERIOD "clk_period"
#define RISING_EDGE "rising_edge(clk_ext)"

// Variabile globale per il file di output
ofstream outputTextFile;

enum InputStreamType{
      AllZeros,
      AllOnes,
      Alternate,
      Random
};
void getInputStreamTypeName(InputStreamType inputStreamType){
      switch (inputStreamType)
      {
      
      case Random:
            outputTextFile <<  "\t\t" << "Random stream";
            return;
      
      case AllOnes:
            outputTextFile <<  "\t\t" << "Only ones";
            return;

      case Alternate:
            outputTextFile <<  "\t\t" << "Alternate";
            return;

      default:
      case AllZeros:
            outputTextFile <<  "\t\t" << "Only zeros";
            return;
            break;
      }
}

/*
 * Generates a random input stream
 */
void generateRandomInputStream(bool* inputs, InputStreamType type){

      switch (type)
      {
      case Random:
            for(int i = 0; i < CYCLES; i++)
                  inputs[i] = rand() % 2;
            return;
      
      case Alternate:
            for(int i = 0; i < CYCLES; i++)
                  inputs[i] = i % 2;
            return;
      
      case AllOnes:
            for(int i = 0; i < CYCLES; i++)
                  inputs[i] = true;
            return;

      default:
      case AllZeros:
            for(int i = 0; i < CYCLES; i++)
                  inputs[i] = false;
            return;
      }
}

/*
 * Initializes a register with all zeros
 */
void initializeShiftRegister(bool* reg, int dim){
      for(int i = 0; i < dim; i++)
            reg[i] = 0;
}

/**
 * Simulates the ShiftRegister component
 */
void shiftRegister(bool* reg, int dim){
      for(int i = dim-1; i > 0; i--)
            reg[i] = reg[i-1];
}

/**
 * Calculates the new state, given current and past inputs and past states
 */
bool generateNewState(
      bool* inputReg, int inputRegDim, bool* inputMask,
      bool* stateReg, int stateRegDim, bool* stateMask,
      bool currentInput, bool currentInputMask
){
      bool newState = 0;

      // Sum current input masked
      newState = newState ^ (currentInput & currentInputMask);

      // Sum past inputs masked
      for(int i = 0; i < inputRegDim; i++)
            newState = newState ^ (inputReg[i] & inputMask[i]);

      // Sum past states masked
      for(int i = 0; i < stateRegDim; i++)
            newState = newState ^ (stateReg[i] & stateMask[i]);

      return newState;
}

void print_input(bool in){
      outputTextFile <<  "\t\t" << CURRENT_INPUT_NAME << " <= '" << (in == 0 ? "0" : "1") << "';" << endl;
}
void print_inputStream(bool* inputs){
      outputTextFile <<  "\t\t" << "-- Input: ";
      for(int i = 0; i < CYCLES; i++)
            outputTextFile <<  (inputs[i] ? "1-" : "0-");
      outputTextFile <<  "\t\t" << endl;
}
void print_mask(bool* mask, int maskDim, string CodeName, string Name){
      outputTextFile <<  "\t\t" << "-- " << Name << " Mask: " << endl;
      outputTextFile <<  "\t\t" << CodeName << " <= \"";
      for(int i = 0; i < maskDim; i++)
            outputTextFile <<  (mask[i] ? "1" : "0");
      outputTextFile << "\";" << endl;
}
void print_waitForClockPeriod(){
      outputTextFile <<  "\t\t" << "wait for " << CLOCK_PERIOD << ";"<< endl;
}
void print_expectedOutput(bool exptOut){
      outputTextFile <<  "\t\t" << EXPECTED_OUTPUT_NAME << " <= '" << exptOut << "';" << endl;
}

void print_register_info(
      bool *inputReg, bool *inputRegMask, int inputRegDim,
      bool *stateReg, bool *stateRegMask, int stateRegDim
){
      // Prints registers content content
      outputTextFile <<  "\t\t" << " -- Register states [";
      for(int i = 0; i < inputRegDim; i++)
            outputTextFile <<  (inputReg[i] ? "1" : "0");
      outputTextFile << "] [";
      for(int i = 0; i < stateRegDim; i++)
            outputTextFile <<  (stateReg[i] ? "1" : "0");
      outputTextFile << "]" << endl;
      
      // Prints only register entry used with the mask
      outputTextFile <<  "\t\t" << " -- Register masked [";
      for(int i = 0; i < inputRegDim; i++)
            outputTextFile <<  (inputRegMask[i] ? (inputReg[i] ? "1" : "0") : "x");
      outputTextFile << "] [";
      for(int i = 0; i < stateRegDim; i++)
            outputTextFile <<  (stateRegMask[i] ? (stateReg[i] ? "1" : "0") : "x");
      outputTextFile << "]" << endl;
}


void generateTestBenchText(InputStreamType inputStreamType, bool currentInputMask, bool *inputMask, bool *stateMask){

      bool inputStream[CYCLES];
      bool inputRegister[INPUT_REG_DIM];
      bool stateRegister[STATE_REG_DIM];

      // Initialize masks

      srand(time(NULL));

      generateRandomInputStream(inputStream, inputStreamType);

      outputTextFile << endl << endl << endl << endl << endl << "\t\t" << "-- Input type: ";
      getInputStreamTypeName(inputStreamType);
      outputTextFile <<  "\t\t" << endl;
      print_inputStream(inputStream);

      print_mask(inputMask, INPUT_REG_DIM, INPUT_MASK_NAME, "Input");
      print_mask(stateMask, STATE_REG_DIM, STATE_MASK_NAME, "Codeword");

      outputTextFile << endl;

      // Initialize the two shift registers
      initializeShiftRegister(inputRegister, INPUT_REG_DIM);
      initializeShiftRegister(stateRegister, STATE_REG_DIM);

      // Loop over all the cycles
      for(int i = 0; i < CYCLES; i++){

            // Generate new state
            bool newState = generateNewState(
                  inputRegister, INPUT_REG_DIM, inputMask,
                  stateRegister, STATE_REG_DIM, stateMask,
                  inputStream[i], currentInputMask
                  );

            // Shift the two registers
            shiftRegister(inputRegister, INPUT_REG_DIM);
            inputRegister[0] = inputStream[i];
            shiftRegister(stateRegister, STATE_REG_DIM);
            stateRegister[0] = newState;

            // Print data
            print_input(inputStream[i]);
            print_waitForClockPeriod();
            print_expectedOutput(newState);
            outputTextFile << endl;
            print_register_info(
                  inputRegister, inputMask, INPUT_REG_DIM,
                  stateRegister, stateMask, STATE_REG_DIM
            );
      }
}
void openFile() {
      string filePath = "C:/intelFPGA/18.1/projects/ConvolutionalCoder/modelsim/codeTester/lines/convcode_tester.txt";
      outputTextFile.open(filePath, ios::out);
      if (!outputTextFile.is_open()) {
            cerr << "Errore nell'aprire il file: " << filePath << endl;
            exit(1);
      }
}

int main(){

      // Open the output file
      openFile();

      // Run 0
      bool inputMask[INPUT_REG_DIM] = {0,0,1,1};
      bool stateMask[STATE_REG_DIM] = {1,0,0,1,0,1};
      generateTestBenchText(AllZeros, 1, inputMask, stateMask);

      // Run 1
      bool inputMask2[INPUT_REG_DIM] = {1,1,0,0};
      bool stateMask2[STATE_REG_DIM] = {0,1,1,0,1,0};
      generateTestBenchText(AllOnes, 1, inputMask2, stateMask2);

      // Run alternate
      bool inputMask3[INPUT_REG_DIM] = {1,0,0,1};
      bool stateMask3[STATE_REG_DIM] = {0,1,0,0,0,1};
      generateTestBenchText(Alternate, 1, inputMask3, stateMask3);

      // Run random
      bool inputMask4[INPUT_REG_DIM] = {0,1,0,0};
      bool stateMask4[STATE_REG_DIM] = {0,1,1,0,0,0};
      generateTestBenchText(Random, 1, inputMask4, stateMask4);

      return 0;
}