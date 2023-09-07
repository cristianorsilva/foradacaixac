import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

class HomeScreen {
  final Finder _iconButtonEye = find.byKey(const Key('iconButtonEye'));
  final Finder _iconButtonQuestion = find.byKey(const Key('iconButtonQuestion'));
  final Finder _iconButtonExit = find.byKey(const Key('iconButtonExit'));

  final Finder _inkWellAccount = find.byKey(const Key('inkWellAccount'));
  final Finder _inkWellCredit = find.byKey(const Key('inkWellCredit'));

  final Finder _textWelcomeUserName = find.byKey(const Key('textWelcomeUserName'));
  final Finder _textAccountBalance = find.byKey(const Key('textAccountBalance'));
  final Finder _textCreditBalance = find.byKey(const Key('textCreditBalance'));

  final Finder _inkWellPix = find.byKey(const Key('inkWellPix'));
  final Finder _inkWellPayment = find.byKey(const Key('inkWellPayment'));
  final Finder _inkWellTransfer = find.byKey(const Key('inkWellTransfer'));
  final Finder _inkWellDeposit = find.byKey(const Key('inkWellDeposit'));
  final Finder _inkWellCellphoneTopUp = find.byKey(const Key('inkWellCellphoneTopUp'));

  HomeScreen();

  Future<void> checkTextWelcomeUser(PatrolIntegrationTester $, String checkText) async {
    await $(#textWelcomeUserName).waitUntilVisible();
    expect($(#textWelcomeUserName).text, checkText);
  }

  Future<void> tapPix(PatrolIntegrationTester $) async {
    await $(#inkWellPix).waitUntilVisible();
    await $(#inkWellPix).tap();
  }
}
