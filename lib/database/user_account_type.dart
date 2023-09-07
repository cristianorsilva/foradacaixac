
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

const String _idColumn = 'id';
const String _accountTypeColumn = 'accountType';

enum EnumAccountType { none, conta_poupanca, conta_corrente }

class UserAccountType {
  static const String userAccountTypeTable = 'userAccountTypeTable';

  static const String createUserAccountTypeTableSQL = 'CREATE TABLE IF NOT EXISTS $userAccountTypeTable('
      '$_idColumn INTEGER PRIMARY KEY NOT NULL, '
      '$_accountTypeColumn STRING)';

  int id = 0;
  String accountType = "";


  UserAccountType();

  UserAccountType.fromMap(Map map) {
    id = map[_idColumn];
    accountType = map[_accountTypeColumn];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      _accountTypeColumn: accountType,
    };

    if (id != 0) {
      map[_idColumn] = id;
    }
    return map;
  }

  Future<UserAccountType> saveUser(UserAccountType userAccountType, Database db) async {
    userAccountType.id = await db.insert(userAccountTypeTable, userAccountType.toMap());
    return userAccountType;
  }


  Future<void> populateUserAccountTypeTable(Database db) async {
    await db.transaction((txn) async {
      int count = 0;
      List list = await txn.rawQuery('SELECT COUNT(*) FROM $userAccountTypeTable');
      if (list.isNotEmpty) {
        count = list[0]['COUNT(*)'];
      }

      /*if (count == 0) {
        typePixKeys.forEach((element) async {
          await txn.rawInsert('INSERT INTO $typePixKeyTable($_typePixKeyColumn) VALUES("$element")');
        });
      }*/

      if (count == 0) {
        EnumAccountType.values.forEach((enumAccountType) async {
          if(enumAccountType != EnumAccountType.none) {
            await txn.rawInsert('INSERT INTO $userAccountTypeTable($_accountTypeColumn) VALUES("${describeEnum(enumAccountType)}")');
          }
        });
      }
    });
  }

  Future<List<UserAccountType>> getAllUserAccountTypes(Database db) async {
    List listMap = await db.rawQuery("SELECT * FROM $userAccountTypeTable");
    List<UserAccountType> listUserAccountType = [];
    for (Map m in listMap) {
      listUserAccountType.add(UserAccountType.fromMap(m));
    }
    return listUserAccountType;
  }

  @override
  String toString() {
    return "UserAccountType(id: $id, accountType: $accountType)";
  }





}