import 'dart:math';

import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foradacaixac/design_system/visibility/visibility_loading_fc.dart';
import 'package:foradacaixac/design_system/visibility/visibility_shadow_fc.dart';
import 'package:foradacaixac/presenters/transfer/schedule_view.dart';
import 'package:foradacaixac/presenters/transfer/transfer_receipt_view.dart';
import 'package:foradacaixac/presenters/transfer/transfer_value_update_view.dart';
import 'package:sqflite/sqflite.dart';

import '../../database/database_helper.dart';
import '../../database/transaction_type.dart';
import '../../database/user.dart';
import '../../database/user_account.dart';
import '../../database/user_pix_key.dart';
import '../../database/user_transaction.dart';
import 'package:intl/intl.dart';

import '../../helper/utils.dart';
import '../../share/bottom_sheet_fc.dart';

class VerifyDataView extends StatefulWidget {
  final UserTransaction userTransaction;
  final UserPixKey userPixKey;
  final User userFrom;
  final List<UserAccount> listUserAccount;
  final String pageTitle;

  const VerifyDataView(
      {super.key,
      required this.userTransaction,
      required this.userPixKey,
      required this.userFrom,
      required this.listUserAccount,
      required this.pageTitle});

  @override
  State<VerifyDataView> createState() => _VerifyDataViewState();
}

class _VerifyDataViewState extends State<VerifyDataView> {
  String _paymentDate = "Agora";
  User? _userTo = User();
  final GlobalKey _keyMainColumn = GlobalKey();
  bool _loadingIsVisible = false;

