// ignore_for_file: use_build_context_synchronously

// import 'package:auth_testing/backend/database.dart';
// import 'package:auth_testing/colors.dart';
// import 'package:auth_testing/global_variables.dart';
// import 'package:auth_testing/pages/preference_selection_page.dart';
import 'package:flutter/material.dart';

import '../global_variables.dart';

class FirebasePreferenceFetchWidget extends StatefulWidget {
  final Map<String, dynamic>? datalist;
  final String docId;
  const FirebasePreferenceFetchWidget(
      {super.key, required this.datalist, required this.docId});

  @override
  State<FirebasePreferenceFetchWidget> createState() =>
      _FirebasePreferenceFetchWidgetState();
}

class _FirebasePreferenceFetchWidgetState
    extends State<FirebasePreferenceFetchWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _goalAmountController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    _goalAmountController.text = widget.datalist!['goalAmount'].toString();
    super.initState();
    _titleController.text = (widget.datalist!['id'] <= 6)
        ? preferences[widget.datalist!['id']]
        : "";
  }

  @override
  void dispose() {
    _titleController.dispose();
    _goalAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Icon(
              Icons.horizontal_rule,
              //color: myPrimarySwatch,
            ),
            Text(
              "Enter preference details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                //color: myPrimarySwatch,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const SizedBox(height: 16),
                      TextFormField(
                        style: const TextStyle(color: Colors.black),
                        initialValue: widget.datalist!['title'].toString(),
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                          prefix: Icon(Icons.notes, size: 18),
                          labelText: 'Enter your goal',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          // enabledBorder: OutlineInputBorder(),
                        ),
                        // readOnly: true,
                        enabled: false,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        style: const TextStyle(color: Colors.black),
                        initialValue: widget.datalist!['notes'].toString(),
                        cursorColor: Colors.black,
                        // readOnly: true,
                        enabled: false,
                        decoration: const InputDecoration(
                          prefix: Icon(Icons.book, size: 18),
                          labelText: 'Previous notes',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          // enabledBorder: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: TextFormField(
                              style: const TextStyle(color: Colors.black),
                              initialValue: (widget.datalist!['goalAmount'] -
                                      widget.datalist!['amountSaved'])
                                  .toString(),
                              cursorColor: Colors.black,
                              decoration: const InputDecoration(
                                prefix: Icon(Icons.currency_rupee, size: 18),
                                labelText: 'Remaining amount',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              // readOnly: true,
                              enabled: false,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            fit: FlexFit.loose,
                            child: TextFormField(
                              style: const TextStyle(color: Colors.black),
                              controller: _goalAmountController,
                              cursorColor: Colors.black,
                              decoration: const InputDecoration(
                                prefix: Icon(Icons.currency_rupee, size: 18),
                                labelText: 'Goal amount',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value == '0') {
                                  return 'Please enter a valid amount';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: (() {
                              Navigator.pop(context);
                            }),
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(100, 50),
                              //backgroundColor: Colors.black,
                              shape: const StadiumBorder(), // Background color
                            ),
                            child: const Text("Back"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(100, 50),
                              //backgroundColor: Colors.black,
                              shape: const StadiumBorder(), // Background color
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                //add the goal details to the database
                                Navigator.pop(context);
                                Navigator.pop(context);
                                // Bishal's Work
                                // Show the list from the given values
                                // await updateGoals(
                                //     int.parse(_goalAmountController.text),
                                //     widget.docId);
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
