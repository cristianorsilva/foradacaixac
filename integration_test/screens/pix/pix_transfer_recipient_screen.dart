import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foradacaixac/database/pix_key_type.dart';
import 'package:patrol/patrol.dart';

class PixTransferRecipientScreen{
  final Finder _choiceChipPixKeyCPFCNPJ = find.byKey(const Key('choiceChipPixKeyCPFCNPJ'));
  final Finder _choiceChipPixKeyAleatory = find.byKey(const Key('choiceChipPixKeyAleatory'));
  final Finder _choiceChipPixKeyCellphone = find.byKey(const Key('choiceChipPixKeyCellphone'));
  final Finder _choiceChipPixKeyEmail = find.byKey(const Key('choiceChipPixKeyEmail'));

  final Finder _buttonArrowContinue = find.byKey(const Key('buttonArrowContinue'));

  final Finder _alertDialogTitle = find.byKey(const Key('alertDialogTitle'));
  final Finder _alertDialogMessage = find.byKey(const Key('alertDialogMessage'));
  final Finder _alertDialogButtonOk = find.byKey(const Key('alertDialogButtonOk'));

  final Finder _textValueTransfer = find.byKey(const Key('textValueTransfer'));
  final Finder _inputPixKey = find.byKey(const Key('inputPixKey'));


  Future<void> selectPixKeyType(PatrolIntegrationTester $, EnumPixKeyType enumPixKeyType) async {
    switch (enumPixKeyType) {
      case EnumPixKeyType.cpf_cnpj:
        await $(#choiceChipPixKeyCPFCNPJ).tap();
        break;
      case EnumPixKeyType.chave_aleatoria:
        await $(#choiceChipPixKeyAleatory).tap();
        break;
      case EnumPixKeyType.telefone:
        await $(#choiceChipPixKeyCellphone).tap();
        break;
      case EnumPixKeyType.email:
        await $(#choiceChipPixKeyEmail).tap();
        break;
      default:
        break;
    }
  }

  Future<void> informPixKeyToTransfer(PatrolIntegrationTester $, String value) async {
    await $(#inputPixKey).enterText(value);
  }

  Future<void> tapIconContinue(PatrolIntegrationTester $) async {
    await $(#buttonArrowContinue).tap();
  }

}