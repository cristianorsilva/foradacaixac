import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../database/transaction_type.dart';
import '../../database/user.dart';
import '../../database/user_transaction.dart';
import '../../helper/utils.dart';

class TransferReceiptView extends StatefulWidget {
  final UserTransaction userTransaction;
  final User userFrom;
  final User userTo;
  final bool fromAccountView;

  const TransferReceiptView(
      {super.key, required this.userTransaction, required this.userFrom, required this.userTo, required this.fromAccountView});

  @override
  State<TransferReceiptView> createState() => _TransferReceiptViewState();
}

class _TransferReceiptViewState extends State<TransferReceiptView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        key: const Key('singleChildScrowViewMain'),
        padding: const EdgeInsets.all(15),
        child: Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      key: const Key('gestureDetectorClose'),
                      child: const Icon(
                        Icons.clear_rounded,
                      ),
                      onTap: () {
                        setState(() {
                          widget.fromAccountView ? Navigator.pop(context) : Navigator.popUntil(context, ModalRoute.withName('/home_page'));
                        });
                      },
                    ),
                    GestureDetector(
                      key: const Key('gestureDetectorShare'),
                      child: const Icon(
                        Icons.share_rounded,
                      ),
                      onTap: () {
                        setState(() {
                          //TODO: Mostrar tela de share (há exemplo disso no curso?)
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          Text(widget.userTransaction.isScheduled == 1 ? 'Transferência agendada' : 'Comprovante de transferência',
              key: const Key('textReceiptTitle'), style: Theme.of(context).textTheme.headline1),
          const Padding(padding: EdgeInsets.only(bottom: 15)),
          Text(
              convertDateToBrazilianFormat(DateTime.parse(widget.userTransaction.dateHour),
                  shownOnlyDate: widget.userTransaction.isScheduled == 1 ? true : false),
              key: const Key('textTransferDate'),
              style: Theme.of(context).textTheme.headline6),
          const Padding(padding: EdgeInsets.only(bottom: 15)),

          _infoUser('Valor', putCurrencyMask(widget.userTransaction.value), 'textTransferValue'),
          _infoUser('Tipo de Transferência', describeEnum(EnumTransactionType.values[widget.userTransaction.idTransactionType]), 'textTransferType'),

          const Divider(
            height: 0,
            color: Colors.deepPurpleAccent,
          ),
          const Padding(padding: EdgeInsets.only(bottom: 15)),
          //Destino
          Row(
            children: [
              const Icon(Icons.payment),
              const Padding(padding: EdgeInsets.only(left: 15)),
              Text('Destino', style: Theme.of(context).textTheme.headline3),
            ],
          ),
          const Padding(padding: EdgeInsets.only(bottom: 15)),
          const Divider(
            height: 0,
            color: Colors.deepPurpleAccent,
          ),
          const Padding(padding: EdgeInsets.only(bottom: 15)),
          //Dados de Destino
          _infoUser('Nome', widget.userTo.name, 'textRecipientFullUserName'),
          _infoUser('CPF', widget.userTo.document, 'textRecipientDocumentNumber'),
          _infoUser('Instituição', widget.userTo.bankName, 'textRecipientBankName'),
          _infoUser('Agência', widget.userTo.agency, 'textRecipientAgencyNumber'),
          _infoUser('Conta', widget.userTo.account, 'textRecipientAccountNumber'),
          _infoUser('Tipo de conta', 'Conta Corrente', 'textRecipientAccountType'),
          const Divider(
            height: 0,
            color: Colors.deepPurpleAccent,
          ),
          const Padding(padding: EdgeInsets.only(bottom: 15)),
          //Origem
          Row(
            children: [
              const Icon(Icons.payment),
              const Padding(padding: EdgeInsets.only(left: 15)),
              Text('Origem', style: Theme.of(context).textTheme.headline3),
            ],
          ),
          const Padding(padding: EdgeInsets.only(bottom: 15)),
          const Divider(
            height: 0,
            color: Colors.deepPurpleAccent,
          ),
          const Padding(padding: EdgeInsets.only(bottom: 15)),
          //Dados de origem
          _infoUser('Nome', widget.userFrom.name, 'textSenderFullUserName'),
          _infoUser('CPF', widget.userFrom.document, 'textSenderDocumentNumber'),
          _infoUser('Instituição', widget.userFrom.bankName, 'textSenderBankName'),
          _infoUser('Agência', widget.userFrom.agency, 'textSenderAgencyNumber'),
          _infoUser('Conta', widget.userFrom.account, 'textSenderAccountNumber'),
          _infoUser('Tipo de conta', 'Conta Corrente', 'textSenderAccountType'),
          const Padding(padding: EdgeInsets.only(top: 15)),
          Text('ID da transação:', style: Theme.of(context).textTheme.headline6),
          Text('E7565486895648s89657978BH', key: const Key('textTransactionID'), style: Theme.of(context).textTheme.headline6),
        ]));
  }

  Column _infoUser(String labelName, String labelValue, String keyData) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            labelName,
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(
            labelValue,
            key: Key(keyData),
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
      const Padding(padding: EdgeInsets.only(bottom: 15)),
    ]);
  }
}
