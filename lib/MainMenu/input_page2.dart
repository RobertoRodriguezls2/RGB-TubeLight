import 'package:rgp_app/RGBstuff/Color.dart';
import 'package:rgp_app/RGBstuff/ColorPatterns.dart';
import 'package:rgp_app/RGBstuff/ColorSelectWheel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rgp_app/RGBstuff/ColorSplitter.dart';
import 'package:rgp_app/components/RGBconstants.dart';
import 'package:rgp_app/components/reusable_card.dart';
import 'package:rgp_app/components/icon_content.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:rgp_app/DiscoveryPage.dart';

class InputPage2 extends StatefulWidget {
  @override
  _InputPage2State createState() => _InputPage2State();
}

class _InputPage2State extends State<InputPage2> {
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  static BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RGB Controller'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: ReusableCard(
                      onPress: () async {
                        final BluetoothDevice selectedDevice =
                            await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return DiscoveryPage();
                            },
                          ),
                        );
                        if (selectedDevice != null) {
                          print('Discovery -> selected ' +
                              selectedDevice.address);
                          device = selectedDevice;
                        } else {
                          print('Discovery -> no device selected');
                        }
                      },
                      colour: kActiveCardColor,
                      cardChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconContent(
                            symbol: FontAwesomeIcons.search,
                            label: 'Search',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ReusableCard(
              onPress: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Colorselect(server: device)));
              },
              colour: kActiveCardColor,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      LinearGradientMask(
                        child: IconTheme(
                          data: new IconThemeData(color: Colors.white),
                          child: IconContent(
                            symbol: FontAwesomeIcons.palette,
                            label: 'Color Palette',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ReusableCard(
              onPress: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ColorSelectWheel(server: device)));
              },
              colour: kActiveCardColor,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      IndexControlGradient(
                        child: IconTheme(
                            data: new IconThemeData(
                              color: Colors.white,
                            ),
                            child: IconContent(
                              symbol: FontAwesomeIcons.rainbow,
                              label: 'Color wheel  ',
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ReusableCard(
              onPress: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ColorSplitter(server: device)));
              },
              colour: kActiveCardColor,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Colorwheelgradient(
                        child: IconTheme(
                            data: new IconThemeData(
                              color: Colors.white,
                            ),
                            child: IconContent(
                              symbol: FontAwesomeIcons.cubes,
                              label: 'Index Controller',
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ReusableCard(
              onPress: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ColorPatterns(server: device)));
              },
              colour: kActiveCardColor,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      PatternGradient(
                        child: IconTheme(
                            data: new IconThemeData(
                              color: Colors.white,
                            ),
                            child: IconContent(
                              symbol: FontAwesomeIcons.artstation,
                              label: 'Pattern',
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

class IndexControlGradient extends StatelessWidget {
  IndexControlGradient({this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return RadialGradient(
          center: Alignment.centerRight,
          radius: 1,
          //colors: [Colors.blue, Colors.red,Colors.green],
          colors: const [
            Color(0XFF23cbdc),
            Color(0XFFdc3423),
          ],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}

class Colorwheelgradient extends StatelessWidget {
  Colorwheelgradient({this.child});
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
            Color.fromARGB(255, 0, 255, 255),
            Color.fromARGB(255, 0, 0, 255),
            Color.fromARGB(255, 255, 0, 255),
          ],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}

class PatternGradient extends StatelessWidget {
  PatternGradient({this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return RadialGradient(
          center: Alignment.centerLeft,
          radius: 1,
          colors: const [
            Color(0xFFfa1d05),
            Color(0xFFeb13ec),
          ],
          //colors: [Colors.blue, Colors.red,Colors.green],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
