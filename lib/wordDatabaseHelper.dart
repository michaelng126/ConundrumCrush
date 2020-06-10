
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