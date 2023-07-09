import 'package:dream_tracker/global_variables.dart';
import 'package:dream_tracker/widgets/preference_cards.dart';
import 'package:flutter/material.dart';

class SelectPreference extends StatefulWidget {
  const SelectPreference({super.key});

  @override
  State<SelectPreference> createState() => _SelectPreferenceState();
}

class _SelectPreferenceState extends State<SelectPreference> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.horizontal_rule),
            const SizedBox(
              height: 10,
            ),
            const Text("Select your preferences"),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: preferences.length,
                itemBuilder: (context, index) {
                  return PreferenceCards(
                      id: index, icon: icons[index], name: preferences[index]);
                })
          ],
        ),
      ),
    );
  }
}
