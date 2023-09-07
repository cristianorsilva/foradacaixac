import 'dart:io';

import 'package:foradacaixac/database/pix_key_type.dart';
import 'package:foradacaixac/main.dart';

import 'package:intl/intl.dart';
import 'package:patrol/patrol.dart';
import '../../screens/home_screen.dart';
import '../../screens/login_not_remembered_screen.dart';
import '../../screens/pix/pix_screen.dart';
import '../../screens/pix/pix_transfer_recipient_screen.dart';
import '../../screens/transfer/transfer_receipt_screen.dart';
import '../../screens/transfer/transfer_value_screen.dart';
import '../../screens/transfer/verify_data_screen.dart';

import '../../share/test_extensions.dart';

void main() {
  patrolTest('Validate the "Transfer Data" screen', nativeAutomation: true, ($) async {
    await $.pumpWidgetAndSettle(const MyApp());
    if (Platform.isAndroid) {
      //await binding.convertFlutterSurfaceToImage();

      //await binding.convertFlutterSurfaceToImage().onError((error, stackTrace) => null);
      //$.tester.
    }
    if (Platform.isIOS) {
      $.tester.testTextInput.register(); //important to run on physical iOS devices
    }
    //performs login
    await LoginNotRememberedScreen().informUserAndPassword($, '92903540039', '172839');
    await LoginNotRememberedScreen().tapButtonLogin($);
    await LoginNotRememberedScreen().grandPermissionIfRequired($);

    //access pix screen
    await HomeScreen().tapPix($);

    await PixScreen().tapPixTransfer($);
    await TransferValueScreen().informValueToTransfer($, '1,25');
    await TransferValueScreen().tapIconContinue($);

    await PixTransferRecipientScreen().selectPixKeyType($, EnumPixKeyType.cpf_cnpj);
    await PixTransferRecipientScreen().informPixKeyToTransfer($, '97114700040');
    await PixTransferRecipientScreen().tapIconContinue($);

    await VerifyDataScreen().scrollToRecipientAccountNumber($);

    //validates the transfer data:
    $.checkTextOnTextWidgets({
      VerifyDataScreen().checkTransferValue($, 'R\$ 1,25'),
      VerifyDataScreen().checkTransferWhen($, 'Agora'),
      VerifyDataScreen().checkTransferType($, 'Pix'),
      VerifyDataScreen().checkRecipientUserName($, 'Joana Ferreira Schimidt'),
      VerifyDataScreen().checkRecipientDocumentNumber($, '***.147.000-**'),
      VerifyDataScreen().checkRecipientBankName($, 'Banco Solar'),
      VerifyDataScreen().checkRecipientAgencyNumber($, '2258-4'),
      VerifyDataScreen().checkRecipientAccountNumber($, '32542-3'),
    });
  });
}
