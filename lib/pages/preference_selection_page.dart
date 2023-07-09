import 'package:dream_tracker/colors.dart';
import 'package:dream_tracker/global_variables.dart';
import 'package:dream_tracker/widgets/preference_cards.dart';
import 'package:flutter/material.dart';

import '../backend.dart';
import 'firebasePreferenceFetch.dart';

class SelectPreference extends StatefulWidget {
  const SelectPreference({super.key});

  @override
  State<SelectPreference> createState() => _SelectPreferenceState();
}

class _SelectPreferenceState extends State<SelectPreference> {
  final _syncController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _syncController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.horizontal_rule),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Sync a preference",
                style: TextStyle(
                    fontSize: 20,
                    color: myPrimarySwatch,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _syncController,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Enter sync id",
                    prefix: const Icon(Icons.sync),
                    suffix: CircleAvatar(
                      radius: 16,
                      child: InkWell(
                          onTap: () async {
                            Map<String, dynamic>? datalist =
                                await addExistingGoal(_syncController.text);
                            // ignore: use_build_context_synchronously
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => FractionallySizedBox(
                                      heightFactor: 0.8,
                                      child: FirebasePreferenceFetchWidget(
                                        datalist: datalist,
                                        docId: _syncController.text,
                                      ),
                                    ));
                          },
                          child: const Icon(Icons.add)),
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 75),
                child: Divider(
                  thickness: 2.5,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Select your preferences",
                style: TextStyle(
                    fontSize: 20,
                    color: myPrimarySwatch,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: preferences.length,
                  itemBuilder: (context, index) {
                    return PreferenceCards(
                        id: index,
                        icon: icons[index],
                        name: preferences[index]);
                  }),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
