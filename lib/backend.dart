import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_tracker/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      );
    }
    return GoalData(
      amountSaved: snapShot.data()!['amountSaved'],
      goalAmount: snapShot.data()!['goalAmount'],
      id: id,
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

Future<Map<String, dynamic>?> addExistingGoal(String id) async {
  Map<String, dynamic>? data;
  try {
    DocumentSnapshot<Object?> existingGoal = await goals.doc(id).get();
    print(existingGoal);
    data = existingGoal.data() as Map<String, dynamic>?;
    // Access the data from the document
    if (data != null) {
      return data;
    } else {
      print(data);
      return data;
    }
  } catch (error) {
    print("Error during fetching the existing goal: $error");
  }
  return data;
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
