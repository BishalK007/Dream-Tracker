import 'package:flutter/material.dart';

import '../colors.dart';

class PreferenceDetails extends StatefulWidget {
  final String preference;
  const PreferenceDetails({super.key, required this.preference});

  @override
  State<PreferenceDetails> createState() => _PreferenceDetailsState();
}

class _PreferenceDetailsState extends State<PreferenceDetails> {
  final _formKey = GlobalKey<FormState>();
  var _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _goalAmtController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _goalAmtController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.preference;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.horizontal_rule),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Enter Preference Details",
                style: TextStyle(
                    fontSize: 20,
                    color: myPrimarySwatch,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: true,
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter preference name",
                          prefix: Icon(Icons.notes),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter valid preference';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        autofocus: true,
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter preference description",
                          prefix: Icon(Icons.book),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _goalAmtController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter goal amount",
                          prefix: Icon(Icons.currency_rupee),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.parse(value) == 0) {
                            return 'Please enter valid amount';
                          }
                          return null;
                        },
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
