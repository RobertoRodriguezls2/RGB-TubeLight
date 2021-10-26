# RGB-TubeLight

For all photo and videographers who don't want to spend huge amounts of money on name brand LED tube lights, this is a DIY solution that builds on from to the generic DIY tube lights found across Youtube. What makes this different from the generic DIY Tube lights on Youtube is that this uses the WS2812b LED strip. This allows for full control of the LED's as they're individually addressable which lets you play custom patterns and effects.

## Arduino Hardware

- Gowoops MEGA 2560 PRO
- HC-05 Wireless Bluetooth RF Transceiver
- WS2812b LED Strip 

## Wiring
An example wiring diagram is shown below but you can adjust it depending on your board and the pins you'd like to use
### HC-05
- RX of the HC-05 to TX of the Arduino (pin 1)
- TX of the HC-05 to RX of the Arduino (pin 0)
- Ground the Ground of the Arduino
- 5v to the 5v of the Arduino
### WS2812 LED Strip
- 5v to positive termianl of a power adapter
- Ground to Ground of the Arduino & Ground of the power adapter
- Data to any Data pins on the arduino (in my case pin 6)

![RGB Tube Light Diagram](https://user-images.githubusercontent.com/79487120/138625282-659dbf73-507c-4b82-818b-f806f1851a49.png)


## Demo Video

[![RGB Tube Light Demo](https://user-images.githubusercontent.com/79487120/138844441-968c4a0c-b5c8-4adb-be39-7ccad97239d4.png)](https://youtu.be/ndP7aVbPUag)



