import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

class TransferValueScreen {
  final Finder _alertDialogTitle = find.byKey(const Key('alertDialogTitle'));
  final Finder _alertDialogMessage = find.byKey(const Key('alertDialogMessage'));
  final Finder _alertDialogButtonOk = find.byKey(const Key('alertDialogButtonOk'));
  final Finder _buttonArrowContinue = find.byKey(const Key('buttonArrowContinue'));
  final Finder _textAvailableBalance = find.byKey(const Key('textAvailableBalance'));
  final Finder _inputTransferValue = find.byKey(const Key('inputTransferValue'));

  TransferValueScreen();

  Future<void> informValueToTransfer(PatrolIntegrationTester $, String value) async {
    await $(#inputTransferValue).enterText(value);
  }

  Future<void> tapIconContinue(PatrolIntegrationTester $) async {
    await $(#buttonArrowContinue).tap();
  }
}
