import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gongfuchatimer/utils/utils.dart';

class Countdown extends StatefulWidget {
  Countdown(
      {Key key,
      this.onFinish,
      this.interval = const Duration(seconds: 1),
      this.increment = Duration.zero,
      this.duration = Duration.zero})
      : super(key: key);

  Duration duration;
  final Duration interval;
  Duration increment;
  final void Function() onFinish;

  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  Timer _timer;
  Duration _duration;
  Duration _incrementDuration;
  Duration _lastDuration;
  TextEditingController initialTimeController = TextEditingController();
  TextEditingController incrementTimeController = TextEditingController();

  @override
  void initState() {
    _duration = widget.duration == Duration.zero
        ? Duration(seconds: 15)
        : widget.duration;

    incrementTimeController.text = _duration.inSeconds.toString();
    incrementTimeController.addListener(() {
      var val = int.tryParse(incrementTimeController.text);
      if (val != null) {
        _incrementDuration = Duration(seconds: val);
        _duration = _lastDuration + _incrementDuration;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    if (_timer == null || !_timer.isActive) {
      _lastDuration = _duration;
      _timer = Timer.periodic(widget.interval, timerCallback);
    }
  }

  void timerCallback(Timer timer) {
    setState(() {
      if (_duration.inSeconds == 0) {
        timer.cancel();
        _duration = _lastDuration + _incrementDuration;
      } else {
        _duration = Duration(seconds: _duration.inSeconds - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          decoration: InputDecoration(labelText: 'Initial'),
          controller: initialTimeController,
          keyboardType: TextInputType.number,
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Increment'),
          controller: incrementTimeController,
          keyboardType: TextInputType.number,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: Container(
                height: 100,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: RaisedButton(
                  child: Text('Start'),
                  onPressed:
                      (_timer != null && _timer.isActive) ? null : startTimer,
                ),
              ),
            ),
            Flexible(
              child: Container(
                height: 100,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: RaisedButton(
                  child: Text('Stop'),
                  onPressed: (_timer != null && _timer.isActive)
                      ? () {
                          _timer.cancel();
                        }
                      : null,
                ),
              ),
            ),
            Flexible(
              child: Container(
                height: 100,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: RaisedButton(
                  child: Text('Reset'),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 20,
        ),
        Center(
          child: CircleAvatar(
            radius: 100,
            child: Text(_duration.inSeconds.toString()),
          ),
        )
      ],
    );
  }
}
