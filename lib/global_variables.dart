import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<String> preferences = [
  "Buy a Car",
  "Buy a Bike",
  "Fashion & Style",
  "Books and Magazines",
  "Health and Wellness",
  "Tech & Gadgets",
  "Travel and Vacation",
  "Add custom preference",
];

List<IconData> icons = [
  FontAwesomeIcons.car,
  FontAwesomeIcons.motorcycle,
  FontAwesomeIcons.shirt,
  FontAwesomeIcons.book,
  FontAwesomeIcons.heartPulse,
  FontAwesomeIcons.mobile,
  FontAwesomeIcons.planeDeparture,
  FontAwesomeIcons.bagShopping,
];

class GoalData {
  final String id;
  final String title;
  final String notes;
  final int amountSaved;
  final int goalAmount;
  GoalData({
    required this.amountSaved,
    required this.goalAmount,
    required this.id,
    required this.notes,
    required this.title,
  });
}

class AdPlaceItem {
  final String title;
  final String description;
  final int price;
  final String imgLink;
  final String productLink;
  AdPlaceItem({
    required this.title,
    required this.description,
    required this.imgLink,
    required this.price,
    required this.productLink,
  });
}
