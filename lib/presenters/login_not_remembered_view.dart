import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:foradacaixac/design_system/button/text_button_fc.dart';
import 'package:foradacaixac/design_system/text/text_form_field_fc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../database/user.dart';
import '../database/user_account.dart';
import '../design_system/button/elevated_button_fc.dart';
import '../share/alert_dialog_fc.dart';
import 'home_view.dart';

class LoginNotRememberedView extends StatefulWidget {
  const LoginNotRememberedView({super.key});

  @override
  State<LoginNotRememberedView> createState() => _LoginNotRememberedViewState();
}

class _LoginNotRememberedViewState extends State<LoginNotRememberedView> {
  TextEditingController cpfcnpjController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        key: const Key('singleChildScrowViewMain'),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(top: MediaQuery.of(context).padding.top),
                child: Center(
                  child: SizedBox(width: 200, height: 250, child: Image.asset('images/logo_fora_da_caixa.png')),
                ),
              ),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 15), child: _textFormFieldDocumentID()),
              Padding(padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0), child: _textFormFieldPassword()),
              TextButton(key: const Key('buttonForgotPassword'), onPressed: () async { await _showUserPassHelper();}, child: const Text('Esqueci o usuário/senha')),
              Container(height: 70, alignment: Alignment.topCenter, child: _elevatedButtonLogin()),
              TextButton(key: const Key('buttonNewUser'), onPressed: () {}, child: const Text('Novo usuário? Crie sua conta grátis')),
            ],
          ),
        ),
      ),
    );
  }

  TextFormFieldFC _textFormFieldDocumentID() {
    return TextFormFieldFC(
      keyboardType: TextInputType.number,
      inputFormatters: [
        TextInputMask(
          mask: ['999.999.999-99', '99.999.999/9999-99'],
          placeholder: ' ',
          maxPlaceHolders: 1,
          reverse: true,
        )
      ],
      key: const Key('inputDocument'),
      labelText: 'CPF ou CNPJ',
      hintText: 'Informe seu CPF ou CNPJ',
      controller: cpfcnpjController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Campo de preenchimento obrigatório";
        }
      },
    );
  }

  TextFormFieldFC _textFormFieldPassword() {
    return TextFormFieldFC(
      obscureText: true,
      keyboardType: const TextInputType.numberWithOptions(decimal: false),
      key: const Key('inputPassword'),
      labelText: 'Senha',
      hintText: 'Informe sua senha',
      controller: passwordController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Campo de preenchimento obrigatório";
        }
      },
    );
  }

  bool _validateDocumentID() {
    String login = cpfcnpjController.text;
    bool validLogin = true;
    String message = '';
    if (login.length < 15) {
      if (!CPFValidator.isValid(login)) {
        validLogin = false;
        message = 'O CPF informado não é válido!';
      }
    } else {
      if (!CNPJValidator.isValid(login)) {
        validLogin = false;
        message = 'O CNPJ informado não é válido!';
      }
    }
    if (!validLogin) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Automação Fora da Caixa', key: Key('alertDialogTitle')),
            content: Text(message, key: const Key('alertDialogMessage')),
            elevation: 2.0,
            actions: [
              TextButton(
                child: const Text('OK'),
                key: const Key('alertDialogButtonOk'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }

    return validLogin;
  }

  ElevatedButtonFC _elevatedButtonLogin() {
    return ElevatedButtonFC(
        key: const Key('buttonLogin'),
        label: 'Login',
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            bool validDocumentID = _validateDocumentID();
            User user;
            if (validDocumentID) {
              Database db = await DatabaseHelper().db;
              user = await User().getUserByDocumentAndPassword(cpfcnpjController.text, passwordController.text, db);
              if (user.id == 0) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        'Automação Fora da Caixa',
                        key: Key('alertDialogTitle'),
                      ),
                      content: const Text(
                        'Usuário ou senha inválidos',
                        key: Key('alertDialogMessage'),
                      ),
                      elevation: 2.0,
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                          key: const Key('alertDialogButtonOk'),
                        )
                      ],
                    );
                  },
                );
              } else {
                List<UserAccount> listUserAccount = await UserAccount().getAllUserAccountsFromUser(user.id, db);
                if(!mounted) return;

                //Requesting permissions
                await _requestLocationPermission();
                _goToHomeView(user, listUserAccount);


              }
            }
          }

          setState(() {});
        });
  }

  _goToHomeView(User user, List<UserAccount> listUserAccount){
    Navigator.push(
        context,
        MaterialPageRoute(
            settings: const RouteSettings(name: '/home_page'),
            builder: (context) => HomeView(user: user, listUserAccount: listUserAccount)));
  }

  Future<void> _requestLocationPermission() async {
      PermissionStatus permissionStatus = await Permission.location.status;
      if (!permissionStatus.isGranted) {
        await Permission.location.request();
      }
  }

  Future<void> _showUserPassHelper() async {
    await showAlertDialog('Automação Fora da Caixa', 'Contas Válidas: \n  CPF: 929.035.400-39 \n  CPF: 050.209.090-17 \n  CPF: 971.147.000-40 \n\nSenha: 172839 \n\nToken: 123456', context, 'alertDialogTitle',
        'alertDialogMessage', 'alertDialogButtonOk');
  }
}
