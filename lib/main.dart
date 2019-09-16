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
      bottomNavigationBar: BottomBar(onPressed: _incrementCounter,),
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
        SoundButton(color: Colors.blueGrey[800],),
        SoundButton(color: Colors.blue[900],),
        SoundButton(color: Colors.lightBlue[900],),
        SoundButton(color: Colors.indigo[800],),
        SoundButton(color: Colors.teal[900],),
        SoundButton(color: Colors.cyan[900],),
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
  bool turnedOn = false;

  @override
  Widget build(BuildContext context) {
    return Container (
      color: widget.color,
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar ({this.onPressed});

  final VoidCallback onPressed;
  
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
                onPressed:  () => onPressed(),
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
                onPressed:  () => onPressed(),
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
                onPressed:  () => onPressed(),
              ),
            ),
          ),
        ],
      )
    );
  }
}