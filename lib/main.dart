import 'dart:async';
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

  @override
  void initState() {
    super.initState();

    dbHelper = WordDatabaseHelper.wordDbHelper;
    firstWord().then((wordList){
      _currentWordReady = true;
      if (wordList == null) {
        print('No words found. Aborting!');
      } else {
        setState(() {
          String solution = wordList[0].toString();
          print('WORD FOUND! $solution');
          this._currentDisplay = wordList[0].displayScrambled();
        });
      }
    });
  }

  Future<List<Word>> firstWord() async {
    return await dbHelper.getWordandAlts(7);
  }

  // Prepares the next word.
  void newWord() async {
    _nextWordReady = false;
    _nextWord = await dbHelper.getWordandAlts(7); //TODO
    _nextWordReady = true;
  }

  void newTurn() async {
    _nextWord = await dbHelper.getWordandAlts(7);
    _currentWordReady = _nextWordReady;

    _currentWord = _nextWord;
    //beware of null
    if (_currentWord == null) {
      print('No words found. Aborting!');
      return;
    }
    print('Debug statement to show currentword is passing');
    setState(() {
      _currentDisplay = _currentWord[0].displayScrambled();
    });

    //prepare next word
    //newWord(); //TODO check this actually is async
  }

  @override
  Widget build(BuildContext context) {
    if (_currentWordReady) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 100,),
              Text(
                _currentDisplay,
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Raleway',
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: 250.0,
                child:TextField(
                    decoration: InputDecoration(
                    //border: OutlineInputBorder(),
                    labelText: 'Answer'),
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Raleway',
                    ),
                ),
              ),
              SizedBox(height: 20,),
              RaisedButton(
                child: new Text('Give Up',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Raleway',
                    ),
                  ),
                color: Colors.lightBlueAccent,
                textColor: Colors.black,
                onPressed: null,
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          tooltip: 'Give Up',
          child: Icon(Icons.eject),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
      );
    }

  }
}
