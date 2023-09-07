import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

class PixScreen{
  final Finder _inkWellPixTransfer = find.byKey(const Key('inkWellPixTransfer'));
  final Finder _inkWellPixReceive = find.byKey(const Key('inkWellPixReceive'));
  final Finder _inkWellPixCopyPaste = find.byKey(const Key('inkWellPixCopyPaste'));
  final Finder _inkWellPixQRPayment = find.byKey(const Key('inkWellPixQRPayment'));
  final Finder _inkWellPixMyKeys = find.byKey(const Key('inkWellPixMyKeys'));
  final Finder _inkWellPixFavorites = find.byKey(const Key('inkWellPixFavorites'));

  PixScreen();

  Future<void> tapPixTransfer(PatrolIntegrationTester $) async {
    await $(#inkWellPixTransfer).tap();
  }

  Future<void> tapMyKeys(PatrolIntegrationTester $) async {
    await $(#inkWellPixMyKeys).tap();
  }

}