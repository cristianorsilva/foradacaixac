import 'package:flutter/material.dart';
import 'package:foradacaixac/design_system/button/circular_button_fc.dart';
import 'package:foradacaixac/presenters/login_not_remembered_view.dart';
import 'package:foradacaixac/presenters/payment/payment_view.dart';
import 'package:foradacaixac/presenters/pix/pix_view.dart';
import 'package:foradacaixac/presenters/transfer/transfer_view.dart';
import 'package:foradacaixac/helper/utils.dart';

import '../database/user.dart';
import '../database/user_account.dart';
import 'account_view.dart';
import 'cellphone_top_up/cell_phone_top_up_view.dart';
import 'deposit/deposit_view.dart';

class HomeView extends StatefulWidget {
  final User user;
  final List<UserAccount> listUserAccount;

  const HomeView({super.key, required this.user, required this.listUserAccount});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _hideValues = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsetsDirectional.only(top: MediaQuery.of(context).padding.top),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _containerHeader(),
              const Divider(
                height: 0,
                color: Colors.deepPurpleAccent,
              ),
              _inkWellAccount(context),
              const Divider(
                height: 0,
                color: Colors.deepPurpleAccent,
              ),
              _inkWellCreditCard(),
              const Divider(
                height: 0,
                color: Colors.deepPurpleAccent,
              ),
              _operations(),
              const Divider(
                height: 0,
                color: Colors.deepPurpleAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _operations() {
    return Container(
      height: 125.0,
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            CircularButtonFC(
                key: const Key('inkWellPix'),
                label: 'Pix',
                imageName: 'pix_logo.png',
                viewToShow: PixView(user: widget.user, listUserAccount: widget.listUserAccount),
                showViewAsModal: true),
            const Padding(padding: EdgeInsets.only(left: 10.0)),
            const CircularButtonFC(key: Key('inkWellPayment'),label: 'Pagar', imageName: 'payment.png', viewToShow: PaymentView(), showViewAsModal: true),
            const Padding(padding: EdgeInsets.only(left: 10.0)),
            const CircularButtonFC(key: Key('inkWellTransfer'), label: 'Transferir', imageName: 'transfer.png', viewToShow: TransferView(), showViewAsModal: true),
            const Padding(padding: EdgeInsets.only(left: 10.0)),
            const CircularButtonFC(key: Key('inkWellDeposit'), label: 'Depositar', imageName: 'deposit.png', viewToShow: DepositView(), showViewAsModal: true),
            const Padding(padding: EdgeInsets.only(left: 10.0)),
            const CircularButtonFC(
                key: Key('inkWellCellphoneTopUp'), label: 'Recarga \n de celular', imageName: 'cellphone_top_up.png', viewToShow: CellphoneTopUpView(), showViewAsModal: true),
          ],
        ),
      ),
    );
  }

  Container _containerHeader() {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                decoration:
                    const BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: AssetImage("images/person.png") as ImageProvider)),
              ),
              Row(
                children: [_iconButtonShowHideValues(), _iconButtonAbout(), _iconButtonExitPage()],
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Olá, ${widget.user.name.split(" ").first}',
                key: const Key('textWelcomeUserName'),
                style: Theme.of(context).textTheme.headline2,
              )
            ],
          ),
        ],
      ),
    );
  }

  IconButton _iconButtonShowHideValues() {
    return IconButton(
      key: const Key('iconButtonEye'),
      onPressed: () {
        setState(() {
          if (_hideValues) {
            _hideValues = false;
          } else {
            _hideValues = true;
          }
        });
      },
      icon: Icon(
        _hideValues ? Icons.visibility_off_rounded : Icons.visibility_rounded,
        color: Colors.white,
      ),
    );
  }

  IconButton _iconButtonAbout() {
    return IconButton(
      key: const Key('iconButtonQuestion'),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Automação Fora da Caixa'),
              content: const Text('Bem vindo!'),
              elevation: 2.0,
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'))
              ],
            );
          },
        );
      },
      icon: const Icon(
        Icons.question_answer_rounded,
        color: Colors.white,
      ),
    );
  }

  IconButton _iconButtonExitPage() {
    return IconButton(
      key: const Key('iconButtonExit'),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginNotRememberedView(),
            ));
      },
      icon: const Icon(
        Icons.exit_to_app_rounded,
        color: Colors.white,
      ),
    );
  }

  InkWell _inkWellAccount(BuildContext context) {
    return InkWell(
      key: const Key('inkWellAccount'),
      child: Container(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.account_balance),
                    const Padding(padding: EdgeInsets.only(left: 10.0)),
                    Text('Conta', style: Theme.of(context).textTheme.headline3),
                  ],
                ),
                const Icon(Icons.arrow_forward_ios)
              ],
            ),
            const Padding(padding: EdgeInsets.only(bottom: 12.0)),
            Text(
              _hideValues ? 'R\$ ---,--' : putCurrencyMask(widget.listUserAccount[0].accountBalance),
              key: const Key('textAccountBalance'),
              style: Theme.of(context).textTheme.headlineLarge,
            )
          ],
        ),
      ),
      onTap: () async {
        setState(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AccountView(
                        user: widget.user,
                        listUserAccount: widget.listUserAccount,
                      )));
        });
      },
    );
  }

  InkWell _inkWellCreditCard() {
    return InkWell(
      key: const Key('inkWellCredit'),
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.credit_card),
                    const Padding(padding: EdgeInsets.only(left: 10.0)),
                    Text('Cartão', style: Theme.of(context).textTheme.headline3),
                  ],
                ),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
            const Padding(padding: EdgeInsets.only(bottom: 12.0)),
            Text('Fatura atual', style: Theme.of(context).textTheme.headline6),
            const Padding(padding: EdgeInsets.only(bottom: 5.0)),
            Text(
              _hideValues ? 'R\$ ---,--' : 'R\$ 345,50',
              key: const Key('textCreditBalance'),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
      ),
    );
  }
}
