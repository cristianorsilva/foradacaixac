import 'dart:math';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foradacaixac/design_system/button/elevated_button_fc.dart';
import 'package:foradacaixac/presenters/pix/pix_token_view.dart';
import 'package:sqflite/sqflite.dart';

import '../../database/database_helper.dart';
import '../../database/pix_key_type.dart';
import '../../database/user.dart';
import '../../database/user_pix_key.dart';
import '../../design_system/visibility/visibility_loading_fc.dart';
import '../../design_system/visibility/visibility_shadow_fc.dart';
import '../../helper/utils.dart';
import '../../share/alert_dialog_fc.dart';
import '../../share/option_dialog_fc.dart';

class PixInsertNewKeyView extends StatefulWidget {
  final User user;
  final EnumPixKeyType enumPixKeyType;

  const PixInsertNewKeyView({super.key, required this.user, required this.enumPixKeyType});

  @override
  State<PixInsertNewKeyView> createState() => _PixInsertNewKeyViewState();
}

class _PixInsertNewKeyViewState extends State<PixInsertNewKeyView> {
  bool _loadingIsVisible = false;
  final TextEditingController _textPixKeyEmailController = TextEditingController();
  final TextEditingController _textPixKeyTelefoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Stack(children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_definePixKeyNameOnPage(widget.enumPixKeyType), style: Theme.of(context).textTheme.headlineLarge),
                  const Padding(padding: EdgeInsets.only(top: 15.0)),
                  Text(_definePixKeyDescriptionOnPage(widget.enumPixKeyType), style: Theme.of(context).textTheme.titleLarge),
                  const Padding(padding: EdgeInsets.only(top: 50.0)),
                  _visibilityCPFCNPJ(),
                  _visibilityAleatoryKey(),
                  _visibilityEmailKey(),
                  _visibilityCellphoneKey(),
                ],
              ),
            ),
          ),
          VisibilityShadowFC(isVisible: _loadingIsVisible),
          VisibilityLoadingFC(isVisible: _loadingIsVisible),
        ]),
        //visível somente para CPF/CNPJ ou Chave aleatória.
        bottomSheet: _visibilityBottomSheet(),

        //visível somente para telefone e email
        floatingActionButton: _visibilityFloatingActionButton());
  }

  Visibility _visibilityCPFCNPJ() {
    return Visibility(
      visible: widget.enumPixKeyType == EnumPixKeyType.cpf_cnpj ? true : false,
      child: Row(
        children: [
          const Icon(Icons.vpn_key_rounded),
          const Padding(padding: EdgeInsets.only(left: 15.0)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('CPF', style: Theme.of(context).textTheme.displaySmall),
              const Padding(padding: EdgeInsets.only(top: 5.0)),
              Text(widget.user.document, style: Theme.of(context).textTheme.headlineMedium)
            ],
          ),
        ],
      ),
    );
  }

  Visibility _visibilityAleatoryKey() {
    return Visibility(
      visible: widget.enumPixKeyType == EnumPixKeyType.chave_aleatoria ? true : false,
      child: Row(
        children: [
          const Icon(Icons.shield_rounded),
          const Padding(padding: EdgeInsets.only(left: 15.0)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Chave aleatória', style: Theme.of(context).textTheme.displaySmall),
            ],
          ),
        ],
      ),
    );
  }

  Visibility _visibilityEmailKey() {
    return Visibility(
        visible: widget.enumPixKeyType == EnumPixKeyType.email ? true : false,
        child: TextField(
          controller: _textPixKeyEmailController,
          decoration: InputDecoration(
            labelText: 'Digite o email desejado',
            hintText: 'Email',
            enabledBorder: const OutlineInputBorder(),
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
            floatingLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
            hintStyle: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          inputFormatters: [defineMaskforSelectedKey(EnumPixKeyType.email)],
        ));
  }

  Visibility _visibilityCellphoneKey() {
    return Visibility(
        visible: widget.enumPixKeyType == EnumPixKeyType.telefone ? true : false,
        child: TextField(
            controller: _textPixKeyTelefoneController,
            decoration: InputDecoration(
              labelText: 'Digite o celular desejado',
              hintText: 'Celular',
              enabledBorder: const OutlineInputBorder(),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
              floatingLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
              hintStyle: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            inputFormatters: [defineMaskforSelectedKey(EnumPixKeyType.telefone)],
            keyboardType: const TextInputType.numberWithOptions(decimal: false)));
  }

  Visibility _visibilityFloatingActionButton() {
    return Visibility(
        visible: (widget.enumPixKeyType == EnumPixKeyType.telefone)
            ? true
            : (widget.enumPixKeyType == EnumPixKeyType.email)
                ? true
                : false,
        child: FloatingActionButton(
          child: const Icon(Icons.navigate_next_rounded),
          onPressed: () async {
            bool isValid = false;
            Database db = await DatabaseHelper().initDb();
            UserPixKey? userPixKey = null;

            switch (widget.enumPixKeyType) {
              case EnumPixKeyType.telefone:
                isValid = await _verifyIfEmailCelularKeyIsValid(context, EnumPixKeyType.telefone);
                if (isValid) {
                  userPixKey = await _verifyIfEmailCelularKeyExists(context, EnumPixKeyType.telefone);
                }

                break;
              case EnumPixKeyType.email:
                isValid = await _verifyIfEmailCelularKeyIsValid(context, EnumPixKeyType.email);
                if (isValid) {
                  userPixKey = await _verifyIfEmailCelularKeyExists(context, EnumPixKeyType.email);
                }
                break;
              default:
                break;
            }
            if (userPixKey == null && isValid) {
              userPixKey = UserPixKey();

              switch (widget.enumPixKeyType) {
                case EnumPixKeyType.telefone:
                  userPixKey.keyPix = _textPixKeyTelefoneController.text;
                  List<PixKeyType> listTypePixKey = await PixKeyType().getAllPixKeysType(db);
                  userPixKey.idTypePixKey =
                      listTypePixKey.where((typePixKey) => typePixKey.pixKeyType == describeEnum(EnumPixKeyType.telefone)).first.id;
                  userPixKey.idUser = widget.user.id;

                  break;
                case EnumPixKeyType.email:
                  //TODO: it is not OK, should be similar to telefone block code
                  userPixKey.keyPix = _textPixKeyEmailController.text;
                  userPixKey.idTypePixKey = EnumPixKeyType.email.index;
                  break;
                default:
                  break;
              }

              userPixKey.idUser = widget.user.id;

              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => PixTokenView(userPixKey: userPixKey!, enumPixKeyType: widget.enumPixKeyType)));
            } else if (userPixKey != null) {
              //TODO: a chave já é utilizada.
            }
          },
        ));
  }

  Visibility _visibilityBottomSheet() {
    return Visibility(
      visible: (widget.enumPixKeyType == EnumPixKeyType.cpf_cnpj)
          ? true
          : (widget.enumPixKeyType == EnumPixKeyType.chave_aleatoria)
              ? true
              : false,
      child: Stack(
        children: [
          Container(
              height: 200,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SingleChildScrollView(
                      child: Column(children: [
                    Text('Quem usa Pix vai saber que você tem uma chave cadastrada por telefone ou e-mail, mas não terá acesso aos seus dados',
                        style: Theme.of(context).textTheme.titleLarge),
                    Text('Quem te pagar por Pix poderá ver seu nome completo e alguns dígitos do seu CPF.',
                        style: Theme.of(context).textTheme.titleLarge),
                    const Padding(padding: EdgeInsets.only(top: 25.0)),
                    _elevatedButtonFCRegisterKey()
                  ])),
                ],
              )),
          VisibilityShadowFC(isVisible: _loadingIsVisible, height: 200)
        ],
      ),
    );
  }

  ElevatedButtonFC _elevatedButtonFCRegisterKey() {
    return ElevatedButtonFC(
      key: const Key('elevatedButtonRegisterKey'),
      onPressed: () async {
        setState(() {
          _loadingIsVisible = true;
        });
        bool pixKeyCreated = false;

        Database db = await DatabaseHelper().initDb();
        UserPixKey userPixKey = UserPixKey();

        switch (widget.enumPixKeyType) {
          case EnumPixKeyType.cpf_cnpj:
            List<PixKeyType> listTypePixKey = await PixKeyType().getAllPixKeysType(db);
            userPixKey.idTypePixKey = listTypePixKey.where((typePixKey) => typePixKey.pixKeyType == describeEnum(EnumPixKeyType.cpf_cnpj)).first.id;
            userPixKey.idUser = widget.user.id;
            userPixKey.keyPix = widget.user.document;

            userPixKey = await UserPixKey().insertNewUserPixKey(userPixKey, db);
            if (userPixKey.id > 0) {
              pixKeyCreated = true;
            }

            break;
          case EnumPixKeyType.chave_aleatoria:
            String aleatoryKey = generateAleatoryKeyPix();

            List<PixKeyType> listTypePixKey = await PixKeyType().getAllPixKeysType(db);
            userPixKey.idTypePixKey =
                listTypePixKey.where((typePixKey) => typePixKey.pixKeyType == describeEnum(EnumPixKeyType.chave_aleatoria)).first.id;
            userPixKey.idUser = widget.user.id;
            userPixKey.keyPix = aleatoryKey;

            userPixKey = await UserPixKey().insertNewUserPixKey(userPixKey, db);
            if (userPixKey.id > 0) {
              pixKeyCreated = true;
            }
            break;
          default:
            break;
        }
        int timeDelayed = 3 + Random().nextInt(5);
        await Future.delayed(Duration(seconds: timeDelayed));
        if(!mounted) return;

        setState(() {
          _loadingIsVisible = false;
        });

        if (pixKeyCreated) {
          print('Chave pix criada: $userPixKey');

          Navigator.pop(context);
          Navigator.pop(context);

          const snack = SnackBar(
            content: Text(
              'Chave pix cadastrada com sucesso',
              style: TextStyle(),
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 3),
          );
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(snack);
        } else {
          const snack = SnackBar(
            content: Text(
              'Ocorreu um erro ao cadastrar a chave pix',
              style: TextStyle(),
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 3),
          );
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(snack);
        }
      },
      label: _definePixKeyNameOnPage(widget.enumPixKeyType),
    );
  }

  String _definePixKeyNameOnPage(EnumPixKeyType enumPixKeyType) {
    String text = "";

    switch (enumPixKeyType) {
      case EnumPixKeyType.none:
        text = 'Erro!';
        break;
      case EnumPixKeyType.cpf_cnpj:
        text = 'Registrar CPF';
        break;
      case EnumPixKeyType.chave_aleatoria:
        text = 'Registrar Chave aleatória';
        break;
      case EnumPixKeyType.telefone:
        text = 'Registrar Celular';
        break;
      case EnumPixKeyType.email:
        text = 'Registrar Email';
        break;
    }

    return text;
  }

  String _definePixKeyDescriptionOnPage(EnumPixKeyType enumPixKeyType) {
    String text = "";

    switch (enumPixKeyType) {
      case EnumPixKeyType.none:
        text = 'Erro!';
        break;
      case EnumPixKeyType.cpf_cnpj:
        text = 'Contatos poderão fazer transferências pelo Pix usando apenas seu CPF';
        break;
      case EnumPixKeyType.chave_aleatoria:
        text = 'Com uma chave aleatória você gera uma chave Pix sem compartilhar seus dados a outras pessoas';
        break;
      case EnumPixKeyType.telefone:
        text = 'Insira o celular que você deseja cadastrar como chave Pix.';
        break;
      case EnumPixKeyType.email:
        text = 'Insira o email que você deseja cadastrar como chave Pix.';
        break;
    }

    return text;
  }

  ///Verifica se a chave é válida ou não
  Future<bool> _verifyIfEmailCelularKeyIsValid(BuildContext context, EnumPixKeyType enumPixKeyType) async {
    String pixKeyValue = "";
    bool isValid = true;
    switch (enumPixKeyType) {
      case EnumPixKeyType.telefone:
        pixKeyValue = _textPixKeyTelefoneController.text;
        if (pixKeyValue.isEmpty || pixKeyValue.length < 15) {
          await showAlertDialog(
              'Automação Fora da Caixa', 'Formato de celular é inválido!', context, 'alertDialogTitle', 'alertDialogMessage', 'alertDialogButtonOk');
          isValid = false;
        }

        break;
      case EnumPixKeyType.email:
        pixKeyValue = _textPixKeyEmailController.text;
        if (!EmailValidator.validate(pixKeyValue)) {
          await showAlertDialog(
              'Automação Fora da Caixa', 'Formato de email é inválido!', context, 'alertDialogTitle', 'alertDialogMessage', 'alertDialogButtonOk');
          isValid = false;
        }

        break;
      default:
        break;
    }
    return isValid;
  }

  ///Retorna um objeto UserPixKey se a chave já existe, ou nulo se ela não existe.
  Future<UserPixKey?> _verifyIfEmailCelularKeyExists(BuildContext context, EnumPixKeyType enumPixKeyType) async {
    UserPixKey? userPixKey;

    switch (enumPixKeyType) {
      case EnumPixKeyType.cpf_cnpj:
        break;
      case EnumPixKeyType.chave_aleatoria:
        break;
      case EnumPixKeyType.telefone:
        String pixKeyValue = _textPixKeyTelefoneController.text;
        userPixKey = await _getPixKeyIfExists(pixKeyValue);

        if (pixKeyValue.isEmpty || pixKeyValue.length < 15) {
          await showAlertDialog(
              'Automação Fora da Caixa', 'Formato de celular é inválido!', context, 'alertDialogTitle', 'alertDialogMessage', 'alertDialogButtonOk');
        } else if (userPixKey != null) {
          await showOptionDialog('Automação Fora da Caixa', 'Chave utilizada por outro usuário! Deseja iniciar portabilidade?', context,
              'optionDialogTitle', 'optionDialogMessage', 'optionDialogButtonYes', 'optionDialogButtonNo');
        }

        break;
      case EnumPixKeyType.email:
        String pixKeyValue = _textPixKeyEmailController.text;
        userPixKey = await _getPixKeyIfExists(pixKeyValue);

        if (!EmailValidator.validate(pixKeyValue)) {
          await showAlertDialog(
              'Automação Fora da Caixa', 'Formato de email é inválido!', context, 'alertDialogTitle', 'alertDialogMessage', 'alertDialogButtonOk');
        } else if (userPixKey != null) {
          await showOptionDialog('Automação Fora da Caixa', 'Email utilizado por outro usuário! Deseja iniciar portabilidade?', context,
              'optionDialogTitle', 'optionDialogMessage', 'optionDialogButtonYes', 'optionDialogButtonNo');
        }

        break;
      case EnumPixKeyType.none:
        break;
    }
    return userPixKey;
  }

  Future<UserPixKey?> _getPixKeyIfExists(String pixKeyValue) async {
    Database db = await DatabaseHelper().db;
    UserPixKey? userPixKey = await UserPixKey().getUserPixKeyByKey(pixKeyValue, db);
    return userPixKey;
  }
}
