import 'package:flutter/material.dart';

Future showModalBottom(Widget view, BuildContext context) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: view,
      );
    },
  );
}
