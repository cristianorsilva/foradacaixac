import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

const String _idColumn = 'id';
const String _transactionTypeColumn = 'transactionType';

enum EnumTransactionType { None, Pix, Ted, Doc}

class TransactionType {

  static const String transactionTypeTable = 'transactionTypeTable';

  static const String createTransactionTypeTableSQL = 'CREATE TABLE IF NOT EXISTS $transactionTypeTable('
      '$_idColumn INTEGER PRIMARY KEY NOT NULL, '
      '$_transactionTypeColumn TEXT)';
/*
  List<String> typeTransactions = [
    "TRANSFERENCIA_PIX",
    "TRANSFERENCIA_TED",
    "TRANSFERENCIA_DOC",
    "RECEBIMENTO_PIX",
    "RECEBIMENTO_TED",
    "RECEBIMENTO_DOC"
  ];
*/
  int id = 0;
  String transactionType = "";

  TransactionType();

  TransactionType.fromMap(Map map) {
    id = map[_idColumn];
    transactionType = map[_transactionTypeColumn];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      _transactionTypeColumn: transactionType
    };

    if (id != 0) {
      map[_idColumn] = id;
    }
    return map;
  }

  Future<TransactionType> saveTypeTransaction(TransactionType transactionType, Database db) async {
    transactionType.id = await db.insert(transactionTypeTable, transactionType.toMap());
    return transactionType;
  }
/*
  Future<void> populateTypeTransactionTable(Database db) async {
    await db.transaction((txn) async {
      int count = 0;
      List list = await txn.rawQuery('SELECT COUNT(*) FROM $typeTransactionTable');
      if (list.isNotEmpty) {
        count = list[0]['COUNT(*)'];
      }
      if (count == 0) {
        typeTransactions.forEach((element) async {
          await txn.rawInsert('INSERT INTO $typeTransactionTable($_typeTransactionColumn) VALUES("$element")');
        });
      }
    });
  }
*/

  Future<TransactionType?> getTransactionType(String transactionType, Database db) async {
    List<Map> maps = await db.query(transactionTypeTable,
        columns: [_idColumn, _transactionTypeColumn],
        where: "$_transactionTypeColumn = ?",
        whereArgs: [transactionType]);
    if (maps.isNotEmpty) {
      return TransactionType.fromMap(maps.first);
    } else {
      return null;
    }
  }


  Future<void> populateTypeTransactionTable(Database db) async {
    await db.transaction((txn) async {
      int count = 0;
      List list = await txn.rawQuery('SELECT COUNT(*) FROM $transactionTypeTable');
      if (list.isNotEmpty) {
        count = list[0]['COUNT(*)'];
      }
      if (count == 0) {
        EnumTransactionType.values.forEach((enumTransactionType) async {
          if(enumTransactionType != EnumTransactionType.None) {
            await txn.rawInsert('INSERT INTO $transactionTypeTable($_transactionTypeColumn) VALUES("${describeEnum(enumTransactionType)}")');
          }
        });
      }
    });
  }







  Future<List> getAllTypeTransactions(Database db) async {
    List listMap = await db.rawQuery("SELECT * FROM $transactionTypeTable");
    List<TransactionType> listTransactionType = [];
    for (Map m in listMap) {
      listTransactionType.add(TransactionType.fromMap(m));
    }
    return listTransactionType;
  }

  @override
  String toString() {
    return "TransactionType(id: $id, transactionType: $transactionType)";
  }

}


