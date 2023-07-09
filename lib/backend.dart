import 'package:dream_tracker/global_variables.dart';

Stream<List<GoalData>> getGoalListStream() async* {
  List<GoalData> goals = [
    GoalData(
        id: "1",
        title: "Save up for a new car",
        notes: "I need a reliable car for work",
        amountSaved: 5000,
        goalAmount: 20000),
    GoalData(
        id: "2",
        title: "Take a trip to Hawaii",
        notes: "I've always wanted to see the beaches",
        amountSaved: 0,
        goalAmount: 10000),
    GoalData(
        id: "3",
        title: "Pay off credit card debt",
        notes: "I want to improve my credit score",
        amountSaved: 1000,
        goalAmount: 5000),
  ];

  // while (true) {
  // await Future.delayed(
  //   const Duration(seconds: 5),
  // );
  yield goals;
  // }
}

Stream<GoalData> getGoalItemStream() async* {
  GoalData goal = GoalData(
    id: "1",
    title: "Save up for a new car",
    notes:
        "I need a reliable car for workI need a reliable car for workI need a reliable car for workI need a reliable car for workI need a reliable car for workI need a reliable car for workI need a reliable car for workI need a reliable car for workI need a reliable car for workI need a reliable car for workI need a reliable car for workI need a reliable car for workI need a reliable car for workI need a reliable car for workI need a reliable car for workI need a reliable car for workI need a reliable car for work",
    amountSaved: 21000,
    goalAmount: 20000,
  );

  // while (true) {
  // await Future.delayed(const Duration(seconds: 5));
  yield goal;
  // }
}
