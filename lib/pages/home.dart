import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_tracker/colors.dart';
import 'package:dream_tracker/pages/preference_selection_page.dart';
import 'package:dream_tracker/pages/signUp.dart';
import 'package:dream_tracker/widgets/home_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hidable/hidable.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      //____APP BAR And Body
      //
      body: NestedScrollView(
        controller: _controller,
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            //
            //____APP BAR
            //
            SliverAppBar(
              title: const Text('Dashboard'),
              backgroundColor: Theme.of(context).primaryColor,
              actions: [
                PopupMenuButton<int>(
                  tooltip: 'Menu',
                  icon: const Icon(Icons.menu),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: myPrimarySwatch,
                          ),
                          const SizedBox(width: 25),
                          const Text(
                            "Log Out",
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      onTap: () async => {
                        await FirebaseAuth.instance.signOut(),
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const LoginScreen();
                            },
                          ),
                        )
                      },
                    ),
                    // popupmenu item 2
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.delete_rounded, color: myPrimarySwatch),
                          const SizedBox(width: 25),
                          const Text(
                            "Delete User",
                            style: TextStyle(fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                      onTap: () async => {
                        FirebaseFirestore.instance
                            .collection('allUsers')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .delete(),
                        await FirebaseAuth.instance.currentUser?.delete(),
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const LoginScreen();
                            },
                          ),
                        )
                      },
                    ),
                  ],
                  offset: const Offset(0, 55),
                  color: Colors.white,
                  elevation: 2,
                ),
              ],
            ),
          ];
        },
        //
        //____ Body
        //
        body: const HomeBody(),
      ),
      //
      //____Button
      //
      floatingActionButton: Hidable(
        controller: _controller,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              tooltip: "Add Goal",
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => const FractionallySizedBox(
                    heightFactor: 0.8,
                    child: SelectPreference(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
