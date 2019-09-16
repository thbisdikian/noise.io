import 'package:flutter/material.dart';

void main() => runApp(Noiseio());

class Noiseio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noise.io',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(widget.title),
        title: Text('$_counter'),
      ),
      body: SoundGrid(),
      bottomNavigationBar: BottomBar(tempBottomFunction: _incrementCounter,),
    );
  }
}

class SoundGrid extends StatelessWidget {
  Widget build(BuildContext context) {
    return GridView.count(
      primary: true,
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      children: <Widget>[
        SoundButton(color: Colors.blueGrey[300],),
        SoundButton(color: Colors.indigo[200],),
        SoundButton(color: Colors.blue[300],),
        SoundButton(color: Colors.lightBlue[400],),
        SoundButton(color: Colors.teal[400],),
        SoundButton(color: Colors.cyan[400],),
      ],
    );
  }
}

class SoundButton extends StatefulWidget {
  SoundButton({Key key, this.color}) : super(key: key);
  final Color color;

  @override
  SoundButtonState createState() => SoundButtonState();
}

class SoundButtonState extends State<SoundButton> {
  bool _turnedOn = false;
  double _volume = 0.0;

  _toggleOn() {
    setState(() => _turnedOn = !_turnedOn);
  }

  _changeVolume(double newVolume) {
    setState(() => _volume = newVolume);
  }

  @override
  Widget build(BuildContext context) {
    return Container (
      color: widget.color,
      child: FlatButton(
        onPressed: () => _toggleOn(),
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('hello'),
            Icon(_turnedOn ? Icons.pause : Icons.play_arrow),
            Visibility(
              visible: _turnedOn,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Slider(
                min: 0.0,
                max: 100.0,
                divisions: null,
                activeColor: Colors.blueGrey[50],
                inactiveColor: Colors.blueGrey[200],
                value: _volume,
                onChanged: (double newVolume) => _changeVolume(newVolume),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar ({this.tempBottomFunction});

  final VoidCallback tempBottomFunction;
  
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.grey,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              height: 100,
              child: FlatButton(
                child: Icon(Icons.play_arrow, size: 60.0),
                onPressed:  () => tempBottomFunction(),
              ),
            ),
          ),
          Container(
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[700]),
            ),
          ),
          Expanded(
            child: Container(
              height: 100,
              child: FlatButton(
                child: Icon(Icons.timer, size: 60.0),
                onPressed:  () => tempBottomFunction(),
              ),
            ),
          ),
          Container(
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[700]),
            ),
          ),
          Expanded(
            child: Container(
              height: 100,
              child: FlatButton(
                child: Icon(Icons.favorite_border, size: 60.0),
                onPressed:  () => tempBottomFunction(),
              ),
            ),
          ),
        ],
      )
    );
  }
}