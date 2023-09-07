import 'package:sqflite/sqflite.dart';
import 'package:foradacaixac/database/user.dart';

const String _idColumn = 'id';
const String _idUserColumn = 'idUser';
const String _rememberColumn = 'remember';


class UserRemember{
  static const String userRememberTable = 'userRememberTable';

  static const String createUserRememberTableSQL = 'CREATE TABLE IF NOT EXISTS $userRememberTable('
      '$_idColumn INTEGER PRIMARY KEY NOT NULL, '
      '$_idUserColumn INTEGER, '
      '$_rememberColumn INTEGER, '
      'FOREIGN KEY($_idUserColumn) REFERENCES ${User.userTable}($_idColumn))';

  int id = 0;
  int idUser = 0;
  int remember = 0;

  UserRemember();

  UserRemember.fromMap(Map map) {
    id = map[_idColumn];
    idUser = map[_idUserColumn];
    remember = map[_rememberColumn];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      _idUserColumn: idUser,
      _idUserColumn: idUser,
      _rememberColumn: remember,
    };

    if (id != 0) {
      map[_idColumn] = id;
    }
    return map;
  }


  Future<UserRemember> saveUserRemember(UserRemember userRemember, Database db) async {
    userRemember.id = await db.insert(userRememberTable, userRemember.toMap());
    return userRemember;
  }

  Future<int> updateUserRemember(UserRemember userRemember, Database db) async {
    return await db.update(userRememberTable, userRemember.toMap(),
        where: "$_idColumn = ?", whereArgs: [userRemember.id]);
  }

  Future<UserRemember?> getUserRemember(Database db) async {
    List<Map> maps = await db.query(userRememberTable,
        columns: [_idColumn, _idUserColumn, _rememberColumn]);
    if (maps.isNotEmpty) {
      return UserRemember.fromMap(maps.first);
    } else {
      return null;
    }
  }

  @override
  String toString() {
    return "UserRemember(id: $id, idUser: $idUser, remember: $remember)";
  }

}