import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:foradacaixac/presenters/pix/pix_transfer_recipient_view.dart';

import '../../database/user.dart';
import '../../database/user_account.dart';
import '../../database/user_transaction.dart';
import '../../helper/utils.dart';
import '../../share/alert_dialog_fc.dart';
import '../../share/bottom_sheet_fc.dart';

class TransferValueView extends StatefulWidget {
  final User user;
  final UserTransaction userTransaction;
  final List<UserAccount> listUserAccount;
  final String pageTitle;

  const TransferValueView({super.key, required this.user, required this.pageTitle, required this.userTransaction, required this.listUserAccount});

  @override
  State<TransferValueView> createState() => _TransferValueViewState();
}

class _TransferValueViewState extends State<TransferValueView> {
  final TextEditingController controllerTransferValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        title: Text(widget.pageTitle, style: Theme.of(context).textTheme.headline2),
      ),
      floatingActionButton: _floatingActionButton(),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              'Qual valor você deseja transferir?',
              style: Theme.of(context).textTheme.headline1,
            ),

            const Padding(padding: EdgeInsets.only(bottom: 10)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Seu saldo disponível é    ',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  putCurrencyMask(widget.listUserAccount[0].accountBalance),
                  style: Theme.of(context).textTheme.headline1,
                  key: const Key('textAvailableBalance'),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(bottom: 15)),
            _textFieldValue()
          ],
        ),
      ),
    );
  }

  TextField _textFieldValue() {
    return TextField(
      maxLength: 20,
      controller: controllerTransferValue,
      inputFormatters: [
        TextInputMask(
          mask: ['R!\$! !9,99', 'R!\$! !9+.999.999.999,99'],
          placeholder: '0',
          maxPlaceHolders: 3,
          reverse: true,
        ),
      ],
      decoration: const InputDecoration(hintText: 'R\$ 0,00', counterText: ""),
      style: Theme.of(context).textTheme.headline3,
      onChanged: (text) {
        setState(() {
          if (text.isNotEmpty) {
            widget.userTransaction.value = double.parse(text.replaceAll('R\$ ', '').replaceAll('.', '').replaceAll(',', '.'));
          }
        });
      },
      keyboardType: const TextInputType.numberWithOptions(),
      key: const Key('inputTransferValue'),
    );
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        if (widget.userTransaction.value > 0) {
          if (widget.userTransaction.value > widget.listUserAccount[0].accountBalance) {
            showAlertDialog('Automação Fora da Caixa', 'Você não possui saldo suficiente para essa transferência!', context, 'alertDialogTitle', 'alertDialogMessage',
                'alertDialogButtonOk');
          } else {
            widget.userTransaction.idUserFrom = widget.user.id;
            showModalBottom(
                PixTransferRecipientView(
                    userTransaction: widget.userTransaction, user: widget.user, listUserAccount: widget.listUserAccount, pageTitle: widget.pageTitle),
                context);
          }
        }
      },
      backgroundColor: (widget.userTransaction.value > 0) ? Theme.of(context).floatingActionButtonTheme.backgroundColor : Theme.of(context).disabledColor,
      key: const Key('buttonArrowContinue'),
      child: const Icon(Icons.arrow_forward_rounded),
    );
  }
}
