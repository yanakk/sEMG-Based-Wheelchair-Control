char val;
void setup()
{
  Serial.begin(115200);
  Serial3.begin(9600);
}

void loop()
{
  if (Serial.available()) {
    val = Serial.read();
    switch(val)
    {
      case '0': Serial3.println('s'); break;
      case '1': Serial3.println('f'); break;
      case '2': Serial3.println('b'); break;
      case '3': Serial3.println('l'); break;
      case '4': Serial3.println('r'); break;
      default: break;
    }
  }

}
// -- END OF FILE --
