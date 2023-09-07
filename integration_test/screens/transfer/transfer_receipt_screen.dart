import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import '../../share/test_base.dart' as test_base;

class TransferReceiptScreen {

  Future<void> scrollToClose(PatrolTester $) async {
    await $(#gestureDetectorClose).scrollTo(scrollDirection: AxisDirection.up);
  }

  Future<void> tapClose(PatrolTester $) async {
    await $(#gestureDetectorClose).tap();
  }

  (Function, String) checkReceiptTitle(PatrolTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textReceiptTitle', checkText);
  }

  (Function, String) checkTransferValue(PatrolTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textTransferValue', checkText);
  }

  (Function, String) checkTransferWhen(PatrolTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textTransferDate', checkText, 10);
  }

  (Function, String) checkTransferType(PatrolTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textTransferType', checkText);
  }

  (Function, String) checkRecipientUserName(PatrolTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textRecipientFullUserName', checkText);
  }

  (Function, String) checkRecipientDocumentNumber(PatrolTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textRecipientDocumentNumber', checkText);
  }

  (Function, String) checkRecipientBankName(PatrolTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textRecipientBankName', checkText);
  }

  (Function, String) checkRecipientAgencyNumber(PatrolTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textRecipientAgencyNumber', checkText);
  }

  (Function, String) checkRecipientAccountNumber(PatrolTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textRecipientAccountNumber', checkText);
  }

  (Function, String) checkRecipientAccountType(PatrolTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textRecipientAccountType', checkText);
  }

  (Function, String) checkSenderUserName(PatrolTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textSenderFullUserName', checkText);
  }

  (Function, String) checkSenderDocumentNumber(PatrolTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textSenderDocumentNumber', checkText);
  }

  (Function, String) checkSenderBankName(PatrolTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textSenderBankName', checkText);
  }

  (Function, String) checkSenderAgencyNumber(PatrolTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textSenderAgencyNumber', checkText);
  }

  (Function, String) checkSenderAccountNumber(PatrolTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textSenderAccountNumber', checkText);
  }

  (Function, String) checkSenderAccountType(PatrolTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textSenderAccountType', checkText);
  }

  (Function, String) checkTransactionID(PatrolTester $, String checkText) {
    return test_base.checkTextFromWidget($, 'textTransactionID', checkText);
  }

  Future<void> scrollToTransactionID(PatrolTester $) async {
    await $(#textTransactionID).scrollTo();
  }
}
