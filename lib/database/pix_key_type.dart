import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

const String _idColumn = 'id';
const String _pixKeyTypeColumn = 'pixKeyType';

enum EnumPixKeyType { none, cpf_cnpj, chave_aleatoria, telefone, email }

class PixKeyType {
  static const String pixKeyTypeTable = 'pixKeyTypeTable';

  static const String createPixKeyTypeTableSQL = 'CREATE TABLE IF NOT EXISTS $pixKeyTypeTable('
      '$_idColumn INTEGER PRIMARY KEY NOT NULL, '
      '$_pixKeyTypeColumn INT)';

/*
  List<String> typePixKeys = [
    'CPF',
    'CNPJ',
    'CHAVE_ALEATORIA',
    'CELULAR',
    'EMAIL',
  ];
*/
  int id = 0;
  String pixKeyType = "";

  PixKeyType();

  PixKeyType.fromMap(Map map) {
    id = map[_idColumn];
    pixKeyType = map[_pixKeyTypeColumn];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {_pixKeyTypeColumn: pixKeyType};

    if (id != 0) {
      map[_idColumn] = id;
    }
    return map;
  }

  /*
  Future<TypePixKey> saveTypeTransaction(TypePixKey typeTransaction, Database db) async {
    typeTransaction.id = await db.insert(typePixKeyTable, typeTransaction.toMap());
    return typeTransaction;
  }
*/

  Future<void> populatePixKeyTypeTable(Database db) async {
    await db.transaction((txn) async {
      int count = 0;
      List list = await txn.rawQuery('SELECT COUNT(*) FROM $pixKeyTypeTable');
      if (list.isNotEmpty) {
        count = list[0]['COUNT(*)'];
      }
      if (count == 0) {
        EnumPixKeyType.values.forEach((enumPixKeyType) async {
          if(enumPixKeyType != EnumPixKeyType.none) {
            await txn.rawInsert('INSERT INTO $pixKeyTypeTable($_pixKeyTypeColumn) VALUES("${describeEnum(enumPixKeyType)}")');
          }
        });
      }
    });
  }

  Future<List<PixKeyType>> getAllPixKeysType(Database db) async {
    List listMap = await db.rawQuery("SELECT * FROM $pixKeyTypeTable");
    List<PixKeyType> listTypeTransaction = [];
    for (Map m in listMap) {
      listTypeTransaction.add(PixKeyType.fromMap(m));
    }
    return listTypeTransaction;
  }

  @override
  String toString() {
    return "PixKeyType(id: $id, pixKeyType: $pixKeyType)";
  }
}
