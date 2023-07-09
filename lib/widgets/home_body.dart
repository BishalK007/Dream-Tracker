import 'package:dream_tracker/backend.dart';
import 'package:flutter/material.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getGoalListStream(),
      builder: (context, ListSnapShot) {
        if (ListSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (ListSnapShot.hasError) {
          return const Center(
            child: Text('Something went wrong... '),
          );
        } else if (ListSnapShot.data!.isEmpty) {
          return const Center(
            child: Text('Add Something to Show Here...'),
          );
        } else {
          return ListView.builder(
            itemCount: ListSnapShot.data!.length,
            itemBuilder: (context, index) {
              return Container(
                child: Text(index.toString()),
              );
            },
          );
        }
      },
    );
  }
}
