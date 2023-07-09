import 'package:dream_tracker/backend.dart';
import 'package:dream_tracker/colors.dart';
import 'package:dream_tracker/global_variables.dart';
import 'package:dream_tracker/pages/add_money_page.dart';
import 'package:dream_tracker/widgets/ad_place.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/services.dart';

import '../pages/editPreferenceDetails.dart';

class HomeCard extends StatefulWidget {
  const HomeCard({super.key, required this.id});
  final String id;

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
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
            leading: const Icon(Icons.circle),
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
              const AdPlace(),
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
                      print("Add m");
                    },
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
                            color: Color(0xFFebddff),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(0, 3),
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
            leading: const Icon(Icons.abc),
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
                      '${itemSnapShot.data!.amountSaved}/${itemSnapShot.data!.goalAmount}',
                    )
                  ],
                ),
              ],
            ),
            children: [
              //
              // __________ Expandable Text __//
              //
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ExpandableText(
                  itemSnapShot.data!.notes,
                  expandText: 'Show More',
                  collapseText: 'Show Less',
                ),
              ),
              //
              // ____________ Ad Place __//
              //
              const AdPlace(),
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
                  Row(
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
                                builder: (context) => Container(
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
                                                Clipboard.setData(ClipboardData(
                                                    text: widget.id));
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content: Center(
                                                    child: Text(
                                                        'Text copied to clipboard'),
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
                                        goalAmt: itemSnapShot.data!.goalAmount,
                                        goalId: itemSnapShot.data!.id,
                                        preference: itemSnapShot.data!.title,
                                        savedAmt:
                                            itemSnapShot.data!.amountSaved,
                                      )));
                            } else {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => Container(
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                fixedSize: const Size(100, 50),
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
                                  offset: Offset(0, 3),
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
                ],
              ),
            ],
          );
        }
      },
    );
  }
}
