import 'dart:async';
import 'dart:math';
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

    WordDatabaseHelper() {
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

    /// @param length Length of the word
    /// @return Random word from the database.
    /// @description Beware of the null; must handle it carefully!
    Future<List<Word>> getWordandAlts(int length) async {
      Database db = this._database;

      List<Map<String, dynamic>> maps = await db.query(
        _DB_TABLE_WORDS,
        columns: [_WORDS_WORD,_WORDS_ID],
        where: '$_WORDS_LENGTH = $length', // AND $difficulty',
      );

      // intended behaviour to repeat if not enough words
      final _random = new Random();
      final _randInt = _random.nextInt(maps.length);
      print('Test query') //TODO
      Word word = Word(maps[_randInt][_WORDS_WORD]);
      int wordId = maps[_randInt][_WORDS_ID];
      print('Successfully CAST. Maps happy.'); //TODO

      return getAlternatives(word, wordId);
    }

    /// @param id Id of the word in the words table
    /// @return alternatives of the word found at id, first word being the original.
    Future<List<Word>> getAlternatives(Word word, int id) async {
        Database db = this._database;
        String query = "SELECT $_DB_TABLE_WORDS.$_WORDS_WORD FROM $_DB_TABLE_ANAGRAM LEFT JOIN $_DB_TABLE_WORDS ON $_DB_TABLE_ANAGRAM.$_ANAGRAM_WORD2ID=$_DB_TABLE_WORDS.$_WORDS_ID WHERE $_DB_TABLE_ANAGRAM.$_ANAGRAM_WORD1ID=$id";

        List<Map<String,dynamic>> maps = await db.rawQuery(query);
        List<Word> altWords = List.generate(maps.length, (index) => Word(maps[index][_WORDS_WORD]));

        altWords.insert(0, word);
        return altWords;
    }
}

