import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PreferenceCards extends StatefulWidget {
  const PreferenceCards({super.key});

  @override
  State<PreferenceCards> createState() => _PreferenceCardsState();
}

class _PreferenceCardsState extends State<PreferenceCards> {
  @override
  Widget build(BuildContext context) {
    return const Card(
      shadowColor: Colors.black,
      child: ListTile(
        leading: Icon(FontAwesomeIcons.book),
        title: Text('Preference'),
        trailing: Icon(Icons.arrow_forward_ios_rounded),
      ),
    );
  }
}
