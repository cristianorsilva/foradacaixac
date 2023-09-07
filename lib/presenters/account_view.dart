import 'package:flutter/material.dart';
import 'package:foradacaixac/presenters/transfer/transfer_receipt_view.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../database/user.dart';
import '../database/user_account.dart';
import '../database/user_transaction.dart';
import '../helper/utils.dart';
import 'package:intl/intl.dart';

import '../share/bottom_sheet_fc.dart';

class AccountView extends StatefulWidget {
  final User user;
  final List<UserAccount> listUserAccount;

  const AccountView({super.key, required this.user, required this.listUserAccount});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  List<UserTransaction> _listUserTransaction = [];
  final List<String> _listNameUserToByTransaction = [];

  @override
  void initState() {
    super.initState();
    populateTransactionList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Minha Conta', style: Theme.of(context).textTheme.headline2),
        ),
        body: Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.only(top: 30)),
                Text('Saldo em Conta Corrente', style: Theme.of(context).textTheme.headline4),
                const Padding(padding: EdgeInsets.only(top: 5)),
                Text(putCurrencyMask(widget.listUserAccount[0].accountBalance), style: Theme.of(context).textTheme.headlineLarge),
                const Padding(padding: EdgeInsets.only(top: 30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                      const Icon(Icons.savings_rounded),
                      const Padding(padding: EdgeInsets.only(left: 15)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Saldo em Conta Poupança', style: Theme.of(context).textTheme.headline4),
                          const Padding(padding: EdgeInsets.only(top: 5)),
                          const Text('R\$ 825,69', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ]),
                    const Icon(Icons.arrow_forward_ios_rounded),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 25),
                ),
                Text(
                  'Histórico',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 25),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: Theme.of(context).disabledColor,
                      ),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).disabledColor)),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                      isDense: true,
                      hintText: 'Buscar',
                      floatingLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
                      hintStyle: TextStyle(
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 25),
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _listUserTransaction.length,
                  itemBuilder: (context, index) {
                    return _transactionItem(index);
                  },
                ),
              ],
            ))));
  }

  Widget _transactionItem(int index) {
    return Column(children: [
      InkWell(
        onTap: () async {
          Database db = await DatabaseHelper().initDb();

          UserTransaction userTransaction = _listUserTransaction[index];
          User? userFrom = await User().getUser(userTransaction.idUserFrom, db);
          User? userTo = await User().getUser(userTransaction.idUserTo, db);

          if(!mounted) return;
          showModalBottom(
              TransferReceiptView(
                userTransaction: userTransaction,
                userFrom: userFrom!,
                userTo: userTo!,
                fromAccountView: true,
              ),
              context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                defineIcon(index),
                const Padding(
                  padding: EdgeInsets.only(right: 15),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 15),
                    ),
                    defineOperationDescription(index),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 5),
                    ),
                    Text(
                      _listNameUserToByTransaction.isNotEmpty ? _listNameUserToByTransaction[index] : 'Erro',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(putCurrencyMask(_listUserTransaction[index].value), style: Theme.of(context).textTheme.headline6),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                    ),
                  ],
                ),
              ],
            ),
            Text(convertDateToBrazilianFormat(DateTime.parse(_listUserTransaction[index].dateHour)), style: Theme.of(context).textTheme.headline6),

            //TODO: adicionar gesture detector
            //TODO: não atualizou o isScheduled com o app aberto
          ],
        ),
      ),
      const Divider(
        height: 0,
        color: Colors.deepPurpleAccent,
      ),
    ]);
  }

  Future<void> populateTransactionList() async {
    Database db = await DatabaseHelper().initDb();
    _listUserTransaction = await UserTransaction().getAllTransactionsFromAndToUser(widget.user.id, db);
    orderListByScheduled();
    for (UserTransaction userTransaction in _listUserTransaction) {
      User? user = await User().getUser(userTransaction.idUserTo, db);
      _listNameUserToByTransaction.add(user!.name);
    }
    ;
    setState(() {});
  }

  void orderListByScheduled() {
    _listUserTransaction.sort((a, b) {
      if ((a.isScheduled == 1) && !(b.isScheduled == 0)) {
        return -1;
      } else if (!(a.isScheduled == 1) && (a.isScheduled == 0)) {
        return 1;
      } else {
        return 0;
      }
    });
  }

  Text defineOperationDescription(int index) {
    Text defineText;
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    if (widget.user.id == _listUserTransaction[index].idUserFrom) {
      DateTime dateTimeNow = DateTime.now();
      if (DateTime.parse(formatter.format(DateTime.now())).difference(DateTime.parse(_listUserTransaction[index].dateHour.substring(0, 10))).inDays >=
          0) {
        defineText = Text('Transferência enviada', style: Theme.of(context).textTheme.headline5);
      } else {
        defineText = Text('Transferência agendada', style: Theme.of(context).textTheme.headline5);
      }
    } else {
      if (DateTime.parse(formatter.format(DateTime.now())).difference(DateTime.parse(_listUserTransaction[index].dateHour.substring(0, 10))).inDays >=
          0) {
        defineText = Text('Transferência recebida', style: Theme.of(context).textTheme.headline5);
      } else {
        defineText = Text('Transferência a ser recebida', style: Theme.of(context).textTheme.headline5);
      }
    }
    return defineText;
  }

  Icon defineIcon(int index) {
    Icon defineIcon;
    if (widget.user.id == _listUserTransaction[index].idUserFrom) {
      DateFormat formatter = DateFormat('dd/MM/yyyy');
      defineIcon = const Icon(Icons.call_made_rounded);
    } else {
      defineIcon = const Icon(Icons.call_received_rounded);
    }
    return defineIcon;
  }
}
