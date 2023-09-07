import 'package:flutter/material.dart';
import 'package:foradacaixac/share/bottom_sheet_fc.dart';

class CircularButtonFC extends StatelessWidget {
  final String label;
  final String imageName;
  final bool showViewAsModal;
  final Widget viewToShow;

  /// Used when the view is not showed as modal
  final RouteSettings? viewToShowSettings;

  const CircularButtonFC(
      {super.key, required this.label, required this.imageName, required this.showViewAsModal, required this.viewToShow, this.viewToShowSettings});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: 60,
            height: 60,
            child: Card(
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () {
                  showViewAsModal
                      ? showModalBottom(viewToShow, context)
                      : Navigator.push(context, MaterialPageRoute(settings: viewToShowSettings, builder: (context) => viewToShow));
                },
                key: key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Ink.image(
                      image: AssetImage('images/$imageName'),
                      fit: BoxFit.cover,
                      width: 32.0,
                      height: 32.0,
                      alignment: Alignment.center,
                    ),
                  ],
                ),
              ),
            )),
        const Padding(padding: EdgeInsets.only(bottom: 5)),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1,
        )
      ],
    );
  }
}

//'images/$imageName'
