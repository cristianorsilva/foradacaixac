import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../database/database_helper.dart';
import '../../database/pix_key_type.dart';
import '../../database/user.dart';
import '../../database/user_account.dart';
import '../../database/user_pix_key.dart';
import '../../database/user_transaction.dart';
import '../../helper/utils.dart';
import '../../share/alert_dialog_fc.dart';
import '../../share/bottom_sheet_fc.dart';
import '../transfer/verify_data_view.dart';

class PixTransferRecipientView extends StatefulWidget {
  final UserTransaction userTransaction;
  final User user;
  final List<UserAccount> listUserAccount;
  final String pageTitle;

  const PixTransferRecipientView(
      {super.key, required this.userTransaction, required this.user, required this.listUserAccount, required this.pageTitle});

  @override
  State<PixTransferRecipientView> createState() => _PixTransferRecipientViewState();
}

class _PixTransferRecipientViewState extends State<PixTransferRecipientView> {
  bool _hasValue = false;
  String _keyMessage = "";
  TextEditingController _recipientKeyController = TextEditingController();
  EnumPixKeyType _enumPixKeyType = EnumPixKeyType.none;

  UserPixKey? _userPixKey = UserPixKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        title: Text(widget.pageTitle, style: Theme.of(context).textTheme.displayMedium),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_hasValue) {
            _userPixKey = await _validateKey(context);
            if (_userPixKey != null) {
              if (!mounted) return;
              widget.userTransaction.idUserTo = _userPixKey!.idUser;
              showModalBottom(
                  VerifyDataView(
                      userTransaction: widget.userTransaction,
                      userPixKey: _userPixKey!,
                      userFrom: widget.user,
                      listUserAccount: widget.listUserAccount,
                      pageTitle: widget.pageTitle),
                  context);
            }
          }
        },
        backgroundColor: (_hasValue) ? Theme.of(context).floatingActionButtonTheme.backgroundColor : Theme.of(context).disabledColor,
        key: const Key('buttonArrowContinue'),
        child: const Icon(Icons.arrow_forward_rounded),
      ),
      body: Container(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Para quem você deseja transferir?',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const Padding(padding: EdgeInsets.only(bottom: 25)),
              Text(
                'O valor a ser transferido é de:',
                style: Theme.of(context).textTheme.bodyMedium,
                key: const Key('textValueTransfer'),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 10)),
              Text(
                putCurrencyMask(widget.userTransaction.value),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const Padding(padding: EdgeInsets.only(bottom: 25)),
              Text(
                'Selecione o tipo de chave do destinatário:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Padding(padding: EdgeInsets.only(bottom: 10)),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    createChoiceChip('CPF/CNPJ', EnumPixKeyType.cpf_cnpj, 'choiceChipPixKeyCPFCNPJ'),
                    const Padding(padding: EdgeInsets.only(left: 5)),
                    createChoiceChip('Chave Aleatória', EnumPixKeyType.chave_aleatoria, 'choiceChipPixKeyAleatory'),
                    const Padding(padding: EdgeInsets.only(left: 5)),
                    createChoiceChip('Telefone', EnumPixKeyType.telefone, 'choiceChipPixKeyCellphone'),
                    const Padding(padding: EdgeInsets.only(left: 5)),
                    createChoiceChip('Email', EnumPixKeyType.email, 'choiceChipPixKeyEmail'),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 10)),
              _textFieldRecipientKey()
            ],
          ))),
    );
  }

  TextField _textFieldRecipientKey() {
    return TextField(
      key: const Key('inputPixKey'),
      controller: _recipientKeyController,
      decoration: InputDecoration(
        labelText: _keyMessage,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        counterText: "",
      ),
      style: Theme.of(context).textTheme.bodyMedium,
      onChanged: (text) {
        setState(() {
          if (text.isNotEmpty) {
            _hasValue = true;
          } else {
            _hasValue = false;
          }
        });
      },
      enabled: _enumPixKeyType == EnumPixKeyType.none ? false : true,
      keyboardType: (_enumPixKeyType == EnumPixKeyType.cpf_cnpj || _enumPixKeyType == EnumPixKeyType.telefone)
          ? const TextInputType.numberWithOptions(decimal: false)
          : TextInputType.text,
      inputFormatters: [defineMaskforSelectedKey(_enumPixKeyType)],
    );
  }

  Future<UserPixKey?> _validateKey(BuildContext context) async {
    String pixKeyValue = _recipientKeyController.text;
    bool isValid = false;
    UserPixKey? userPixKey;
    switch (_enumPixKeyType) {
      case EnumPixKeyType.cpf_cnpj:
        isValid = _validateCPFCNPJ(pixKeyValue);
        userPixKey = await _verifyKey(pixKeyValue);
        if (!isValid) {
          if(!mounted) return null;
          await showAlertDialog('Automação Fora da Caixa', 'A chave CPF/CNPJ informada é inválida!', context, 'alertDialogTitle',
              'alertDialogMessage', 'alertDialogButtonOk');
        } else if (userPixKey == null) {
          if(!mounted) return null;
          await showAlertDialog('Automação Fora da Caixa', 'A chave CPF/CNPJ informada não existe!', context, 'alertDialogTitle',
              'alertDialogMessage', 'alertDialogButtonOk');
        }
        break;
      case EnumPixKeyType.chave_aleatoria:
        break;
      case EnumPixKeyType.telefone:
        isValid = _validateCellphone(pixKeyValue);
        userPixKey = await _verifyKey(pixKeyValue);
        if (!isValid) {
          if(!mounted) return null;
          await showAlertDialog('Automação Fora da Caixa', 'A chave de telefone informada é inválida!', context, 'alertDialogTitle',
              'alertDialogMessage', 'alertDialogButtonOk');
        } else if (userPixKey == null) {
          if(!mounted) return null;
          await showAlertDialog('Automação Fora da Caixa', 'A chave de telefone informada não existe!', context, 'alertDialogTitle',
              'alertDialogMessage', 'alertDialogButtonOk');
        }
        break;
      case EnumPixKeyType.email:
        isValid = _validateEmailAccount(pixKeyValue);
        userPixKey = await _verifyKey(pixKeyValue);
        if (!isValid) {
          if(!mounted) return null;
          await showAlertDialog('Automação Fora da Caixa', 'A chave de email informada é inválida!', context, 'alertDialogTitle',
              'alertDialogMessage', 'alertDialogButtonOk');
        } else if (userPixKey == null) {
          if(!mounted) return null;
          await showAlertDialog('Automação Fora da Caixa', 'A chave de email informada não existe!', context, 'alertDialogTitle',
              'alertDialogMessage', 'alertDialogButtonOk');
        }
        break;
      case EnumPixKeyType.none:
        break;
    }
    return userPixKey;
  }

  bool _validateCPFCNPJ(String pixKeyValue) {
    if (CPFValidator.isValid(pixKeyValue) || CNPJValidator.isValid(pixKeyValue)) {
      return true;
    } else {
      return false;
    }
  }

  bool _validateCellphone(String pixKeyValue) {
    if (pixKeyValue.isEmpty || pixKeyValue.length < 15) {
      return false;
    } else {
      return true;
    }
  }

  bool _validateEmailAccount(String pixKeyValue){
    if (EmailValidator.validate(pixKeyValue)) {
      return true;
    } else {
      return false;
    }
  }

  Future<UserPixKey?> _verifyKey(String pixKeyValue) async {
    Database db = await DatabaseHelper().db;
    UserPixKey? userPixKey = await UserPixKey().getUserPixKeyByKey(pixKeyValue, db);
    return userPixKey;
  }

  Widget createChoiceChip(String label, EnumPixKeyType enumPixKeyType, String key) {
    return ChoiceChip(
      key: Key(key),
      label: Text(
        label,
        style: TextStyle(color: _enumPixKeyType == enumPixKeyType ? Colors.white : Colors.black, fontWeight: FontWeight.normal),
      ),
      selectedColor: _enumPixKeyType == enumPixKeyType ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
      selected: _enumPixKeyType == enumPixKeyType,
      onSelected: (value) {
        setState(() {
          if (value) {
            //hides keyboard
            FocusScope.of(context).unfocus();
            _recipientKeyController.text = "";
            _hasValue = false;
            switch (enumPixKeyType) {
              case EnumPixKeyType.cpf_cnpj:
                _enumPixKeyType = EnumPixKeyType.cpf_cnpj;
                _keyMessage = 'Informe a chave CPF/CNPJ';
                break;
              case EnumPixKeyType.chave_aleatoria:
                _keyMessage = 'Informe a chave Aleatória';
                _enumPixKeyType = EnumPixKeyType.chave_aleatoria;
                break;
              case EnumPixKeyType.telefone:
                _keyMessage = 'Informe a chave de Telefone';
                _enumPixKeyType = EnumPixKeyType.telefone;
                break;
              case EnumPixKeyType.email:
                _keyMessage = 'Informe a chave de Email';
                _enumPixKeyType = EnumPixKeyType.email;
                break;
              case EnumPixKeyType.none:
                break;
            }
          }
        });
      },
    );
  }
}
