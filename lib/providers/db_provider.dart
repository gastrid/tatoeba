import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:tatoeba_trainer/models/flashcardSentence.dart';

import 'package:sqflite/sqflite.dart';

import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:tatoeba_trainer/models/sentence.dart';

class DbProvider extends ChangeNotifier {
  static final DbProvider _instance = new DbProvider.internal();
  factory DbProvider() => _instance;
  static final Completer<void> _completer = Completer<void>();

  late final String _dbPath;

  DbProvider.internal() {
    _initDb();
  }

  Future<void> get initialization => _completer.future;

  Future<void> _initDb() async {
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, "sentences.db");

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "sentences.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    }
    _dbPath = path;
    _completer.complete();
  }

  Future<Database> openDb() async {
    var db = await openDatabase(_dbPath);
    return db;
  }


  static const target_table = "targets";
  static const source_table = "sources";
  // TODO: convert all to this system
  static const page_size = 10;

  final Map<String, String> language_map = {"russian": "ru", "chinese": "cn"};

  late String path;

  List<FlashcardSentence> saved_sentences = [];
  List<FlashcardSentence> search_sentences = [];

  var saved_sentence_count = 0;
  var search_sentence_count = 0;

  Future<bool> getSaved(String language, bool erase, {int limit = 10}) async {
    if (erase) {
      saved_sentences = [];
    }
    bool hasMore = true;
    final start = DateTime.now().millisecondsSinceEpoch;
    var db = await openDb();
    await db.rawQuery("""
    select 
      sources.id as source_id,
      sources.sentence as source_sentence,
      targets.id as target_id,
      targets.sentence as target_sentence
    from sources join targets on sources.id = targets.source_ID
    where 
      targets.hide=0 and
      targets.saved=1 and
      targets.lang='${language_map[language]}'
    order by 
      sources.id 
    limit ${limit}
    offset ${saved_sentences.length};
      """).then((value) {
      final timeElapsted = DateTime.now().millisecondsSinceEpoch - start;
      print("time elapsed ${timeElapsted}");
      if (value.length < limit) {
        hasMore = false;
      }
      value.forEach((element) {
        saved_sentences.add(FlashcardSentence(
            key: element["source_id"] as int,
            source: SourceSentence(
              id: element["source_id"] as int,
              sentence: element["source_sentence"] as String,
            ),
            target: TargetSentence(
              id: element["target_id"] as int,
              lang: language,
              sentence: element["target_sentence"] as String,
            )));
      });
    });
    saved_sentence_count = saved_sentences.length;
    db.close();
    notifyListeners();
    return hasMore;
  }

  Future<List<FlashcardSentence>> getRandom(String language, int limit,
      {bool saved = false, bool hide = false}) async {
    List<FlashcardSentence> sentences = [];

    final start = DateTime.now().millisecondsSinceEpoch;
    var db = await openDb();
    await db.rawQuery("""
    select 
      sources.id as source_id,
      sources.sentence as source_sentence,
      targets.id as target_id,
      targets.sentence as target_sentence
    from sources join targets on sources.id = targets.source_ID
    where 
      targets.hide=${hide ? 1 : 0} and
      targets.saved=${saved ? 1 : 0} and
      targets.lang='${language_map[language]}' 
    order by 
      random() limit ${limit};
      """).then((value) {
      final timeElapsted = DateTime.now().millisecondsSinceEpoch - start;
      print("time elapsed ${timeElapsted}");
      value.forEach((element) {
        sentences.add(FlashcardSentence(
            key: element["source_id"] as int,
            source: SourceSentence(
              id: element["source_id"] as int,
              sentence: element["source_sentence"] as String,
            ),
            target: TargetSentence(
              id: element["target_id"] as int,
              lang: language,
              sentence: element["target_sentence"] as String,
            )));
      });
    });

    db.close();
    return sentences;
  }

  Future<bool> searchEnglish(String language, String searchString, bool erase,
      {int limit = 10}) async {

    print("erase: ${erase}");

    if (erase) {
      search_sentences = [];
    }
    bool hasMore = true;

    // TODO: add pagination
    final start = DateTime.now().millisecondsSinceEpoch;
    var db = await openDb();
    await db.rawQuery("""
    select
      sources.id as source_id,
      targets.id as target_id,
      sources.sentence as source_sentence,
      targets.sentence as target_sentence
    from
      sources
      join targets on targets.source_id = sources.id
    where
      targets.lang = '${language_map[language]}'
      and sources.sentence like "%${searchString}%"
    limit
      ${limit}
    offset
      ${search_sentences.length};

      """).then((value) {
      final timeElapsted = DateTime.now().millisecondsSinceEpoch - start;
      print("time elapsed ${timeElapsted}");
      if (value.length < limit) {
        hasMore = false;
      }
      value.forEach((element) {
        search_sentences.add(FlashcardSentence(
            key: element["source_id"] as int,
            source: SourceSentence(
              id: element["source_id"] as int,
              sentence: element["source_sentence"] as String,
            ),
            target: TargetSentence(
              id: element["target_id"] as int,
              lang: language,
              sentence: element["target_sentence"] as String,
            )));
      });
    });
    search_sentence_count = search_sentences.length;
    print(search_sentences);
    db.close();
    notifyListeners();
    return hasMore;
  }

  Future<void> saveSentence(int id) async {
    var db = await openDb();
    await db
        .rawUpdate("update targets set saved=1 where id=${id};"); // PICKUP HERE
    db.close();

  }

  Future<void> unsaveSentence(int id) async {
    var db = await openDb();
    await db
        .rawUpdate("update targets set saved=0 where id=${id};"); // PICKUP HERE
    db.close();

  }

  Future<void> hideSentence(int id) async {
    var db = await openDb();
    await db
        .rawUpdate("update targets set hide=1 where id=${id};"); // PICKUP HERE
    db.close();

  }

  Future<void> unhideSentence(int id) async {
    var db = await openDb();
    await db
        .rawUpdate("update targets set hide=0 where id=${id};"); // PICKUP HERE
    db.close();

  }
}
