import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foradacaixac/presenters/login_not_remembered_view.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

import 'database/database_helper.dart';
import 'database/user.dart';
import 'database/user_account.dart';
import 'database/user_remember.dart';
import 'database/user_transaction.dart';
import 'design_system/theme_data/theme_data_fc.dart';

bool _userRemember = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initiateDatabase();
  initializeDateFormatting().then((_) => runApp(const MyApp()));
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.deepPurple,
  ));
}

Future<void> initiateDatabase() async {
  //Initialize database
  Database db = await DatabaseHelper().initDb();
  //print(await db.query("sqlite_master"));

  //get remembered user, if exists
  UserRemember? userRemember = await UserRemember().getUserRemember(db);
  if (userRemember == null || userRemember.remember == 0) {
    _userRemember = false;
  } else {
    _userRemember = true;
  }

  //TODO: criar método na database_helper com o bloco de codigo abaixo e utilizar em transições de tela
  //run the scheduled transactions
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  List<UserTransaction> listUserTransaction = await UserTransaction().getAllScheduledTransactions(db);
  for (UserTransaction userTransaction in listUserTransaction) {
    print('Transaction scheduled: ${userTransaction.toString()}');
    if (DateTime.parse(formatter.format(DateTime.now())).difference(DateTime.parse(userTransaction.dateHour.substring(0, 10))).inDays >= 0) {
      print('diferença de dias: ${(DateTime.parse(formatter.format(DateTime.now())).difference(DateTime.parse(userTransaction.dateHour.substring(0, 10)))).inDays}');

      User? userFrom = await User().getUser(userTransaction.idUserFrom, db);
      User? userTo = await User().getUser(userTransaction.idUserTo, db);

      List<UserAccount> listUserAccountFrom = await UserAccount().getAllUserAccountsFromUser(userTransaction.idUserFrom, db);
      List<UserAccount> listUserAccountTo = await UserAccount().getAllUserAccountsFromUser(userTransaction.idUserTo, db);

      //new accountBalance for UserFrom
      listUserAccountFrom[0].accountBalance = num.parse((listUserAccountFrom[0].accountBalance - userTransaction.value).toStringAsFixed(2));
      //new accountBalance for UserTo
      listUserAccountTo[0].accountBalance = num.parse((listUserAccountTo[0].accountBalance + userTransaction.value).toStringAsFixed(2));

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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fora da Caixa',
      theme: themeDataFC(),
      //home: const ForaDaCaixa(title: 'Flutter Demo Home Page'),
      home: const LoginNotRememberedView(),
    );
  }
}

class ForaDaCaixa extends StatefulWidget {
  const ForaDaCaixa({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<ForaDaCaixa> createState() => _ForaDaCaixaState();
}

class _ForaDaCaixaState extends State<ForaDaCaixa> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    //return MaterialApp(home: _userRemember ? LoginRememberedPage() : LoginNotRememberedView());
    return const MaterialApp(home: LoginNotRememberedView());
  }
}
