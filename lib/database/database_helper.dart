import 'package:foradacaixac/database/user_account.dart';
import 'package:foradacaixac/database/user_account_type.dart';
import 'package:foradacaixac/database/user_pix_key.dart';
import 'package:foradacaixac/database/user_remember.dart';
import 'package:foradacaixac/database/user_transaction.dart';
import 'package:foradacaixac/database/pix_key_type.dart';
import 'package:foradacaixac/database/transaction_type.dart';
import 'package:foradacaixac/database/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

const String nameDatabase = "Fintech";

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  late Database _db;

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, nameDatabase);

    return await openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: (db, version) async {
        await _onCreate(db, version);
      },
      onOpen:(db) async {
        await _onOpen(db);
      },
    );
  }

  Future<Database> get db async {
    _db = await initDb();
    return _db;
  }

  Future close() async {
    Database database = await db;
    database.close();
  }

  Future _onCreate(Database db, int version) async {
    await db.transaction((txn) async {
      txn.execute(User.createUserTableSQL);
      txn.execute(TransactionType.createTransactionTypeTableSQL);
      txn.execute(UserTransaction.createUserTransactionTableSQL);
      txn.execute(PixKeyType.createPixKeyTypeTableSQL);
      txn.execute(UserPixKey.createTypeTransactionTableSQL);
      txn.execute(UserRemember.createUserRememberTableSQL);
      txn.execute(UserAccountType.createUserAccountTypeTableSQL);
      txn.execute(UserAccount.createUserAccountTableSQL);
    });
  }

  Future _onOpen(Database db) async {
    await User().populateUser(db);
    await TransactionType().populateTypeTransactionTable(db);
    await PixKeyType().populatePixKeyTypeTable(db);
    await UserPixKey().populateUserPixKey(db);
    await UserAccountType().populateUserAccountTypeTable(db);
    await UserAccount().populateUserAccount(db);
  }

  _onConfigure(Database db) async {
    // Add support for cascade delete
    await db.execute("PRAGMA foreign_keys = ON");
  }



  Future populateDatabase() async{

    //initializes the database
    Database db = await DatabaseHelper().initDb();

     //run the scheduled transactions
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    List<UserTransaction> listUserTransaction =
    await UserTransaction().getAllScheduledTransactions(db);
    for (UserTransaction userTransaction in listUserTransaction) {
      print('Transaction scheduled: ${userTransaction.toString()}');
      if (DateTime.parse(formatter.format(DateTime.now()))
          .difference(
          DateTime.parse(userTransaction.dateHour.substring(0, 10)))
          .inDays >=
          0) {
        print('diferença de dias: ' +
            (DateTime.parse(formatter.format(DateTime.now())).difference(
                DateTime.parse(userTransaction.dateHour.substring(0, 10))))
                .inDays
                .toString());

        User? userFrom = await User().getUser(userTransaction.idUserFrom, db);
        User? userTo = await User().getUser(userTransaction.idUserTo, db);

        List<UserAccount> listUserAccountFrom = await UserAccount()
            .getAllUserAccountsFromUser(userTransaction.idUserFrom, db);
        List<UserAccount> listUserAccountTo = await UserAccount()
            .getAllUserAccountsFromUser(userTransaction.idUserTo, db);

        //new accountBalance for UserFrom
        listUserAccountFrom[0].accountBalance = num.parse(
            (listUserAccountFrom[0].accountBalance - userTransaction.value)
                .toStringAsFixed(2));
        //new accountBalance for UserTo
        listUserAccountTo[0].accountBalance = num.parse(
            (listUserAccountTo[0].accountBalance + userTransaction.value)
                .toStringAsFixed(2));

        await db.transaction((txn) async {
          //update accountBalance for UserFrom in database
          await UserAccount().updateUserAccountTXN(listUserAccountFrom[0], txn);
          //update accountBalance for UserTo in database
          await UserAccount().updateUserAccountTXN(listUserAccountTo[0], txn);
          //update the userTransaction register
          userTransaction.isScheduled = 0; //means it is not scheduled anymore
          userTransaction.dateHour = DateTime.now().toString();
          await UserTransaction().updateUserTransactionTXN(userTransaction, txn);
        });
        print('Transaction updated: ${userTransaction.toString()}');
      }
    }



  }



}
