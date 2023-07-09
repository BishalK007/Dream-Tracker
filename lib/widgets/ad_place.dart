import 'package:flutter/material.dart';

class AdPlace extends StatefulWidget {
  const AdPlace({super.key});

  @override
  State<AdPlace> createState() => _AdPlaceState();
}

class _AdPlaceState extends State<AdPlace> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.amber,
    );
  }
}
