import 'package:foradacaixac/database/transaction_type.dart';
import 'package:foradacaixac/database/user.dart';
import 'package:sqflite/sqflite.dart';

const String _idColumn = 'id';
const String _idUserFromColumn = 'idUserFrom';
const String _idUserToColumn = 'idUserTo';
const String _idTransactionTypeColumn = 'idTypeTransaction';
const String _valueColumn = 'value';
const String _dateHourColumn = 'dateHour';
const String _isScheduledColumn = 'isScheduled';

class UserTransaction {
  static const String userTransactionTable = 'userTransactionTable';

  static const String createUserTransactionTableSQL = 'CREATE TABLE IF NOT EXISTS $userTransactionTable('
      '$_idColumn INTEGER PRIMARY KEY NOT NULL, '
      '$_idUserFromColumn INTEGER NOT NULL, '
      '$_idUserToColumn INTEGER NOT NULL, '
      '$_idTransactionTypeColumn INTEGER NOT NULL, '
      '$_valueColumn REAL, '
      '$_dateHourColumn TEXT, '
      '$_isScheduledColumn INTEGER NOT NULL, '
      'FOREIGN KEY ($_idUserFromColumn) REFERENCES ${User.userTable} ($_idColumn), '
      'FOREIGN KEY ($_idUserToColumn) REFERENCES ${User.userTable} ($_idColumn), '
      'FOREIGN KEY ($_idTransactionTypeColumn) REFERENCES ${TransactionType.transactionTypeTable} ($_idColumn))';

  int id = 0;
  int idUserFrom = 0;
  int idUserTo = 0;
  int idTransactionType = 0;
  num value = 0.0;
  String dateHour = "";
  int isScheduled = 0;

  UserTransaction();
  //UserTransaction({ this.id, this.idUserFrom, this.idUserTo,  this.idTypeTransaction,  this.value,  this.dateHour});

  UserTransaction.fromMap(Map map) {
    id = map[_idColumn];
    idUserFrom = map[_idUserFromColumn];
    idUserTo = map[_idUserToColumn];
    idTransactionType = map[_idTransactionTypeColumn];
    value = map[_valueColumn];
    dateHour = map[_dateHourColumn];
    isScheduled = map[_isScheduledColumn];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      _idUserFromColumn: idUserFrom,
      _idUserToColumn: idUserTo,
      _idTransactionTypeColumn: idTransactionType,
      _valueColumn: value,
      _dateHourColumn: dateHour,
      _isScheduledColumn: isScheduled
    };

    if (id != 0) {
      map[_idColumn] = id;
    }
    return map;
  }

  Future<UserTransaction> saveUserTransaction(UserTransaction userTransaction, Database db) async {
    userTransaction.id = await db.insert(userTransactionTable, userTransaction.toMap());
    return userTransaction;
  }

  Future<UserTransaction> saveUserTransactionTXN(UserTransaction userTransaction, Transaction txn) async {
    userTransaction.id = await txn.insert(userTransactionTable, userTransaction.toMap());
    return userTransaction;
  }

  Future<int> updateUserTransactionTXN(UserTransaction userTransaction, Transaction txn) async {
    return await txn.update(userTransactionTable, userTransaction.toMap(), where: "$_idColumn = ?", whereArgs: [userTransaction.id]);
  }


  Future<UserTransaction?> getTransaction(int id, Database db) async {
    List<Map> maps = await db.query(userTransactionTable,
        columns: [_idColumn, _idUserFromColumn, _idUserToColumn, _idTransactionTypeColumn, _valueColumn, _dateHourColumn, _isScheduledColumn],
        where: "$_idColumn = ?",
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return UserTransaction.fromMap(maps.first);
    } else {
      return null;
    }
  }



  Future<List<UserTransaction>> getAllTransactionsFromAndToUser(int userId, Database db) async {
    List<Map> maps = await db.query(userTransactionTable,
        columns: [_idColumn, _idUserFromColumn, _idUserToColumn, _idTransactionTypeColumn, _valueColumn, _dateHourColumn, _isScheduledColumn],
        where: "$_idUserFromColumn = ? OR $_idUserToColumn = ?",
        whereArgs: [userId, userId]);
    List<UserTransaction> listTransaction = [];

    for (Map m in maps) {
      listTransaction.add(UserTransaction.fromMap(m));
    }
    return listTransaction;
  }

  Future<List<UserTransaction>> getAllScheduledTransactions(Database db) async {
    List<Map> maps = await db.query(userTransactionTable,
        columns: [_idColumn, _idUserFromColumn, _idUserToColumn, _idTransactionTypeColumn, _valueColumn, _dateHourColumn, _isScheduledColumn],
        where: "$_isScheduledColumn = 1");
    List<UserTransaction> listTransaction = [];

    for (Map m in maps) {
      listTransaction.add(UserTransaction.fromMap(m));
    }
    return listTransaction;
  }

  @override
  String toString() {
    return "UserTransaction(id: $id, userFrom: $idUserFrom, userTo: $idUserTo, transactionType: $idTransactionType, value: $value, dateHour: $dateHour, isScheduled: $isScheduled)";
  }
}
