import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_tracker/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

// Create a CollectionReference called users that references the firestore collection
// for all_users collections
CollectionReference users = FirebaseFirestore.instance.collection('allUsers');
// Create a collection reference for global Goals section for the users
CollectionReference goals = FirebaseFirestore.instance.collection('allGoals');
Future<void> addUser() {
// Create a firebase auth instance for the current user of the application
  final authReference = FirebaseAuth.instance.currentUser;
  // Call the user's CollectionReference to add a new user
  return users
      .doc(authReference!.uid)
      .set({
        'uid': authReference.uid,
        'goals': [],
        'email': authReference.email,
        'email_verified': authReference.emailVerified,
        'creation_time': authReference.metadata.creationTime,
        'photo_url': authReference.photoURL,
        'phone_number': authReference.phoneNumber,
      })
      .then((value) => print('User Added'))
      .catchError((error) => print('Failed to add user: $error'));
}

Future<void> updateUser() async {
  final authReference = FirebaseAuth.instance.currentUser;
  await authReference!.reload(); //refreshes the current user data
  try {
    await users.doc(authReference.uid).update({
      'email_verified': authReference.emailVerified,
      'photo_url': authReference.photoURL,
      'phone_number': authReference.phoneNumber,
    });
    print('User Updated');
  } catch (error) {
    print('Failed to update user: $error');
  }
}

Future<void> addGoals(
    String preference, String description, int goalAmount, int id) async {
  try {
    // Step 1: Get the current user's instance
    final authReference = FirebaseAuth.instance.currentUser;
    // Step 2: Get the Document reference for that user
    DocumentReference userDocument = users.doc(authReference!.uid);
    // Step 3: Add the current goal to the Global goals section
    final newGoalRef = await goals.add({
      'id': id,
      'title': preference,
      'notes': description,
      'goalAmount': goalAmount,
      'amountSaved': 0,
    });
    final goalId =
        newGoalRef.id; // this is the currently created document reference id
    print('Goal:$goalId added successfully');
    // Step 4: Add this goal id in the goal list of current user
    return userDocument.update({
      'goals': FieldValue.arrayUnion([goalId])
    });
  } catch (e) {
    print('Error occured during $e');
  }
}
