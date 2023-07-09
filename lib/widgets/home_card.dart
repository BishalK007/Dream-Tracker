import 'package:dream_tracker/backend.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

class HomeCard extends StatefulWidget {
  const HomeCard({super.key, required this.id});
  final id;

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getGoalItemStream(),
      builder: (context, itemSnapShot) {
        if (itemSnapShot.connectionState == ConnectionState.waiting ||
            itemSnapShot.hasError) {
          return const Center(
            child: Text('Dang!! Couldnt fetch data'),
          );
        } else {
          return ExpansionTileCard(
            title: Text(itemSnapShot.data!.title),
          );
        }
      },
    );
  }
}
