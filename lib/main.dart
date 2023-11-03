import 'dart:async';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:meal_timer/tim.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(Application());
}

class Application extends StatefulWidget {
  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  static const maxSec = 10;
  int seconds = maxSec;
  Timer? timer;
  final player = AudioPlayer();
  Future<void> playAudioFromUrl(String url) async {
    await player.play(AssetSource('assets/countdown_tick.mp3'));
  }

  void resetTimer() => setState(() => seconds = maxSec);

  void startTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() => seconds--);
        if (seconds <= 5) {
          player.play(AssetSource('countdown_tick.mp3'));
          // playAudioFromUrl(
          //     'https://drive.google.com/file/d/1friRjMRNPjfu3PX7MGPpM4z_mqr6Jqfw/view?usp=share_link');
        }
      } else {
        stopTimer(reset: false);
      }
    });
  }

  void stopTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    setState(() => timer?.cancel());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mindful Meal timer",
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Mindful Meal timer",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 228, 208, 231)),
          ),
          backgroundColor: Color.fromARGB(255, 41, 1, 66),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context)
                  .pop(); // Add any necessary navigation logic here
            },
          ),
        ),
        body: Container(
          color: Color.fromARGB(255, 37, 1, 43),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  seconds < maxSec
                      ? Text(
                          "Nom Nom :)",
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        )
                      : Text(
                          "Time to eat mindfully",
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "It's simple: Eat slowly for ten minutes, rest for five, then finish your meal.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              )),
              buildTimer(),
              SizedBox(
                height: 20,
              ),
              CupertinoSwitch(
                value: true,
                onChanged: (newValue) {},
                activeColor: CupertinoColors.activeGreen,
              ),
              Center(
                child: buildButtons(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = seconds == maxSec || seconds == 0;

    return isRunning || !isCompleted
        ? Column(
            children: [
              ButtonWidget(
                  text: isRunning ? "Pause" : "Resume",
                  onClicked: () {
                    if (isRunning) {
                      stopTimer(reset: false);
                    } else {
                      startTimer(reset: false);
                    }
                  }),
              ButtonWidget(
                text: "Let's stop I'm full now",
                onClicked: () {
                  stopTimer(reset: true);
                },
              )
            ],
          )
        : ButtonWidget(
            text: "START",
            onClicked: () {
              startTimer();
            },
          );
  }

  Widget buildTimer() => SizedBox(
        width: 250,
        height: 250,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              width: 150, // Width of the circle
              height: 150, // Height of the circle
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Circular shape
                color: Colors.white, // Fill color of the circle
              ),
            ),
            CircularProgressIndicator(
              value: seconds / maxSec,
              valueColor:
                  AlwaysStoppedAnimation(Color.fromARGB(255, 121, 199, 122)),
              // valueColor:
              backgroundColor: Colors.white,
              strokeWidth: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTime(),
                Text(
                  "seconds remaining",
                  style: TextStyle(fontWeight: FontWeight.w400),
                )
              ],
            ),
          ],
        ),
      );

  Widget buildTime() {
    int minutes = (seconds / 60).toInt();
    int sec = seconds % 60;

    return Text(
      '$minutes:$sec',
      style: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 60,
      ),
    );
  }
}
