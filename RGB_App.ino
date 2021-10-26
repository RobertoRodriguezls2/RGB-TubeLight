//Works with flutters bluetooth but colors must be sent in the this example format ('<255,255,255,>')
// ColorSelectWheel still has issues getting accurate data


#include <Adafruit_NeoPixel.h>
#define LED_PIN    6
#define LED_COUNT 144
Adafruit_NeoPixel strip(LED_COUNT, LED_PIN, NEO_GRB + NEO_KHZ800);


//=============================================================
const byte characterAmount = 32;
char charactersRecieved[characterAmount];
char tempCharactersRecieved[characterAmount];   // temp array

// variables for each rgb channel
int RED = 0;
int GREEN = 0;
int BLUE = 0.0;
int BRIGHTNESS = 0.0;

boolean newIncomingData = false;

//============

void setup() {
  Serial.begin(38400);
  strip.begin();           // INITIALIZE NeoPixel strip object (REQUIRED)
  strip.show();
  strip.setBrightness(254);
}

//============

void loop() {

  dataInput();  // takes in data and checks what data was sent in

  if (newIncomingData == true) {
    strcpy(tempCharactersRecieved, charactersRecieved);
    dataSeperator();  // addresses each rgb value from the temp array of data
    colorControl();   // sets the colors of the LEDs through the rgb variables
    newIncomingData = false;

  }


}






//================================================ Brightness function



void dataInput() {

  static boolean incomingData = false;
  static byte index = 0;
  char begginingMarker = '<';
  char endingMarker = '>';
  char currentCharacter;

  while (Serial.available() > 0 && newIncomingData == false) {

    currentCharacter = Serial.read();
    Serial.println(currentCharacter);

    //===============================================
    switch (currentCharacter)
    {
      case '!': // if the user pressed the play button on the pattern page
        {
          theaterChaseRainbow(2);
          break;
        }

      case '@': // testing out police style flashing if button was pressed on the pattern page
        {
          //        int k =0;
          //        int x = strip.numPixels();
          //        Serial.println(x);
          //        x = x / 2;
          //        int y = x + 1;
          //
          //        while( k < 2)
          //        {
          //           for(int i = 0; i <= x; i++)
          //      {
          //
          //        strip.setPixelColor(i, strip.Color(255,0,0));
          //
          //        Serial.println("shouldve shown");
          //        //strip.delay(200);
          //
          //      }
          //      strip.show();
          //      delay(1);
          //      strip.clear();
          //
          //      for(int j = y; j <= 300 ; j++)
          //        {
          //          strip.setPixelColor(j, strip.Color(0,0,255));
          //
          //          Serial.println("shouldve shown part 2");
          //        }
          //        strip.show();
          //        delay(2);
          //        strip.clear();
          //        k++;
          //        }
          //        Serial.println("inside green");
          //        strip.clear();
          Strobe(0xff, 0xff, 0xff, 10, 50, 1000);
          break;

        }


      case '#': // handles all the data from the ColorSplitter class
        {
          strip.clear();
          int indexOne = Serial.parseInt(); // i LED's
          int indexTwo = Serial.parseInt(); // j LEDS
          int red1 = Serial.parseInt();
          int green1 = Serial.parseInt();
          int blue1 = Serial.parseInt();
          int red2 = Serial.parseInt();
          int green2 = Serial.parseInt();
          int blue2 = Serial.parseInt();
          indexTwo = indexTwo + 1 + indexOne;
          for (int i = 0; i < indexOne; i++)
          {
            strip.setPixelColor(i, strip.Color(  red1,   green1, blue1));

            for (int j = indexOne;  j < indexTwo; j++)
            {
              strip.setPixelColor(j, strip.Color(  red2,   green2, blue2));
              //strip.show();
            }

            strip.show();
          }
          Serial.print("number :");
          Serial.println(indexOne);
          Serial.print("2ndnumber :");
          Serial.println(indexTwo);
          Serial.print("RED1 :");
          Serial.println(red1);
          Serial.print("GREEN1 :");
          Serial.println(green1);
          Serial.print("BLUE1 :");
          Serial.println(blue1);
          Serial.print("RED2 :");
          Serial.println(red2);
          Serial.print("GREEN2 :");
          Serial.println(green2);
          Serial.print("BLUE2 :");
          Serial.println(blue2);
          break;
        }

      default:
        {

          break;
        }



    }

    if (incomingData == true) {

      if (currentCharacter != endingMarker) {

        charactersRecieved[index] = currentCharacter;
        index++;
        if (index >= characterAmount) {

          index = characterAmount - 1;
        }
      }
      else {

        charactersRecieved[index] = '\0'; // end string
        incomingData = false;
        index = 0;
        newIncomingData = true;
      }
    }

    else if (currentCharacter == begginingMarker) {

      incomingData = true;
    }
  }
}



//================================================

//============

void dataSeperator() {

  char * stringIndex;

  stringIndex = strtok(tempCharactersRecieved, ",");
  RED = atoi(stringIndex);

  stringIndex = strtok(NULL, ",");
  GREEN = atoi(stringIndex);

  stringIndex = strtok(NULL, ",");
  BLUE = atof(stringIndex);

  stringIndex = strtok(NULL, ",");
  BRIGHTNESS = atof(stringIndex);

}



//============

void colorControl() {
  strip.clear();
  Serial.print("RED: ");
  Serial.println(RED);
  Serial.print("GREEN: ");
  Serial.println(GREEN);
  Serial.print("BLUE: ");
  Serial.println(BLUE);
  Serial.print("BRIGHTNESS: ");
  Serial.println(BRIGHTNESS);
  Serial.println("");

  strip.fill(strip.Color(RED, GREEN, BLUE));
  if (BRIGHTNESS > 1) {
    strip.setBrightness(BRIGHTNESS);
  }
  strip.show();
}


void theaterChaseRainbow(int wait) {  // borrowed from adafruits example library
  int firstPixelHue = 0;     // First pixel starts at red (hue 0)
  for (int a = 0; a < 30; a++) { // Repeat 30 times...
    for (int b = 0; b < 3; b++) { //  'b' counts from 0 to 2...
      strip.clear();         //   Set all pixels in RAM to 0 (off)
      // 'c' counts up from 'b' to end of strip in increments of 3...
      for (int c = b; c < strip.numPixels(); c += 3) {
        // hue of pixel 'c' is offset by an amount to make one full
        // revolution of the color wheel (range 65536) along the length
        // of the strip (strip.numPixels() steps):
        int      hue   = firstPixelHue + c * 65536L / strip.numPixels();
        uint32_t color = strip.gamma32(strip.ColorHSV(hue)); // hue -> RGB
        strip.setPixelColor(c, color); // Set pixel 'c' to value 'color'
      }
      strip.show();                // Update strip with new contents
      delay(wait);                 // Pause for a moment
      firstPixelHue += 65536 / 90; // One cycle of color wheel over 90 frames
    }
  }
}


void Strobe(byte red, byte green, byte blue, int StrobeCount, int FlashDelay, int EndPause){
  for(int j = 0; j < StrobeCount; j++) {
   // setAll(red,green,blue);
    uint32_t magenta = strip.Color(red, green, blue);
    strip.fill(magenta);
    strip.show();
   // showStrip();
    delay(FlashDelay);
    //setAll(0,0,0);
    strip.clear();
    strip.show();
    //showStrip();
    delay(FlashDelay);
  }
 
 delay(EndPause);
}