  @override
  void initState() {
    super.initState();
    populateUserTo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
          title: Text(widget.pageTitle, style: Theme.of(context).textTheme.headline2),
        ),
        body: SingleChildScrollView(
            key: const Key('singleChildScrowViewMain'),
            child: Stack(
              children: [
                Column(key: _keyMainColumn, children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          'Transferindo',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 10)),
                        _gestureDetectorTransfering(),
                        const Padding(padding: EdgeInsets.only(bottom: 10)),
                        Text(
                          _userTo!.name,
                          key: const Key('textRecipientFullUserName'),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 30)),
                        const Divider(
                          height: 0,
                          color: Colors.deepPurpleAccent,
                        ),
                        _inkWellTransferenceWhen(),
                        const Divider(
                          height: 0,
                          color: Colors.deepPurpleAccent,
                        ),
                        _containerTransferenceType(),
                        const Divider(
                          height: 0,
                          color: Colors.deepPurpleAccent,
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 15.0)),
                        _rowDocumentData(),
                        const Padding(padding: EdgeInsets.only(bottom: 15.0)),
                        _rowBankNameData(),
                        const Padding(padding: EdgeInsets.only(bottom: 15.0)),
                        _rowAgencyData(),
                        const Padding(padding: EdgeInsets.only(bottom: 15.0)),
                        _rowAccountNumberData(),
                        const Padding(padding: EdgeInsets.only(bottom: 15.0)),
                      ])),
                  const Padding(padding: EdgeInsets.only(bottom: 70.0))
                ]),
                VisibilityShadowFC(isVisible: _loadingIsVisible),
                VisibilityLoadingFC(isVisible: _loadingIsVisible),
              ],
            )),
        bottomSheet: _stackBottomSheet());
  }

  GestureDetector _gestureDetectorTransfering() {
    return GestureDetector(
      key: const Key('gestureDetectorChangeValue'),
      child: Row(
        children: [
          Text(
            putCurrencyMask(widget.userTransaction.value),
            key: const Key('textTransferValue'),
            style: TextStyle(fontSize: 32.0, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
          ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          const Icon(
            Icons.edit,
            color: Colors.deepPurple,
          ),
        ],
      ),
      onTap: () {
        Future value = showModalBottom(
            TransferValueUpdateView(
                userTransaction: widget.userTransaction,
                userPixKey: widget.userPixKey,
                userFrom: widget.userFrom,
                listUserAccount: widget.listUserAccount,
                pageTitle: widget.pageTitle),
            context);

        value.then((value) {
          setState(() {
            if (value != null) {
              widget.userTransaction.value =
                  (double.tryParse(value.toString())! > 0.0 ? double.tryParse(value.toString()) : widget.userTransaction.value)!;
            }
          });
        });
      },
    );
  }

  InkWell _inkWellTransferenceWhen() {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quando', style: Theme.of(context).textTheme.headline4),
            const Padding(padding: EdgeInsets.only(bottom: 10.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    //TODO: sem a verificação abaixo, a data futura aparece zuada
                    Text(_paymentDate.length >= 10 ? convertDateToBrazilianFormat(DateTime.parse(_paymentDate)) : _paymentDate,
                        key: const Key('textTransferDate'), style: Theme.of(context).textTheme.headline3),
                  ],
                ),
                const Icon(Icons.keyboard_arrow_down_rounded)
              ],
            ),
            const Padding(padding: EdgeInsets.only(bottom: 12.0)),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          Future selectedDate = showModalBottom(
              ScheduleView(userTransaction: widget.userTransaction, userTo: _userTo!, listUserAccount: widget.listUserAccount), context);
          selectedDate.then((value) {
            DateFormat formatter = DateFormat('dd/MM/yyyy');
            String selectedDate = formatter.format(value);
            String actualDate = formatter.format(DateTime.now());
            setState(() {
              if (selectedDate == actualDate) {
                _paymentDate = 'Agora';
              } else {
                _paymentDate = value.toString();
              }
            });
          });
        });
      },
    );
  }

  Container _containerTransferenceType() {
    return Container(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tipo de transferência', style: Theme.of(context).textTheme.headline4),
          const Padding(padding: EdgeInsets.only(bottom: 10.0)),
          Text(describeEnum(EnumTransactionType.values[widget.userTransaction.idTransactionType]),
              key: const Key('textTransferType'), style: Theme.of(context).textTheme.headline3),
          const Padding(padding: EdgeInsets.only(bottom: 12.0)),
        ],
      ),
    );
  }

  Row _rowDocumentData() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(CPFValidator.isValid(_userTo!.document) ? 'CPF' : 'CNPJ', style: Theme.of(context).textTheme.headline4),
        Text((_userTo!.document.length > 0) ? _userTo!.document.replaceRange(0, 3, "***").replaceRange(_userTo!.document.length - 2, null, "**") : "",
            key: const Key('textRecipientDocumentNumber'), style: Theme.of(context).textTheme.bodyText2),
      ],
    );
  }

  Row _rowBankNameData() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Instituição', style: Theme.of(context).textTheme.headline4),
        Text(_userTo!.bankName, key: const Key('textRecipientBankName'), style: Theme.of(context).textTheme.bodyText2),
      ],
    );
  }

  Row _rowAgencyData() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Agência', style: Theme.of(context).textTheme.headline4),
        Text(_userTo!.agency, key: const Key('textRecipientAgencyNumber'), style: Theme.of(context).textTheme.bodyText2),
      ],
    );
  }

  Row _rowAccountNumberData() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Conta corrente', style: Theme.of(context).textTheme.headline4),
        Text(_userTo!.account, key: const Key('textRecipientAccountNumber'), style: Theme.of(context).textTheme.bodyText2),
      ],
    );
  }

  Stack _stackBottomSheet() {
    return Stack(
      children: [
        Container(
          height: 70,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 70, right: 70, top: 10, bottom: 10),
          child: _elevatedButtonTransfer(),
        ),
        VisibilityShadowFC(
          isVisible: _loadingIsVisible,
          height: 70.0,
        ),
      ],
    );
  }

  ElevatedButton _elevatedButtonTransfer() {
    return ElevatedButton(
        key: const Key('buttonTransfer'),
        onPressed: () async {
          setState(() {
            _loadingIsVisible = true;
            if (_paymentDate == 'Agora') {
              widget.userTransaction.dateHour = DateTime.now().toString();
            } else {
              widget.userTransaction.isScheduled = 1;
              widget.userTransaction.dateHour = _paymentDate;
            }
          });
          await executeTransaction();
          int timeDelayed = 3 + Random().nextInt(5);
          await Future.delayed(Duration(seconds: timeDelayed));
          setState(() {
            _loadingIsVisible = false;
          });
          if(!mounted) return;
          showModalBottom(
              TransferReceiptView(
                userTransaction: widget.userTransaction,
                userFrom: widget.userFrom,
                userTo: _userTo!,
                fromAccountView: false,
              ),
              context);
        },
        child: const Text('Transferir'));
  }

  Future<void> populateUserTo() async {
    Database db = await DatabaseHelper().initDb();
    _userTo = await User().getUser(widget.userTransaction.idUserTo, db);
    setState(() {});
  }

  Future<void> executeTransaction() async {
    Database db = await DatabaseHelper().initDb();
    List<UserAccount> listUserAccountTo = await UserAccount().getAllUserAccountsFromUser(_userTo!.id, db);
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    if (widget.userTransaction.dateHour.substring(0, 10) == formatter.format(DateTime.now())) {
      //new accountBalance for UserFrom
      widget.listUserAccount[0].accountBalance =
          num.parse((widget.listUserAccount[0].accountBalance - widget.userTransaction.value).toStringAsFixed(2));
      //new accountBalance for UserTo
      listUserAccountTo[0].accountBalance = num.parse((listUserAccountTo[0].accountBalance + widget.userTransaction.value).toStringAsFixed(2));
    }

    await db.transaction((txn) async {
      //add userTransaction in database
      await UserTransaction().saveUserTransactionTXN(widget.userTransaction, txn);
      //update accountBalance for UserFrom in database
      await UserAccount().updateUserAccountTXN(widget.listUserAccount[0], txn);
      //update accountBalance for UserTo in database
      await UserAccount().updateUserAccountTXN(listUserAccountTo[0], txn);
    });
  }
}
