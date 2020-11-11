#include "Wire.h"
#include "MCP4725.h"

MCP4725 DAC(0x60);  // forward or backward
MCP4725 DAC2(0x61); // left or right

volatile int x;
uint32_t start, stop;
char val;
void setup()
{
  Serial.begin(115200);
  Serial3.begin(9600);
  Serial.print("MCP4725 test program: ");
  Serial.println(MCP4725_VERSION);

  DAC.begin();
  DAC2.begin();
  Serial.println("DAC start success!");
  //DAC.writeDAC(2048, true);
  //DAC.setValue(3084);
  //DAC2.setValue(512);


}

void loop()
{
  /*
    for (uint16_t i = 0; i < 4096; i++)
    {
    DAC.setValue(i);
    delay(10);
    }
    for (uint16_t i = 0; i < 4096; i++)
    {
    DAC.setValue(4096 - i);
    delay(10);
    }*/
  if (Serial3.available()) {
    val = Serial3.read();
    Serial.println(val);
    if (val == 'f') {
      voltOut(4.5, 2.5);
      Serial.println("forward!");
    }

    if (val == 'b') {
      voltOut(0.5, 2.5);
      Serial.println("backward!");
    }

    if (val == 'l') {
      voltOut(2.5, 4.5);
      Serial.println("left!");
    }

    if (val == 'r') {
      voltOut(2.5, 0.5);
      Serial.println("right!");
    }

    if (val == 's') {
      voltOut(2.5, 2.5);
      Serial.println("stop!");
    }

  }
}
void voltOut(float input1, float input2) {
  int out1 = input1 / 5.0 * 4095;
  int out2 = input2 / 5.0 * 4095;
  DAC.setValue(out1);
  DAC2.setValue(out2);
}
// -- END OF FILE --
