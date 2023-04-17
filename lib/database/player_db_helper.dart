import 'package:path/path.dart';
import 'package:team_maker/models/player_model.dart';
import 'package:sqflite/sqflite.dart';

class PlayerDBHelper {

  static const int _version = 1;
  static const String _dbName = "Players.db";

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async => await db.execute(
            "CREATE TABLE Players(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, rating INTEGER NOT NULL, gamesPlayed INTEGER, gamesWon INTEGER, isLiked BOOLEAN);"
        ),
        version: _version
    );
  }

  static Future<int> addPlayer(Player player) async {
    var db = await _getDB();
    return await db.insert('Players', player.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updatePlayer(Player player) async {
    var db = await _getDB();
    return await db.update('Players', player.toMap(), where: 'id = ?', whereArgs: [player.id], conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deletePlayer(Player player) async {
    var db = await _getDB();
    return await db.delete('Players', where: 'id = ?', whereArgs: [player.id]);
  }


  static Future<List<Player>?> getAllPlayers() async {
    var db = await _getDB();
    final List<Map<String, dynamic>> queryResult = await db.query('Players');

    if(queryResult.isEmpty) {
      return null;
    }

    return List.generate(queryResult.length, (index) => Player.fromMap(queryResult[index]));
  }
}
