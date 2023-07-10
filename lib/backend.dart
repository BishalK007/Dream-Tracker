import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_tracker/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

Stream<List<String>> getGoalListStream() {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  // if (uid == null) {
  //   return const Stream.empty();
  // }
  return FirebaseFirestore.instance
      .collection('allUsers')
      .doc(uid)
      .snapshots()
      .map((snapShot) {
    final userData = snapShot.data();
    // if (userData == null) {
    //   return [];
    // }
    final goals = List<String>.from(userData!['goals'] ?? []);
    return goals;
  });
}

Stream<GoalData> getGoalItemStream(String id) {
  return FirebaseFirestore.instance
      .collection('allGoals')
      .doc(id)
      .snapshots()
      .map((snapShot) {
    if (snapShot.data() == null) {
      return GoalData(
        amountSaved: 50,
        goalAmount: 100,
        id: id,
        notes: 'notes...',
        title: "title....",
        index: 0,
      );
    }
    return GoalData(
      amountSaved: snapShot.data()!['amountSaved'],
      goalAmount: snapShot.data()!['goalAmount'],
      id: id,
      index: snapShot.data()!['id'],
      notes: snapShot.data()!['notes'],
      title: snapShot.data()!['title'],
    );
  });
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

Future<void> addExistingGoal(String id, BuildContext context) async {
  final QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('allGoals').get();
  final goalExists = snapshot.docs.map((doc) => doc.id).toList().contains(id);
  //
  //__ If id Does not exists globally_________//
  //
  if (!goalExists) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      padding: EdgeInsets.zero,
      content: Container(
        color: Colors.red.shade900,
        height: 50,
        child: const Center(
          child: Text(
            "Invalid Id",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ));
  } else {
    //
    //______ Check if goal Exists for curr user
    //
    bool goalExistsCurrUser = false;

    final User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('allUsers')
            .doc(user!.uid)
            .get();
    final List<dynamic> goals = snapshot.data()?['goals'] ?? [];
    goalExistsCurrUser = goals.contains(id);

    if (goalExistsCurrUser) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        padding: EdgeInsets.zero,
        content: Container(
          color: Colors.green.shade900,
          height: 50,
          child: const Center(
            child: Text(
              "Already in Your Goals",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ));
    } else {
      // Update the 'goals' list field in the document
      FirebaseFirestore.instance
          .collection('allUsers')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
            'goals': FieldValue.arrayUnion([id])
          })
          .then((value) => print('Goal added successfully!'))
          .catchError((error) => print('Error adding goal: $error'));
    }
  }
}

void addExistingGoalToAnotherUser(String goalId) {
  try {
    // Step 1: Get the current user's instance
    final authReference = FirebaseAuth.instance.currentUser;
    // Step 2: Get the Document reference for that user
    DocumentReference userDocument = users.doc(authReference!.uid);
    // Step 3: Add the goal string to the user document
    userDocument.update({
      'goals': FieldValue.arrayUnion([goalId])
    });
  } catch (e) {
    print('Error during adding existing goal to antoher user: $e');
  }
}

Future<void> updateDetails(
    String description, int goalAmt, String goalId) async {
  try {
    goals.doc(goalId).update({
      'notes': description,
      'goalAmount': goalAmt,
    });
  } catch (e) {
    print('Error occured during $e');
  }
}

Future<void> addMoney(int totalSaved, String goalId) async {
  try {
    goals.doc(goalId).update({
      'amountSaved': totalSaved,
    });
  } catch (e) {
    print('Error occured during $e');
  }
}

void deleteGoal(String goalItem) async {
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  final allUsersRef =
      FirebaseFirestore.instance.collection('allUsers').doc(currentUserUid);
  await allUsersRef.update({
    'goals': FieldValue.arrayRemove([goalItem])
  });
}

Future<List<dynamic>> fetchAdPlaceItems(String goal, int goalPrice) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection(goal)
      .where("Price", isLessThanOrEqualTo: goalPrice)
      .orderBy("Price", descending: true)
      .get();
  List<dynamic> adPlaceItems = snapshot.docs.map((doc) {
    Map<String, dynamic> data = (doc.data() as Map<String, dynamic>);
    return data;
  }).toList();
  return adPlaceItems;
}

// Future<List<String>> fetchSuggesions(String preference) async {
//   final Future<List<String>> tips = [] as Future<List<String>>;
//   FirebaseFirestore.instance.collection('allGoals')
//   return tips;
// }