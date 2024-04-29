import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import '../../share/test_base.dart' as test_base;

class TransferReceiptScreen {

  Future<void> scrollToClose(PatrolIntegrationTester $) async {
    await $(#gestureDetectorClose).scrollTo(scrollDirection: AxisDirection.up);
  }

  Future<void> tapClose(PatrolIntegrationTester $) async {
    await $(#gestureDetectorClose).tap();
  }

  (Function, String) checkReceiptTitle(PatrolIntegrationTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textReceiptTitle', checkText);
  }

  (Function, String) checkTransferValue(PatrolIntegrationTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textTransferValue', checkText);
  }

  (Function, String) checkTransferWhen(PatrolIntegrationTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textTransferDate', checkText, 10);
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

  (Function, String) checkRecipientAccountType(PatrolIntegrationTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textRecipientAccountType', checkText);
  }

  (Function, String) checkSenderUserName(PatrolIntegrationTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textSenderFullUserName', checkText);
  }

  (Function, String) checkSenderDocumentNumber(PatrolIntegrationTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textSenderDocumentNumber', checkText);
  }

  (Function, String) checkSenderBankName(PatrolIntegrationTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textSenderBankName', checkText);
  }

  (Function, String) checkSenderAgencyNumber(PatrolIntegrationTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textSenderAgencyNumber', checkText);
  }

  (Function, String) checkSenderAccountNumber(PatrolIntegrationTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textSenderAccountNumber', checkText);
  }

  (Function, String) checkSenderAccountType(PatrolIntegrationTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textSenderAccountType', checkText);
  }

  (Function, String) checkTransactionID(PatrolIntegrationTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textTransactionID', checkText);
  }

  Future<void> scrollToTransactionID(PatrolIntegrationTester $) async {
    await $(#textTransactionID).scrollTo();
  }
}
