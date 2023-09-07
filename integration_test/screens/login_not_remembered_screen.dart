
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:permission_handler/permission_handler.dart';

const _timeout = Duration(seconds: 5);

class LoginNotRememberedScreen {

  LoginNotRememberedScreen();

  Future<void> informUserAndPassword(PatrolIntegrationTester $, String documentID, String password) async{
    await $(#inputDocument).enterText(documentID);
    await $(#inputPassword).enterText(password);
  }

  Future<void> grandPermissionIfRequired(PatrolIntegrationTester $) async {
    if (Platform.isIOS && Platform.localeName == "pt_BR") { //useful when language is different from en_US on iOS
      if (!await Permission.location.isGranted) {
        await $.native.tap(
          Selector(text: 'Permitir Durante o Uso do App'),
          appId: 'com.apple.springboard',
        ).onError((error, stackTrace) => print(error.toString()));
      }
    }else {
      if (!await Permission.location.isGranted) {
        if (await $.native.isPermissionDialogVisible(timeout: _timeout)) {
          await $.native.grantPermissionWhenInUse();
        }
        await $.pump();
      }
    }
  }

  Future<void> tapButtonLogin(PatrolIntegrationTester $) async {
    await $(#buttonLogin).scrollTo().tap();
  }

  Future<void> checkTextAlertDialogMessage(PatrolIntegrationTester $, String checkText) async {
    await $(#alertDialogMessage).waitUntilVisible();
    expect($(#alertDialogMessage).text, checkText);
  }
}
