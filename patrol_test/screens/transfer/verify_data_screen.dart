import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import '../../share/test_base.dart' as test_base;

class VerifyDataScreen {

  Future<void> tapButtonTransfer(PatrolIntegrationTester $) async {
    await $(#buttonTransfer).tap();
  }

  (Function, String) checkTransferValue(PatrolIntegrationTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textTransferValue', checkText);
  }

  (Function, String) checkTransferWhen(PatrolIntegrationTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textTransferDate', checkText);
  }

  (Function, String) checkTransferType(PatrolIntegrationTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textTransferType', checkText);
  }

  (Function, String) checkRecipientUserName(PatrolIntegrationTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textRecipientFullUserName', checkText);
  }

  (Function, String) checkRecipientDocumentNumber(PatrolIntegrationTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textRecipientDocumentNumber', checkText);
  }

  (Function, String) checkRecipientBankName(PatrolIntegrationTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textRecipientBankName', checkText);
  }

  (Function, String) checkRecipientAgencyNumber(PatrolIntegrationTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textRecipientAgencyNumber', checkText);
  }

  (Function, String) checkRecipientAccountNumber(PatrolIntegrationTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textRecipientAccountNumber', checkText);
  }

  Future<void> scrollToRecipientAccountNumber(PatrolIntegrationTester $) async {
    await $(#textRecipientAccountNumber).scrollTo();
  }

/*
  Function checkTransferWhen(PatrolTester $, String checkText) {
    return () {
      String? data = $(#textTransferDate).text;
      expect(data, checkText);
    };
  }
*/
}
