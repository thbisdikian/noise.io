import 'dart:async';

import 'package:flutter/material.dart';
import 'package:countdown/countdown.dart';

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
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool playing = false;
  CountDown countdown;
  StreamSubscription<Duration> countdownListener;
  Duration remaining;

  _timerSet(Duration dur) {
    if (countdown != null) {
      countdownListener.cancel();
    }
    countdown = CountDown(dur, refresh: Duration(minutes:1));
    countdownListener = countdown.stream.listen(null);
    countdownListener.onData((Duration d) => remaining = d);
    countdownListener.onDone(() => playing = false);
  }
  

  _playPause() {
    playing ? _pause() : _play();
  }

  _play() {
    setState(() {
     playing = true; 
    });
  }

  _pause() {
    setState(() {
     playing = false; 
    });
  }

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
        title: Text('$_counter $playing'),
        // title: Text("${remaining.inHours%60}".padLeft(2, "0") + ":" + "${remaining.inMinutes%60}".padLeft(2, "0")),
      ),
      body: SoundGrid(),
      bottomNavigationBar: BottomBar(parent: this ,tempBottomFunction: _incrementCounter,),
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
  final Color color;

  SoundButton({Key key, this.color}) : super(key: key);

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

  final _MyHomePageState parent;
  final VoidCallback tempBottomFunction;

  BottomBar({this.parent, this.tempBottomFunction});
  
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
              height: 80,
              child: FlatButton(
                child: Icon(parent.playing ? Icons.pause : Icons.play_arrow, size: 40),
                onPressed:  () => parent._playPause(),
              ),
            ),
          ),
          Container(
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[700]),
            ),
          ),
          CountdownTimer(parent: parent),
          Container(
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[700]),
            ),
          ),
          Expanded(
            child: Container(
              height: 80,
              child: FlatButton(
                child: Icon(Icons.favorite_border, size: 40),
                onPressed:  () => tempBottomFunction(),
              ),
            ),
          ),
        ],
      )
    );
  }
}

class CountdownTimer extends StatefulWidget {
  final _MyHomePageState parent;

  CountdownTimer({this.parent});

  @override
  CountdownTimerState createState() => CountdownTimerState();
}

enum Times{NO_TIMER, ONE_MIN, FIVE_MIN, TEN_MIN, FIFTEEN_MIN, THIRTY_MIN, ONE_HOUR, TWO_HOUR}

class CountdownTimerState extends State<CountdownTimer> {
  bool counting = false;
  CountDown cd;
  StreamSubscription<Duration> sub;
  Duration r = Duration();

  _cancelTimer() {
    setState(() {
      sub.cancel();
      counting = false;
      widget.parent._pause();
    });
  }

  _setTimer(Duration newD) {
    if(counting) {
      _cancelTimer();
    }

    setState(() {
      // if(counting) {
      //   sub.cancel();
      // }
      counting = true;
      cd = CountDown(newD, refresh: Duration(seconds: 1));
      sub = cd.stream.listen(null);

      sub.onData((Duration d) {
        setState(() {
          r = d;
        });
      });

      sub.onDone(() {
        setState(() {
          counting = false;
        });
        widget.parent._pause();
      });
    });
  }

  Future _userTimer() async {
    switch(
      await showDialog(
        context: context,
        child: SimpleDialog(
          title: Text("Set Dialogue"),
          children: [
            SimpleDialogOption(
              child: Text("No timer"),
              onPressed: () => Navigator.pop(context, Times.NO_TIMER),
            ),
            SimpleDialogOption(
              child: Text("1 minute"),
              onPressed: () => Navigator.pop(context, Times.ONE_MIN),
            ),
            SimpleDialogOption(
              child: Text("5 minutes"),
              onPressed: () => Navigator.pop(context, Times.FIVE_MIN),
            ),
            SimpleDialogOption(
              child: Text("10 minutes"),
              onPressed: () => Navigator.pop(context, Times.TEN_MIN),
            ),
            SimpleDialogOption(
              child: Text("15 minutes"),
              onPressed: () => Navigator.pop(context, Times.FIFTEEN_MIN),
            ),
            SimpleDialogOption(
              child: Text("30 minutes"),
              onPressed: () => Navigator.pop(context, Times.THIRTY_MIN),
            ),
            SimpleDialogOption(
              child: Text("1 hours"),
              onPressed: () => Navigator.pop(context, Times.ONE_HOUR),
            ),
            SimpleDialogOption(
              child: Text("2 hours"),
              onPressed: () => Navigator.pop(context, Times.TWO_HOUR),
            ),
          ],
        )
      )
    ) {
      case Times.NO_TIMER:
        _cancelTimer();
        break;
      case Times.ONE_MIN:
        _setTimer(Duration(minutes:1));
        break;
      case Times.FIVE_MIN:
        _setTimer(Duration(minutes:5));
        break;
      case Times.TEN_MIN:
        _setTimer(Duration(minutes:10));
        break;
      case Times.FIFTEEN_MIN:
        _setTimer(Duration(minutes:15));
        break;
      case Times.THIRTY_MIN:
        _setTimer(Duration(minutes:30));
        break;
      case Times.ONE_HOUR:
        _setTimer(Duration(hours:1));
        break;
      case Times.TWO_HOUR:
        _setTimer(Duration(hours:2));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 80,
        child: FlatButton(
          child: counting ? 
            Text("${r.inMinutes%60}".padLeft(2, "0") + ":" + "${(r.inSeconds)%60}".padLeft(2, "0")) : 
            Icon(Icons.timer, size: 40),
          // onPressed:  () => _countfrom10(),
          onPressed: () => _userTimer(),
        ),
      ),
    );
  }
}