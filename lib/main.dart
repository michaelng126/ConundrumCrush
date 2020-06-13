import 'dart:async';
import 'dart:math';
import 'package:conundrum_crush/animatedWave.dart';
import 'package:conundrum_crush/wordDatabaseHelper.dart';
import 'package:flutter/material.dart';

import 'word.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conundrum Crush',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Conundrum Crush'),
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
  WordDatabaseHelper dbHelper;

  List<Word> _currentWord;
  String _currentDisplay = 'YXGLAA';
  bool _currentWordReady = false;

  List<Word> _nextWord;
  bool _nextWordReady = false;

  bool _altAnswerVisible = false;
  String _altAnswerDisplay = '';
  Color displayTextColor = Colors.white;

  bool givenUp = false;

  var _answerTextFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();

    dbHelper = WordDatabaseHelper.wordDbHelper;
    newWord().then((wordList) {
      _nextWordReady = true;
      _nextWord = wordList;
      newTurn();
    });
  }

  Future<List<Word>> newWord() async {
    return await dbHelper.getWordandAlts(8);
  }

  void newTurn() async {
    _currentWordReady = _nextWordReady;

    if (_currentWordReady) {
      // actually start turn
      _currentWord = _nextWord;
      _answerTextFieldController.clear();
      displayTextColor = Colors.white;
      _altAnswerVisible = false;
      givenUp = false;

      if (_currentWord == null) {
        _currentWord = [Word('No words :(')]; // TODO hack for no words
        print('No words found. Aborting!');
      } else {
        setState(() {
          String solution = _currentWord[0].toString();
          print('WORD FOUND! $solution');
          this._currentDisplay = _currentWord[0].displayScrambled();
        });
      }

      // prep the next word
      _nextWordReady = false;
      newWord().then((wordList) {
        _nextWordReady = true;
        _nextWord = wordList;

        if (!_currentWordReady) {
          newTurn(); // waiting on this
        }
      });
    }
  }

  String altAnswerString(List<Word> wordList) {
    String answerString = '';
    bool firstWord = true; // first word is not alternative
    for (var word in wordList) {
      if (firstWord) {
        firstWord = false;
      } else {
        answerString += ' or ' + word.toString();
      }
    }

    return answerString;
  }

  void verifyAnswer(String text) {
    if (givenUp) {return;}

    bool correct = false;
    for (var word in _currentWord) {
      if (word.toString().toLowerCase() == text.trim().toLowerCase()) {
        correct = true;
        break;
      }
    }
    if (correct) {
      setState(() {
        displayTextColor = Colors.green;
        giveUp();
      });
    }
  }

  void giveUp() {
    givenUp = true;

    setState(() {
      _currentDisplay = _currentWord[0].toString().toUpperCase();
      _altAnswerDisplay = altAnswerString(_currentWord);
      _altAnswerVisible = !(_altAnswerDisplay == '');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentWordReady) {
      return Stack(
        children: <Widget>[
          Positioned.fill(child: AnimatedBackground()),
          onBottom(AnimatedWave(
            height: 180,
            speed: 1.0,
          )),
          onBottom(AnimatedWave(
            height: 120,
            speed: 0.9,
            offset: pi,
          )),
          onBottom(AnimatedWave(
            height: 220,
            speed: 1.2,
            offset: pi / 2,
          )),
          Positioned.fill(child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body:
              Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                    ),
                    Text(
                      _currentDisplay,
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'Raleway',
                        color: displayTextColor,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Visibility(
                      visible: _altAnswerVisible,
                      child: Text(
                        _altAnswerDisplay,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Raleway',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 250.0,
                      child: TextField(
                        controller: _answerTextFieldController,
                        onChanged: verifyAnswer,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Answer'),
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Raleway',
                          color: Colors.white,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      child: new Text(
                        'Give Up',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Raleway',
                        ),
                      ),
                      color: Colors.red,
                      textColor: Colors.white,
                      onPressed: givenUp ? null : giveUp,
                    )
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: newTurn,
                tooltip: 'Give Up',
                child: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
        ],
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
      );
    }
  }

  onBottom(Widget child) => Positioned.fill(
    child: Align(
      alignment: Alignment.bottomCenter,
      child: child,
    ),
  );
}
