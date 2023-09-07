import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';

import '../../database/user.dart';
import '../../database/user_account.dart';
import '../../database/user_pix_key.dart';
import '../../database/user_transaction.dart';
import '../../helper/utils.dart';
import '../../share/alert_dialog_fc.dart';

class TransferValueUpdateView extends StatefulWidget {
  final UserTransaction userTransaction;
  final UserPixKey userPixKey;
  final User userFrom;
  final List<UserAccount> listUserAccount;
  final String pageTitle;

  const TransferValueUpdateView(
      {super.key,
      required this.userTransaction,
      required this.userPixKey,
      required this.userFrom,
      required this.listUserAccount,
      required this.pageTitle});

  @override
  State<TransferValueUpdateView> createState() => _TransferValueUpdateViewState();
}

class _TransferValueUpdateViewState extends State<TransferValueUpdateView> {
  final TextEditingController controllerTransferValue = TextEditingController();

  @override
  void initState() {
    super.initState();
    controllerTransferValue.text = putCurrencyMask(widget.userTransaction.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
          title: Text(widget.pageTitle, style: Theme.of(context).textTheme.headline2),
        ),
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
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(bottom: 15)),
              _textFieldValue()
            ],
          ),
        ),
        bottomSheet: Container(height: 70, alignment: Alignment.topCenter, child: _elevatedButtonUpdateValue()));
  }

  ElevatedButton _elevatedButtonUpdateValue() {
    return ElevatedButton(
      key: const Key('buttonUpdateValue'),
      style: ElevatedButton.styleFrom(backgroundColor: _currentValueInTextField() > 0.0 ? Theme.of(context).primaryColor : Theme.of(context).disabledColor),
      onPressed: () {
        setState(() {
          num currentValue = double.parse(controllerTransferValue.text.replaceAll('R\$ ', '').replaceAll('.', '').replaceAll(',', '.'));
          if (currentValue > 0.0) {
            if (currentValue > widget.listUserAccount[0].accountBalance) {
              showAlertDialog('Automação Fora da Caixa', 'Você não possui saldo suficiente para essa transferência!', context, 'alertDialogTitle',
                  'alertDialogMessage', 'alertDialogButtonOk');
            } else {
              widget.userTransaction.value =
                  double.parse(controllerTransferValue.text.replaceAll('R\$ ', '').replaceAll('.', '').replaceAll(',', '.'));
              Navigator.pop(context, widget.userTransaction.value);
            }
          }
        });
      },
      child: const Text(
        'Atualizar Valor',
      ),
    );
  }

  num _currentValueInTextField() {
    return double.parse(controllerTransferValue.text.replaceAll('R\$ ', '').replaceAll('.', '').replaceAll(',', '.'));
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
      keyboardType: const TextInputType.numberWithOptions(),
      key: const Key('inputTransferValue'),
      onChanged: (text) {
        setState(() {});
      },
    );
  }
}
