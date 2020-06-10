import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'word.dart';

class WordDatabaseHelper {
  final String _DB_NAME = "words.db";
  final String _DB_TABLE_WORDS = "words";
  final String _DB_TABLE_ANAGRAM = "anagram";

  // The index (key) column name for use in where clauses
    final String _WORDS_ID = "_id";

    // Each Column
    final String _WORDS_WORD = "word";
    final String _WORDS_LENGTH = "length";
    //frequency will be contained in a string resource
    final String _WORDS_FREQUENCY = "frequency";
    final String _ANAGRAM_WORD1ID = "word1id";
    final String _ANAGRAM_WORD2ID = "word2id";

    Database _database;
    Context _context;

    WordDatabaseHelper(Context context) {
      setupDatabase();
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
      this._database = await openDatabase(path, readOnly: true);
    }

    List<Word> getWord (int number, int length) async {
      List<Word> returning = new List<Word>(number);
      Database db = this._database;

      List<Map<String, dynamic>> maps = await db.query(
        _DB_TABLE_WORDS,
        columns: [_WORDS_WORD,_WORDS_ID],
        where: '$_WORDS_LENGTH = ?',
        whereArgs: [length]
      );

      // TODO

    }


    List<Word> getWordandAlts(int length, String difficulty) {

    }
}

