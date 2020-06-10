import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  Future<Database> _wordsDatabase;

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

void setupDatabase() async {
  var databasesPath = await getDatabasesPath();
  var path = join(databasesPath, "words.db");
  var exists = await databaseExists(path);

  if (!exists) {
    print("Creating new copy from asset");

    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    ByteData data = await rootBundle.load(join("assets", "words.db"));
    List<int> bytes =
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Write and flush the bytes written
    await File(path).writeAsBytes(bytes, flush: true);

  } else {
    print("Opening existing database");
  }

  // open the database
  _wordsDatabase = await openDatabase(path, readOnly: true);
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
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 100,),
            Text(
              'YGAXLA',
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
              onPressed: _incrementCounter,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Give Up',
        child: Icon(Icons.eject),
      ),
    );
  }
}
