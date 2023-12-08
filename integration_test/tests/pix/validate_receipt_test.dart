
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
  patrolTest('Validate the "Receipt" screen', ($) async {
    await $.pumpWidgetAndSettle(const MyApp());
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

    await VerifyDataScreen().tapButtonTransfer($);

    //scrolls the screen to make sure other elements are visible
    await TransferReceiptScreen().scrollToTransactionID($);

    $.checkTextOnTextWidgets({
      //check transfer
      TransferReceiptScreen().checkTransferValue($, 'R\$ 1,25'),
      TransferReceiptScreen().checkTransferWhen($, DateFormat('dd/MM/yyyy').format(DateTime.now())),
      TransferReceiptScreen().checkTransferType($, 'Pix'),
      //check recipient
      TransferReceiptScreen().checkRecipientUserName($, 'Joana Ferreira Schimidt'),
      TransferReceiptScreen().checkRecipientDocumentNumber($, '971.147.000-40'),
      TransferReceiptScreen().checkRecipientBankName($, 'Banco Solar'),
      TransferReceiptScreen().checkRecipientAgencyNumber($, '2258-4'),
      TransferReceiptScreen().checkRecipientAccountNumber($, '32542-3'),
      TransferReceiptScreen().checkRecipientAccountType($, 'Conta Corrente'),
      //check sender
      TransferReceiptScreen().checkSenderUserName($, 'João Carlos da Silva'),
      TransferReceiptScreen().checkSenderDocumentNumber($, '929.035.400-39'),
      TransferReceiptScreen().checkSenderBankName($, 'CrediBank'),
      TransferReceiptScreen().checkSenderAgencyNumber($, '0124-5'),
      TransferReceiptScreen().checkSenderAccountNumber($, '12452-6'),
      TransferReceiptScreen().checkSenderAccountType($, 'Conta Corrente'),
      //check transaction id
      TransferReceiptScreen().checkTransactionID($, 'E7565486895648s89657978BH'),
    });

    await TransferReceiptScreen().scrollToClose($);
    await TransferReceiptScreen().tapClose($);
  });
}
