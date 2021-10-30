# RGB-TubeLight

This project contains the firmware for the arduino and the code for the mobile app. For all photo and videographers who don't want to spend huge amounts of money on name brand LED tube lights, this is a DIY solution that builds on from to the generic DIY tube lights found across Youtube. What makes this different from the generic DIY Tube lights on Youtube is that this project allows full control over bluetooth through the use of the App and arduino firmware.

# Mobile App-Control
The mobile app for now only works on android devices as the bluetooth library used can only work with android. Some bugs still exist with the app UI and the data sent to the arduino.

## Main Menu
Here is the main menu of the app where you can navigate between screens
![Main menu](https://user-images.githubusercontent.com/79487120/139559612-a35fcad9-84f3-4c8f-9de9-8f1574a5f463.png)

## Color Pallete
Here preset colors can be chosen along with the brightness of each color 
![Color Pallete](https://user-images.githubusercontent.com/79487120/139559635-af2c8b21-bf5f-4fd4-b2b4-f20ea60574e9.png)

## Color Wheel
Here any color can be chosen along with the saturation of the color. An issue of wrong colors being displayed happens when the color selected is being dragged too quickly
![Color Wheel](https://user-images.githubusercontent.com/79487120/139559661-ddf1b889-c9e5-4946-8173-198a513c19f6.png)

## Color Splitting
Here a user can choose any ratio of LEDs to be to different colors. This allows for your creativity of having a two tone light.
![Index](https://user-images.githubusercontent.com/79487120/139559686-1447a5a6-f86c-4904-9f57-16c07ee6febf.png)

## Patterns
Here preset patterns can be programmed into the arduinos firmware to play for a preset amount of time. For now a rainbow display and a strobe light are the preset patterns that run for about 2 seconds.
![Patterns](https://user-images.githubusercontent.com/79487120/139559717-9f86ccce-7d96-44e4-a009-4fc43c1680c7.png)

## Demo Video

[![RGB Tube Light Demo](https://user-images.githubusercontent.com/79487120/138844441-968c4a0c-b5c8-4adb-be39-7ccad97239d4.png)](https://youtu.be/ndP7aVbPUag)

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






