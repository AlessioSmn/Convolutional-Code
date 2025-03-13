#include <iostream>
#include <time.h>
#include <random>
using namespace std;

#define CYCLES 30
#define INPUT_REG_DIM 4
#define STATE_REG_DIM 10
#define CURRENT_INPUT_NAME "a_k_ext"
#define EXPECTED_OUTPUT_NAME "o_ext"
#define CLOCK_PERIOD "clk_period"
#define RISING_EDGE "rising_edge(clk_ext)"

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
            cout << "Random stream";
            return;
      
      case AllOnes:
            cout << "Only ones";
            return;

      case Alternate:
            cout << "Alternate";
            return;

      default:
      case AllZeros:
            cout << "Only zeros";
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
      cout << CURRENT_INPUT_NAME << " <= '" << (in == 0 ? "0" : "1") << "';" << endl;
}
void print_inputStream(bool* inputs){
      cout << "-- Input: ";
      for(int i = 0; i < CYCLES; i++)
            cout << (inputs[i] ? "1" : "0");
      cout << endl;
}
void print_waitForClockPeriod(){
      cout << "wait for " << CLOCK_PERIOD << ";"<< endl << endl;
}
void print_expectedOutput(bool exptOut){
      cout << EXPECTED_OUTPUT_NAME << " <= '" << exptOut << "';" << endl;
}


void generateTestBenchText(InputStreamType inputStreamType){

      bool inputStream[CYCLES];
      bool inputRegister[INPUT_REG_DIM];
      bool stateRegister[STATE_REG_DIM];

      // Initialize masks
      bool currentInputMask = 1;
      bool inputMask[INPUT_REG_DIM] = {0,0,1,1};
      bool stateMask[STATE_REG_DIM] = {0,0,0,0,0,0,0,1,0,1};

      srand(time(NULL));

      generateRandomInputStream(inputStream, inputStreamType);

      cout << "--" << endl;
      cout << "--" << endl;
      cout << "-- Input type: ";
      getInputStreamTypeName(inputStreamType);
      cout << endl;
      print_inputStream(inputStream);

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
            print_expectedOutput(newState);
            print_waitForClockPeriod();
      }
}

int main(){

      // Firstly run 0 and 1
      generateTestBenchText(AllZeros);
      generateTestBenchText(AllOnes);

      // Run alternate
      generateTestBenchText(Alternate);

      // Run random
      generateTestBenchText(Random);

      return 0;
}