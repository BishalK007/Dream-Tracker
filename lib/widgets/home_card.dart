import 'package:dream_tracker/backend.dart';
import 'package:dream_tracker/colors.dart';
import 'package:dream_tracker/global_variables.dart';
import 'package:dream_tracker/pages/add_money_page.dart';
import 'package:dream_tracker/widgets/ad_place.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hidable/hidable.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bullet_list/flutter_bullet_list.dart';

import '../pages/editPreferenceDetails.dart';

class HomeCard extends StatefulWidget {
  const HomeCard({super.key, required this.id});
  final String id;

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  NumberFormat formatter = NumberFormat.decimalPattern('en-IN');
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getGoalItemStream(widget.id),
      builder: (context, itemSnapShot) {
        if (itemSnapShot.hasError) {
          return const Center(
            child: Text('Dang!! Couldnt fetch data'),
          );
        } else if (itemSnapShot.connectionState == ConnectionState.waiting) {
          return ExpansionTileCard(
            initialPadding: const EdgeInsets.symmetric(vertical: 8),
            initialElevation: 5,
            elevation: 5,
            leading: Icon(icons[0]),
            title: const Text('Title'),
            subtitle: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //
                //________ Progress Bar
                //
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: LinearProgressIndicator(
                    value: 1,
                  ),
                ),
                //
                // ______ amount text __
                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '50 / 100',
                    )
                  ],
                ),
              ],
            ),
            children: [
              //
              // __________ Expandable Text __//
              //
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ExpandableText(
                  "Notes...",
                  expandText: 'Show More',
                  collapseText: 'Show Less',
                ),
              ),
              //
              // ____________ Ad Place __//
              //
              Container(),
              //
              // ____________ Buttons Place __//
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //
                  //________ Add Button ______//
                  //
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Add Money'),
                  ),
                  //
                  //________ Three Buttons ______//
                  //
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          // Handle button tap
                        },
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: const Color(0xFFebddff),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 30.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        } else {
          //
          //____ Expansion Card ______//
          //
          return ExpansionTileCard(
            shadowColor: Colors.black,
            initialPadding: const EdgeInsets.symmetric(vertical: 8),
            finalPadding: EdgeInsets.zero,
            initialElevation: 8,
            elevation: 8,
            leading: Icon(icons[itemSnapShot.data!.index]),
            title: Text(itemSnapShot.data!.title),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //
                //________ Progress Bar
                //
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: LinearProgressIndicator(
                    value: (itemSnapShot.data!.amountSaved >
                            itemSnapShot.data!.goalAmount)
                        ? 1
                        : itemSnapShot.data!.amountSaved /
                            itemSnapShot.data!.goalAmount,
                    color: (itemSnapShot.data!.amountSaved >
                            itemSnapShot.data!.goalAmount)
                        ? Colors.red.shade900
                        : (itemSnapShot.data!.amountSaved ==
                                itemSnapShot.data!.goalAmount)
                            ? Colors.green.shade800
                            : myPrimarySwatch,
                  ),
                ),
                //
                // ______ amount text __
                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      (itemSnapShot.data!.amountSaved >
                              itemSnapShot.data!.goalAmount)
                          ? 'Exceeded!!  '
                          : (itemSnapShot.data!.amountSaved ==
                                  itemSnapShot.data!.goalAmount)
                              ? 'Goal Reached!!  '
                              : ' ',
                    ),
                    Text(
                      '₹${formatter.format(itemSnapShot.data!.amountSaved)} / ₹${formatter.format(itemSnapShot.data!.goalAmount)}',
                    )
                  ],
                ),
              ],
            ),
            children: [
              //
              // __________ Expandable Description Text __//
              //
              Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ExpandableText(
                    'Notes : ${itemSnapShot.data!.notes}',
                    expandText: 'Show More',
                    collapseText: 'Show Less',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Owned By: ${itemSnapShot.data!.createdBy}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: myPrimarySwatch,
                  ),
                ),
              ),
              //
              // __________ See Sugession __//
              //
              Visibility(
                visible: (itemSnapShot.data!.title == 'Buy a Bike' ||
                        itemSnapShot.data!.title == 'Books and Magazines' ||
                        itemSnapShot.data!.title == 'Buy a Car' ||
                        itemSnapShot.data!.title == 'Fashion & Style' ||
                        itemSnapShot.data!.title == 'Health and Wellness' ||
                        itemSnapShot.data!.title == 'Tech & Gadgets' ||
                        itemSnapShot.data!.title == 'Travel and Vacation')
                    ? true
                    : false,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                          color: myPrimarySwatch,
                        ),
                        TextButton(
                          child: const Text('See Sugessions'),
                          onPressed: () {
                            //
                            //____ Sugession Bottom Sheet ________//
                            //
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return BulletSugessions(
                                  preference: itemSnapShot.data!.title,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //
              // ____________ Ad Place __//
              //
              AdPlace(
                goalAmt: itemSnapShot.data!.goalAmount,
                title: itemSnapShot.data!.title,
              ),
              //
              // ____________ Buttons Place __//
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //
                  //________ Add Button ______//
                  //
                  ElevatedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => FractionallySizedBox(
                          heightFactor: 0.8,
                          child: AddMoney(
                              goalId: itemSnapShot.data!.id,
                              preference: itemSnapShot.data!.title,
                              description: itemSnapShot.data!.notes,
                              savedAmt: itemSnapShot.data!.amountSaved,
                              goalAmt: itemSnapShot.data!.goalAmount),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Money'),
                  ),
                  //
                  //________ Three Buttons ______//
                  //
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: InkWell(
                            onTap: () {
                              // Handle button tap
                              if (index == 0) {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) => SizedBox(
                                    height: 120,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Share your goal",
                                          style: TextStyle(
                                              color: myPrimarySwatch,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  widget.id,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 12.5),
                                              child: IconButton(
                                                icon: const Icon(Icons.copy),
                                                onPressed: () {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                          text: widget.id));
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    padding: EdgeInsets.zero,
                                                    content: Container(
                                                      color:
                                                          Colors.green.shade900,
                                                      height: 50,
                                                      child: const Center(
                                                        child: Text(
                                                          "Sync Id Copied to Clipboard",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ));
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else if (index == 2) {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) => FractionallySizedBox(
                                        heightFactor: 0.8,
                                        child: EditPrederence(
                                          description: itemSnapShot.data!.notes,
                                          goalAmt:
                                              itemSnapShot.data!.goalAmount,
                                          goalId: itemSnapShot.data!.id,
                                          preference: itemSnapShot.data!.title,
                                          savedAmt:
                                              itemSnapShot.data!.amountSaved,
                                        )));
                              } else {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) => SizedBox(
                                    height: 170,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 20, 0, 30),
                                          child: Text(
                                            "Want to Delete Your Goal?",
                                            style: TextStyle(
                                                color: myPrimarySwatch,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: List.generate(2, (index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  fixedSize:
                                                      const Size(100, 50),
                                                  //backgroundColor: Colors.black,
                                                  shape:
                                                      const StadiumBorder(), // Background color
                                                ),
                                                onPressed: () {
                                                  if (index == 0) {
                                                    Navigator.pop(context);
                                                  } else {
                                                    deleteGoal(widget.id);
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: (index == 0)
                                                    ? const Text('Cancel')
                                                    : const Text('Delete'),
                                              ),
                                            );
                                          }),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: myPrimarySwatch,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  (index == 0)
                                      ? Icons.share
                                      : (index == 1)
                                          ? Icons.delete
                                          : Icons.edit,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}

class BulletSugessions extends StatefulWidget {
  const BulletSugessions({super.key, required this.preference});
  final String preference;

  @override
  State<BulletSugessions> createState() => _BulletSugessionsState();
}

class _BulletSugessionsState extends State<BulletSugessions> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchSuggestions(widget.preference),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('Couldn\'t find any sugessions'),
          );
        } else {
          var height = MediaQuery.of(context).size.height;
          height = height / 2;
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    // height: 25,
                    child: Column(
                      children: [
                        Icon(
                          Icons.horizontal_rule,
                          color: myPrimarySwatch,
                        ),
                        Center(
                          child: Text(
                            "Suggestions",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: myPrimarySwatch),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: height * 1.5,
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                                  child: Icon(
                                    FontAwesomeIcons.circleChevronRight,
                                    color: myPrimarySwatch,
                                  ),
                                ),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.only(right: 12.5),
                                  child: Text(
                                    snapshot.data![index],
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ))
                              ],
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
