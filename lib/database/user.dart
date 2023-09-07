import 'package:sqflite/sqflite.dart';

const String _idColumn = 'id';
const String _nameColumn = 'name';
const String _agencyColumn = 'agency';
const String _accountColumn = 'account';
const String _documentColumn = 'document';
//const String _accountBalanceColumn = 'accountBalance';
const String _passwordAppColumn = 'passwordApp';
const String _pinColumn = 'pin';
const String _bankNameColumn = 'bankName';

class User {
  static const String userTable = 'userTable';

  static const String createUserTableSQL = 'CREATE TABLE IF NOT EXISTS $userTable('
      '$_idColumn INTEGER PRIMARY KEY NOT NULL, '
      '$_nameColumn TEXT, '
      '$_agencyColumn TEXT, '
      '$_accountColumn TEXT, '
      '$_documentColumn TEXT NOT NULL UNIQUE, '

      '$_passwordAppColumn TEXT, '
      '$_pinColumn TEXT, '
      '$_bankNameColumn)';
//      '$_accountBalanceColumn REAL, '
  int id = 0;
  String name = "";
  String agency = "";
  String account = "";
  String document = "";
  //num accountBalance = 0.0;
  String passwordApp = "";
  String pin = "";
  String bankName = "";

  User();

  User.fromMap(Map map) {
    id = map[_idColumn];
    name = map[_nameColumn];
    agency = map[_agencyColumn];
    account = map[_accountColumn];
    document = map[_documentColumn];
    //accountBalance = map[_accountBalanceColumn];
    passwordApp = map[_passwordAppColumn];
    pin = map[_pinColumn];
    bankName = map[_bankNameColumn];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      _nameColumn: name,
      _agencyColumn: agency,
      _accountColumn: account,
      _documentColumn: document,
      //_accountBalanceColumn: accountBalance,
      _passwordAppColumn: passwordApp,
      _pinColumn: pin,
      _bankNameColumn: bankName,
    };

    if (id != 0) {
      map[_idColumn] = id;
    }
    return map;
  }

  Future<User> saveUser(User user, Database db) async {
    user.id = await db.insert(userTable, user.toMap());
    return user;
  }

  Future<User?> getUser(int id, Database db) async {
    List<Map> maps = await db.query(userTable,
        columns: [
          _idColumn,
          _nameColumn,
          _agencyColumn,
          _accountColumn,
          _documentColumn,

          _passwordAppColumn,
          _pinColumn,
          _bankNameColumn
        ],
        where: "$_idColumn = ?",
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }
//          _accountBalanceColumn,
  Future<User> getUserByDocumentAndPassword(String document, String password, Database db) async {
    List<Map> maps = await db.query(userTable,
        columns: [
          _idColumn,
          _nameColumn,
          _agencyColumn,
          _accountColumn,
          _documentColumn,

          _passwordAppColumn,
          _pinColumn,
          _bankNameColumn
        ],
        where: "$_documentColumn = ? AND $_passwordAppColumn = ?",
        whereArgs: [document, password]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return User();
    }
  }
//          _accountBalanceColumn,
  Future<int> deleteUser(int id, Database db) async {
    return await db.delete(userTable, where: "$_idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateUser(User user, Database db) async {
    return await db.update(userTable, user.toMap(), where: "$_idColumn = ?", whereArgs: [user.id]);
  }

  Future<List<User>> getAllUsers(Database db) async {
    List listMap = await db.rawQuery("SELECT * FROM $userTable");
    List<User> listUser = [];
    for (Map m in listMap) {
      listUser.add(User.fromMap(m));
    }
    return listUser;
  }

  Future<void> populateUser(Database db) async {
    await db.transaction((txn) async {
      int count = 0;
      List list = await txn.rawQuery('SELECT COUNT(*) FROM $userTable');
      if (list.isNotEmpty) {
        count = list[0]['COUNT(*)'];
      }
      if (count == 0) {
        await txn.rawInsert('INSERT INTO $userTable('
            '$_nameColumn, $_agencyColumn, $_accountColumn, $_documentColumn, $_passwordAppColumn, $_pinColumn, $_bankNameColumn) VALUES'
            '("João Carlos da Silva","0124-5", "12452-6", "929.035.400-39", "172839", "1728", "CrediBank")');

        await txn.rawInsert('INSERT INTO $userTable('
            '$_nameColumn, $_agencyColumn, $_accountColumn, $_documentColumn, $_passwordAppColumn, $_pinColumn, $_bankNameColumn) VALUES'
            '("Marcos Gomes de Freitas","0584-3", "75951-8", "050.209.090-17", "172839", "1728", "Ultrabank")');

        await txn.rawInsert('INSERT INTO $userTable('
            '$_nameColumn, $_agencyColumn, $_accountColumn, $_documentColumn, $_passwordAppColumn, $_pinColumn, $_bankNameColumn) VALUES'
            '("Joana Ferreira Schimidt","2258-4", "32542-3", "971.147.000-40", "172839", "1728", "Banco Solar")');
      }
    });
  }

  @override
  String toString() {
    return "User(id: $id, name: $name, agency: $agency, account: $account, document: $document, passwordApp: $passwordApp, pin: $pin, bankName: $bankName)";
  }
}
