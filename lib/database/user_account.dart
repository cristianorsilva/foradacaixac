import 'package:foradacaixac/database/user.dart';
import 'package:foradacaixac/database/user_account_type.dart';
import 'package:sqflite/sqflite.dart';

const String _idColumn = 'id';
const String _idUserColumn = 'idUser';
const String _idAccountTypeColumn = 'idAccountType';
const String _accountBalanceColumn = 'accountBalance';

class UserAccount {
  static const String userAccountTable = 'userAccountTable';

  static const String createUserAccountTableSQL = 'CREATE TABLE IF NOT EXISTS $userAccountTable('
      '$_idColumn INTEGER PRIMARY KEY NOT NULL, '
      '$_idUserColumn INTEGER, '
      '$_idAccountTypeColumn INTEGER, '
      '$_accountBalanceColumn REAL, '
      'FOREIGN KEY ($_idUserColumn) REFERENCES ${User.userTable} ($_idColumn), '
      'FOREIGN KEY ($_idAccountTypeColumn) REFERENCES ${UserAccountType.userAccountTypeTable} ($_idColumn))';

  int id = 0;
  int idUser = 0;
  int accountType = 0;
  num accountBalance = 0.0;

  UserAccount();

  UserAccount.fromMap(Map map) {
    id = map[_idColumn];
    idUser = map[_idUserColumn];
    accountType = map[_idAccountTypeColumn];
    accountBalance = map[_accountBalanceColumn];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      _idUserColumn: idUser,
      _idAccountTypeColumn: accountType,
      _accountBalanceColumn: accountBalance,
    };

    if (id != 0) {
      map[_idColumn] = id;
    }
    return map;
  }

  Future<UserAccount> saveUser(UserAccount userAccount, Database db) async {
    userAccount.id = await db.insert(userAccountTable, userAccount.toMap());
    return userAccount;
  }

  Future<UserAccount?> getUser(int id, Database db) async {
    List<Map> maps = await db.query(userAccountTable,
        columns: [
          _idColumn,
          _idUserColumn,
          _idAccountTypeColumn,
          _accountBalanceColumn,
        ],
        where: "$_idColumn = ?",
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return UserAccount.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<UserAccount>> getAllUserAccountsFromUser(int id, Database db) async {
    List<UserAccount> listUserAccount = [];
    List<Map> listMap = await db.query(userAccountTable,
        columns: [
          _idColumn,
          _idUserColumn,
          _idAccountTypeColumn,
          _accountBalanceColumn,
        ],
        where: "$_idColumn = ?",
        whereArgs: [id]);
    for (Map m in listMap) {
      listUserAccount.add(UserAccount.fromMap(m));
    }
    return listUserAccount;
  }

  Future<int> updateUserAccount(UserAccount userAccount, Database db) async {
    return await db.update(userAccountTable, userAccount.toMap(), where: "$_idColumn = ?", whereArgs: [userAccount.id]);
  }

  Future<int> updateUserAccountTXN(UserAccount userAccount, Transaction txn) async {
    return await txn.update(userAccountTable, userAccount.toMap(), where: "$_idColumn = ?", whereArgs: [userAccount.id]);
  }

  Future<List<UserAccount>> getAlUserAccounts(Database db) async {
    List listMap = await db.rawQuery("SELECT * FROM $userAccountTable");
    List<UserAccount> listUserAccount = [];
    for (Map m in listMap) {
      listUserAccount.add(UserAccount.fromMap(m));
    }
    return listUserAccount;
  }

  Future<void> populateUserAccount(Database db) async {
    List<User> listUsers = await User().getAllUsers(db);
    List<UserAccountType> listUserAccountTypes = await UserAccountType().getAllUserAccountTypes(db);

    await db.transaction((txn) async {
      int countUserAccount = 0;
      List listUserAccount = await txn.rawQuery('SELECT COUNT(*) FROM $userAccountTable');
      if (listUserAccount.isNotEmpty) {
        countUserAccount = listUserAccount[0]['COUNT(*)'];
      }

      if (countUserAccount == 0) {
        listUsers.forEach((user) async {
          listUserAccountTypes.forEach((userAccountType) async {
            await txn.rawInsert('INSERT INTO $userAccountTable('
                '$_idUserColumn, $_idAccountTypeColumn, $_accountBalanceColumn) VALUES'
                '(${user.id},${userAccountType.id}, 5600.00)');
          });
        });
      }
    });
  }

  @override
  String toString() {
    return "UserAccount(id: $id, idUser: $idUser, accountType: $accountType, accountBalance: $accountBalance)";
  }
}
