import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:rgp_app/components/bottom_button.dart';
import 'package:rgp_app/components/reusable_card.dart';
import '../RGBconstants.dart';

class ColorSplitter extends StatefulWidget {
  final BluetoothDevice server;

  const ColorSplitter({this.server});

  @override
  _ColorSplitterState createState() => _ColorSplitterState();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ColorSplitterState extends State<ColorSplitter> {
  static final clientID = 0;
  BluetoothConnection connection;

  List<_Message> messages = List<_Message>();
  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;

  Color _currentColor = Colors.blue;
  final _controller = CircleColorPickerController(
    initialColor: Colors.blue,
  );

  Color _currentColor2 = Colors.blue;
  final _controller2 = CircleColorPickerController(
    initialColor: Colors.blue,
  );

  // int bright = 180;
  // int secbright = 200;
  int bright = 10;
  int secbright = 10;

  int red = 0;
  int green = 0;
  int blue = 0;
  int red2 = 0;
  int green2 = 0;
  int blue2 = 0;

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection.input.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Split'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ReusableCard(
                  colour: kActiveCardColor,
                  cardChild: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('First Index', style: kLabelTextStyle),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text(
                            bright.toString(),
                            style: kNumberTextStyle,
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          inactiveTrackColor: Color(0xFF8D8E98),
                          activeTrackColor: Color(0XFF32b5cd),
                          thumbColor: Color(0xFFcd32b5),
                          overlayColor: Color(0x29EB1555),
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 15.0),
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 30.0),
                        ),
                        child: Slider(
                          value: bright.toDouble(),
                          min: 0.0,
                          max: 300.0,
                          onChanged: (double newValue) {
                            setState(() {
                              bright = newValue.round();
                              secbright = newValue.round();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ReusableCard(
                  colour: kActiveCardColor,
                  cardChild: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Second Index ', style: kLabelTextStyle),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text(
                            secbright.toString(),
                            style: kNumberTextStyle,
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          inactiveTrackColor: Color(0xFF8D8E98),
                          activeTrackColor: Color(0XFF32b5cd),
                          thumbColor: Color(0xFFb5cd32),
                          overlayColor: Color(0x29EB1555),
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 15.0),
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 30.0),
                        ),
                        child: Slider(
                          value: secbright.toDouble(),
                          min: bright.toDouble(),
                          max: 300.0,
                          onChanged: (double newValue) {
                            setState(() {
                              secbright = newValue.round();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: Row(
              children: <Widget>[
                CircleColorPicker(
                  onChanged: (color) {
                    setState(() => _currentColor = color);
                  },
                  size: const Size(240, 240),
                  strokeWidth: 4,
                  thumbSize: 36,
                ),
                SizedBox(
                  width: 100.0,
                ),
                CircleColorPicker(
                  onChanged: (color2) {
                    setState(() => _currentColor2 = color2);
                  },
                  size: const Size(240, 240),
                  strokeWidth: 4,
                  thumbSize: 36,
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: BottomButton(
                buttonTitle: 'Set',
                onTap: () {
                  String r = 'red ';
                  String g = 'green ';
                  String b = 'blue ';
                  r = _currentColor.red.toString();
                  g = _currentColor.green.toString();
                  b = _currentColor.blue.toString();
                  red = int.parse(r);
                  green = int.parse(g);
                  blue = int.parse(b);
                  print('RED 1 $red');
                  print('GREEN 1 $green');
                  print('BLUE 1 $blue');

                  String r2 = 'red ';
                  String g2 = 'green ';
                  String b2 = 'blue ';
                  r2 = _currentColor2.red.toString();
                  g2 = _currentColor2.green.toString();
                  b2 = _currentColor2.blue.toString();
                  red2 = int.parse(r2);
                  green2 = int.parse(g2);
                  blue2 = int.parse(b2);
                  print('RED 2 $red2');
                  print('GREEN 2 $green2');
                  print('BLUE 2 $blue2');
                  String colormsg = ('<$r,$g,$b,>');
                  _sendMessage('#');
                  _sendMessage(bright.toString());
                  _sendMessage(secbright.toString());
                  //_sendMessage(colormsg);
                  _sendMessage(_currentColor.red.toString());
                  _sendMessage(_currentColor.green.toString());
                  _sendMessage(_currentColor.blue.toString());
                  _sendMessage(_currentColor2.red.toString());
                  _sendMessage(_currentColor2.green.toString());
                  _sendMessage(_currentColor2.blue.toString());

                  //_sendMessage('<0,0,0,>');
                  //_sendMessage('!0,0,255,*');
                  //Calculator calc = Calculator(height: height, weight: weight);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection.output.add(ascii.encode(text + "\r\n"));
        await connection.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}
