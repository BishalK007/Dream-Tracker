import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PreferenceCards extends StatefulWidget {
  final int id;
  final IconData icon;
  final String name;

  const PreferenceCards(
      {super.key, required this.id, required this.icon, required this.name});

  @override
  State<PreferenceCards> createState() => _PreferenceCardsState();
}

class _PreferenceCardsState extends State<PreferenceCards> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black,
      child: InkWell(
        onTap: () {
          print(widget.id);
        },
        child: ListTile(
          leading: Icon(widget.icon),
          title: Text(widget.name),
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
        ),
      ),
    );
  }
}
