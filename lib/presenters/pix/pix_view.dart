import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foradacaixac/presenters/pix/pix_copy_and_paste_view.dart';
import 'package:foradacaixac/presenters/pix/pix_favorites_view.dart';
import 'package:foradacaixac/presenters/pix/pix_keys_view.dart';
import 'package:foradacaixac/presenters/pix/pix_qrcode_view.dart';
import 'package:foradacaixac/presenters/pix/pix_receive_view.dart';
import 'package:sqflite/sqflite.dart';

import '../../database/database_helper.dart';
import '../../database/transaction_type.dart';
import '../../database/user.dart';
import '../../database/user_account.dart';

import 'package:foradacaixac/design_system/modal_bottom_sheet/head_modal_bottom_sheet.dart';
import 'package:foradacaixac/share/bottom_sheet_fc.dart';

import '../../database/user_pix_key.dart';
import '../../database/user_transaction.dart';
import '../transfer/transfer_value_view.dart';

class PixView extends StatefulWidget {
  final User user;
  final List<UserAccount> listUserAccount;

  const PixView({super.key, required this.user, required this.listUserAccount});

  @override
  State<PixView> createState() => _PixViewState();
}

class _PixViewState extends State<PixView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeadModalBottomSheet(title: 'Pix'),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                child: IntrinsicWidth(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customCardPix('Transferir\ncom Pix', 'transfer.png', TransferValueView, 'Transferir com Pix', 'inkWellPixTransfer'),
                        customCardPix('Receber\ncom Pix', 'deposit.png', PixReceiveView, 'Depositar com Pix', 'inkWellPixReceive'),
                        customCardPix('Pix Copia\ne Cola', 'copy_paste.png', PixCopyAndPasteView, 'Pix Copia e Cola', 'inkWellPixCopyPaste'),
                      ],
                    ),
                  ),
                )),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                child: IntrinsicWidth(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customCardPix('Pagar com\nQR Code', 'qr_code.png', PixQRCodeView, 'Pagamento Pix QR Code', 'inkWellPixQRPayment'),
                        customCardPix('Minhas Chaves', 'keys.png', PixKeysView, 'Minhas Chaves', 'inkWellPixMyKeys'),
                        customCardPix('Meus Favoritos', 'favorite.png', PixFavoritesView, 'Meus Favoritos', 'inkWellPixFavorites'),
                      ],
                    ),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Movimentações', style: Theme.of(context).textTheme.displaySmall),
          ),
          const SingleChildScrollView(
            scrollDirection: Axis.vertical,
          ),
        ],
      ),
    );
  }

  Widget customCardPix(String labelButton, String imageName, Type page, String pageTitle, String key) {
    return SizedBox(
        width: 105,
        height: 120,
        child: Card(
          child: InkWell(
            key: Key(key),
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 5)),
                Ink.image(
                  image: AssetImage('images/$imageName'),
                  fit: BoxFit.scaleDown,
                  width: 32.0,
                  height: 32.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, bottom: 5, top: 15),
                  child: Text(
                    labelButton,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            onTap: () async {
              UserTransaction userTransaction = UserTransaction();
              Database db = await DatabaseHelper().initDb();

              if (identical(page, TransferValueView)) {
                TransactionType? transactionType = await TransactionType().getTransactionType(describeEnum(EnumTransactionType.Pix), db);
                int idTransactionType = transactionType!.id;
                userTransaction.idTransactionType = idTransactionType;
                if(!mounted) return;
                showModalBottom(
                    TransferValueView(
                        user: widget.user, pageTitle: pageTitle, userTransaction: userTransaction, listUserAccount: widget.listUserAccount),
                    context);
              } else if (identical(page, PixKeysView)) {
                List<UserPixKey> listUserPixKey = await UserPixKey().getAllPixKeyFromUser(widget.user.id, db);
                if(!mounted) return;
                await showModalBottom(PixKeysView(user: widget.user, listUserPixKey: listUserPixKey), context);
              }
            },
          ),
          //shape: CircleBorder(),
        ));
  }
}
