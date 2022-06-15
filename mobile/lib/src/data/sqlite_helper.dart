
import 'package:challenge_flutter/src/model/story.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class StoryDatabase {
  static final StoryDatabase instance = StoryDatabase._init();

  static Database? _database;

  StoryDatabase._init();


  List<String> lstStory = [
    '''A child asked his father, "How were people born?" So his father said, "Adam and Eve made babies, then their babies became adults and made babies, and so on."\nThe child then went to his mother, asked her the same question and she told him, "We were monkeys then we evolved to become like we are now."\nThe child ran back to his father and said, "You lied to me!" His father replied, "No, your mom was talking about her side of the family."
  ''',
    '''Teacher: "Kids,what does the chicken give you?" Student: "Meat!" Teacher: "Very good! Now what does the pig give you?" Student: "Bacon!" Teacher: "Great! And what does the fat cow give you?" Student: "Homework!"
    ''',
    '''The teacher asked Jimmy, "Why is your cat at school today Jimmy?" Jimmy replied crying, "Because I heard my daddy tell my mommy, 'I am going to eat that pussy once Jimmy leaves for school today!'"
    ''',
    '''A housewife, an accountant and a lawyer were asked "How much is 2+2?" The housewife replies: "Four!". The accountant says: "I think it's either 3 or 4. Let me run those figures through my spreadsheet one more time." The lawyer pulls the drapes, dims the lights and asks in a hushed voice, "How much do you want it to be?"
    '''
  ];
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute("""CREATE TABLE story(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        liked INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
  Future getData() async {
    List<Story> lst = [];
    lst = await getItems();
    if(lst.length==0){
      lstStory.forEach((element) {
        createItem(element, false);
      });
    }

  }
  // Read all items (journals)
  Future<List<Story>> getItems() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps =await db.query('story', orderBy: "id");
    return List.generate(maps.length, (i) {
      return Story.fromMap(maps[i]);
    });
  }
  // Create new item (journal)
  Future<int> createItem(String title, bool liked) async {
    final db = await instance.database;

    final data = {'title': title, 'liked': liked?1:0};
    final id = await db.insert('story', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }


  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await instance.database;
    return db.query('story', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  Future<int> updateItem(
      int id, String title, bool liked) async {
    final db = await instance.database;

    final data = {
      'title': title,
      'liked': liked?1:0,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('story', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  Future<void> deleteItem(int id) async {
    final db = await instance.database;
    try {
      await db.delete("story", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}