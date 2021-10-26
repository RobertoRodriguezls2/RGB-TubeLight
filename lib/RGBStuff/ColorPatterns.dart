import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rgp_app/components/reusable_card.dart';
import 'package:rgp_app/components/icon_content.dart';
import 'package:rgp_app/components/RGBconstants.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

enum Preset { red, green, blue, orange, teal, yellow, purple, pink }

class ColorPatterns extends StatefulWidget {
  final BluetoothDevice server;

  const ColorPatterns({this.server});

  @override
  _ColorPatterns createState() => _ColorPatterns();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ColorPatterns extends State<ColorPatterns> {
  static BluetoothDevice device;
  Color selected = kInactiveCardColor;
  Color unselected = kInactiveCardColor;
  Preset selectedColor;
  int bright = 180;
  int weight = 60;
  int age = 30;
  String CurrentColor = '';

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

  int red = 0;
  int green = 0;
  int blue = 0;
  double brightness = 0;

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _sendMessage('<0,0,0,0>');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Index Control'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: ReusableCard(
                    onPress: () {
                      setState(() {
                        _sendMessage('!');
                        // _sendMessage('10,15');
                        CurrentColor = '<255,3,3,';
                        selectedColor = Preset.red;
                      });
                    },
                    colour: selectedColor == Preset.red
                        ? kActiveCardColor
                        : kInactiveCardColor,
                    cardChild: LinearGradientMask(
                      child: IconTheme(
                        data: new IconThemeData(color: Colors.white),
                        child: IconContent(
                          symbol: FontAwesomeIcons.playCircle,
                          label: 'Rainbow Chase',
                        ),
                      ),
                    ),
                  )),
                  Expanded(
                    child: ReusableCard(
                      onPress: () {
                        setState(() {
                          _sendMessage('@');
                          selectedColor = Preset.green;
                          CurrentColor = '<3,255,3,';
                        });
                      },
                      colour: selectedColor == Preset.green
                          ? kActiveCardColor
                          : kInactiveCardColor,
                      cardChild: Sirensgrad(
                        child: IconTheme(
                          data: new IconThemeData(color: Colors.white),
                          child: IconContent(
                            symbol: FontAwesomeIcons.brush,
                            label: 'Sirens',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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

class LinearGradientMask extends StatelessWidget {
  LinearGradientMask({this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return RadialGradient(
          center: Alignment.topLeft,
          radius: 1,
          //colors: [Colors.blue, Colors.red,Colors.green],
          colors: const [
            Color.fromARGB(255, 255, 0, 0),
            Color.fromARGB(255, 255, 255, 0),
            Color.fromARGB(255, 0, 255, 0),
            Color.fromARGB(255, 0, 255, 255),
            Color.fromARGB(255, 0, 0, 255),
            Color.fromARGB(255, 255, 0, 255),
            Color.fromARGB(255, 255, 0, 0),
          ],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}

class Sirensgrad extends StatelessWidget {
  Sirensgrad({this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return RadialGradient(
          center: Alignment.topLeft,
          radius: 1,
          //colors: [Colors.blue, Colors.red,Colors.green],
          colors: const [
            Color.fromARGB(255, 255, 0, 0),
            Color.fromARGB(255, 0, 0, 255),
          ],
          tileMode: TileMode.repeated,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
