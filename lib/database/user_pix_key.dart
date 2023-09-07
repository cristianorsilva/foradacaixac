import 'package:flutter/foundation.dart';
import 'package:foradacaixac/database/pix_key_type.dart';
import 'package:foradacaixac/database/user.dart';
import 'package:sqflite/sqflite.dart';

const String _idColumn = 'id';
const String _idUserColumn = 'idUser';
const String _idTypePixKeyColumn = 'idPixKey';
const String _keyPixColumn = 'keyPix';

class UserPixKey {
  static const String userPixKeyTable = 'userPixKeyTable';

  static const String createTypeTransactionTableSQL = 'CREATE TABLE IF NOT EXISTS $userPixKeyTable('
      '$_idColumn INTEGER PRIMARY KEY NOT NULL, '
      '$_keyPixColumn TEXT, '
      '$_idUserColumn INTEGER, '
      '$_idTypePixKeyColumn INTEGER, '
      'FOREIGN KEY($_idUserColumn) REFERENCES ${User.userTable}($_idColumn), '
      'FOREIGN KEY($_idTypePixKeyColumn) REFERENCES ${PixKeyType.pixKeyTypeTable}($_idColumn))';

  int id = 0;
  int idUser = 0;
  int idTypePixKey = 0;
  String keyPix = "";

  UserPixKey();

  UserPixKey.fromMap(Map map) {
    id = map[_idColumn];
    idUser = map[_idUserColumn];
    idTypePixKey = map[_idTypePixKeyColumn];
    keyPix = map[_keyPixColumn];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      _idUserColumn: idUser,
      _idTypePixKeyColumn: idTypePixKey,
      _keyPixColumn: keyPix,
    };

    if (id != 0) {
      map[_idColumn] = id;
    }
    return map;
  }

  Future<UserPixKey> saveUserPixKey(UserPixKey userPixKey, Database db) async {
    userPixKey.id = await db.insert(userPixKeyTable, userPixKey.toMap());
    return userPixKey;
  }

  Future<List<UserPixKey>> getAllPixKeyFromUser(int userId, Database db) async {
    List<Map> maps = await db.query(userPixKeyTable,
        columns: [_idColumn, _idUserColumn, _idTypePixKeyColumn, _keyPixColumn], where: "$_idUserColumn = ?", whereArgs: [userId]);
    List<UserPixKey> listTransaction = [];

    for (Map m in maps) {
      listTransaction.add(UserPixKey.fromMap(m));
    }
    return listTransaction;
  }

  Future<UserPixKey?> getUserPixKeyByKey(String PixKeyValue, Database db) async {
    List<Map> maps = await db.query(userPixKeyTable,
        columns: [_idColumn, _idUserColumn, _idTypePixKeyColumn, _keyPixColumn], where: "$_keyPixColumn = ?", whereArgs: [PixKeyValue]);
     if (maps.isNotEmpty) {
      return UserPixKey.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<UserPixKey>> getAllPixKey(Database db) async {
    List<Map> maps = await db.query(userPixKeyTable,
        columns: [_idColumn, _idUserColumn, _idTypePixKeyColumn, _keyPixColumn]);
    List<UserPixKey> listTransaction = [];

    for (Map m in maps) {
      listTransaction.add(UserPixKey.fromMap(m));
    }
    return listTransaction;
  }

  Future<void> populateUserPixKey(Database db) async {
    print('Metodo populateUserPixKey');
    //chamadas fora do transaction pra evitar lock
    List<User> listUsers = await User().getAllUsers(db);
    List<PixKeyType> listTypePixKey = await PixKeyType().getAllPixKeysType(db);

    print('List users: $listUsers');
    print('List type pix key: $listTypePixKey');
    await db.transaction((txn) async {
      int count = 0;
      List list = await txn.rawQuery('SELECT COUNT(*) FROM $userPixKeyTable');
      if (list.isNotEmpty) {
        count = list[0]['COUNT(*)'];
      }
      if (count == 0) {
        listUsers.forEach((user) async {
          await txn.rawInsert('INSERT INTO $userPixKeyTable('
              '$_idUserColumn, $_idTypePixKeyColumn, $_keyPixColumn) VALUES'
              '(${user.id},${listTypePixKey.where((typePixKey) => typePixKey.pixKeyType == describeEnum(EnumPixKeyType.cpf_cnpj)).first.id}, "${user.document}")');
        });
      }
    });
  }

  Future<UserPixKey> insertNewUserPixKey(UserPixKey userPixKey, Database db) async{
    userPixKey.id = await db.insert(userPixKeyTable, userPixKey.toMap());
    return userPixKey;
  }



//The provided object "TypePixKey(id: 1, typePixKey: cpf_cnpj)" is not an enum.

  @override
  String toString() {
    return "UserPixKey(id: $id, idUser: $idUser, idTypePixKey: $idTypePixKey, keyPix: $keyPix)";
  }
}
