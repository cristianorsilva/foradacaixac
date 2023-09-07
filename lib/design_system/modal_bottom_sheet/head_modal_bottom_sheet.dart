import 'package:flutter/material.dart';

class HeadModalBottomSheet extends StatelessWidget {
  final String title;

  const HeadModalBottomSheet({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration:
          const BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: const Icon(
                  Icons.clear_rounded,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(bottom: 15)),
          Row(children: [
            Text(
              title,
              key: key,
              style: Theme.of(context).textTheme.headline2,
            )
          ]),
        ],
      ),
    );
  }
}
