import 'dart:async';

import 'package:flutter/material.dart';
import 'package:countdown/countdown.dart';

void main() => runApp(Noiseio());

class SoundButtonInfo {
  // int id;
  double volume;
  bool turnedOn;

  SoundButtonInfo({this.volume = 50, this.turnedOn = false});
}

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
  var soundButtons = [SoundButtonInfo(), SoundButtonInfo(), SoundButtonInfo(),
    SoundButtonInfo(), SoundButtonInfo(), SoundButtonInfo()];

  _togglePlay() {
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

  _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  toggleButton(int id) {
    setState(() {
      soundButtons[id].turnedOn = !soundButtons[id].turnedOn;
      if (soundButtons[id].turnedOn) playing = true;
    });
  }

  setVolume(int id, double newVolume) {
    setState(() {
      soundButtons[id].volume = newVolume;
    });
  }

  String buttonsToString() {
    var rv = "";
    for(var i = 0; i < 6; ++i) {
      if (soundButtons[i].turnedOn) {
        rv += i.toString() + ": " + soundButtons[i].volume.toString() + " || ";
      }
    }
    return rv;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_counter || ${playing ? "Playing" : "Paused"} || ${buttonsToString()}'),
      ),
      body: SoundGrid(
        homeState: this,
      ),
      bottomNavigationBar: BottomBar(
        homeState: this,
        tempBottomFunction: _incrementCounter,
      ),
    );
  }
}

class SoundGrid extends StatelessWidget {
  final _MyHomePageState homeState;

  SoundGrid({this.homeState});

  Widget build(BuildContext context) {
    return GridView.count(
      primary: true,
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      children: <Widget>[
        SoundButton(
          color: Colors.blueGrey[300],
          homeState: homeState,
          id: 0,
        ),
        SoundButton(
          color: Colors.indigo[200],
          homeState: homeState,
          id: 1,
        ),
        SoundButton(
          color: Colors.blue[300],
          homeState: homeState,
          id: 2,
        ),
        SoundButton(
          color: Colors.lightBlue[400],
          homeState: homeState,
          id: 3,
        ),
        SoundButton(
          color: Colors.teal[400],
          homeState: homeState,
          id: 4,
        ),
        SoundButton(
          color: Colors.cyan[400],
          homeState: homeState,
          id: 5,
        ),
      ],
    );
  }
}

class SoundButton extends StatefulWidget {
  final Color color;
  final _MyHomePageState homeState;
  final int id;
  SoundButton({Key key, this.color, this.homeState, this.id}) : super(key: key);

  @override
  SoundButtonState createState() => SoundButtonState();
}

class SoundButtonState extends State<SoundButton> {

  _toggleOn() {
    widget.homeState.toggleButton(widget.id);
  }

  _changeVolume(double newVolume) {
    widget.homeState.setVolume(widget.id, newVolume);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: FlatButton(
        onPressed: () => _toggleOn(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('hello'),
            Icon(widget.homeState.soundButtons[widget.id].turnedOn ? Icons.pause : Icons.play_arrow),
            Visibility(
              visible: widget.homeState.soundButtons[widget.id].turnedOn,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Slider(
                min: 0.0,
                max: 100.0,
                divisions: null,
                activeColor: Colors.blueGrey[50],
                inactiveColor: Colors.blueGrey[200],
                value: widget.homeState.soundButtons[widget.id].volume,
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
  final _MyHomePageState homeState;
  final VoidCallback tempBottomFunction;

  BottomBar({this.homeState, this.tempBottomFunction});

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
                  child: Icon(homeState.playing ? Icons.pause : Icons.play_arrow,
                      size: 40),
                  onPressed: () => homeState._togglePlay(),
                ),
              ),
            ),
            Container(
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[700]),
              ),
            ),
            CountdownTimer(homeState: homeState),
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
                  onPressed: () => tempBottomFunction(),
                ),
              ),
            ),
          ],
        ));
  }
}

enum Times {
  NO_TIMER,
  ONE_MIN,
  FIVE_MIN,
  TEN_MIN,
  FIFTEEN_MIN,
  THIRTY_MIN,
  ONE_HOUR,
  TWO_HOUR
}

class CountdownTimer extends StatefulWidget {
  final _MyHomePageState homeState;

  CountdownTimer({this.homeState});

  @override
  CountdownTimerState createState() => CountdownTimerState();
}

class CountdownTimerState extends State<CountdownTimer> {
  bool counting = false;
  int secondsLeft = 0;
  CountDown cd;
  StreamSubscription<Duration> sub;

  _cancelTimer() {
    setState(() {
      sub.cancel();
      secondsLeft = 0;
      counting = false;
      widget.homeState._pause();
    });
  }

  _setTimer(Duration newD) {
    if (counting) {
      _cancelTimer();
    }

    setState(() {
      counting = true;
      cd = CountDown(newD, refresh: Duration(seconds: 1));
      secondsLeft = newD.inSeconds;
      sub = cd.stream.listen(null);

      sub.onData((Duration d) {
        setState(() {
          secondsLeft = d.inSeconds;
        });
      });

      sub.onDone(() {
        setState(() {
          counting = false;
        });
        widget.homeState._pause();
      });
    });
  }

  Future _userTimer() async {
    switch (await showDialog(
        context: context,
        builder: (_) => SimpleDialog(
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
        ))) {
      case Times.NO_TIMER:
        _cancelTimer();
        break;
      case Times.ONE_MIN:
        _setTimer(Duration(minutes: 1));
        break;
      case Times.FIVE_MIN:
        _setTimer(Duration(minutes: 5));
        break;
      case Times.TEN_MIN:
        _setTimer(Duration(minutes: 10));
        break;
      case Times.FIFTEEN_MIN:
        _setTimer(Duration(minutes: 15));
        break;
      case Times.THIRTY_MIN:
        _setTimer(Duration(minutes: 30));
        break;
      case Times.ONE_HOUR:
        _setTimer(Duration(hours: 1));
        break;
      case Times.TWO_HOUR:
        _setTimer(Duration(hours: 2));
        break;
      default:
        break;
    }
  }

  String timerToString() {
    int seconds = secondsLeft % 60;
    int minutes = (secondsLeft/60).floor() % 60;
    int hours = (secondsLeft/3600).floor();
    
    String timeString = "";
    timeString += (hours > 0) ? (hours.toString() + ":") : "";
    timeString += minutes.toString().padLeft(2,"0") + ":";
    timeString += seconds.toString().padLeft(2,"0");

    return timeString;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 80,
        child: FlatButton(
          child: counting ?
              Text(timerToString())
              : Icon(Icons.timer, size: 40),
          onPressed: () => _userTimer(),
        ),
      ),
    );
  }
}