import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_tracker/backend.dart';
import 'package:dream_tracker/colors.dart';
import 'package:dream_tracker/widgets/home_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      builder: (context, listSnapShot) {
        if (listSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (listSnapShot.hasError) {
          return const Center(
            child: Text('Something went wrong... '),
          );
        } else if (listSnapShot.data!.isEmpty) {
          return const Center(
            child: Text('Add Something to Show Here...'),
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: listSnapShot.data!.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: isShared(listSnapShot.data![index]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.data == false) {
                    return HomeCard(
                      id: listSnapShot.data![index],
                    );
                  }
                  return Badge(
                    backgroundColor: myPrimarySwatch,
                    label: const Text(
                      "SHARED",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    alignment: Alignment.topLeft,
                    child: HomeCard(
                      id: listSnapShot.data![index],
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
