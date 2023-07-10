import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../backend.dart';
import '../colors.dart';

class AddMoney extends StatefulWidget {
  final String goalId;
  final String preference;
  final String description;
  final int savedAmt;
  final int goalAmt;
  const AddMoney({
    super.key,
    required this.goalId,
    required this.preference,
    required this.description,
    required this.savedAmt,
    required this.goalAmt,
  });

  @override
  State<AddMoney> createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _goalIdController = TextEditingController();
  final TextEditingController _preferenceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addMoneyController = TextEditingController();
  final TextEditingController _goalAmtController = TextEditingController();
  NumberFormat _formatter = NumberFormat.decimalPattern('en-IN');

  @override
  void initState() {
    super.initState();
    _goalIdController.text = widget.goalId;
    _preferenceController.text = widget.preference;
    _descriptionController.text = widget.description;
    _goalAmtController.text = _formatter.format(widget.goalAmt).toString();
  }

  @override
  void dispose() {
    _goalIdController.dispose();
    _preferenceController.dispose();
    _descriptionController.dispose();
    _addMoneyController.dispose();
    _goalAmtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.horizontal_rule,
              color: myPrimarySwatch,
            ),
            Center(
              child: Text(
                "Edit preference details",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: myPrimarySwatch),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _preferenceController,
                        decoration: const InputDecoration(
                          labelText: 'Goal',
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(),
                        ),
                        enabled: false,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        style: const TextStyle(color: Colors.black),
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(),
                        ),
                        enabled: false,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: TextFormField(
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]')),
                                TextInputFormatter.withFunction(
                                    (oldValue, newValue) {
                                  final int? parsed =
                                      int.tryParse(newValue.text);
                                  // try {
                                    final String formatted =
                                        _formatter.format(parsed);
                                    return TextEditingValue(
                                      text: formatted,
                                      selection: TextSelection.collapsed(
                                          offset: formatted.length),
                                    );
                                  // } catch (e) {
                                  //   return const TextEditingValue();
                                  // }
                                }),
                              ],
                              controller: _addMoneyController,
                              decoration: const InputDecoration(
                                labelText: 'Add Money',
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    int.parse(value) == 0) {
                                  return 'Enter valid amount';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.black),
                              controller: _goalAmtController,
                              decoration: const InputDecoration(
                                labelText: 'Goal Amount',
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(),
                              ),
                              enabled: false,
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
                            onPressed: () {
                              _addMoneyController.text =
                                  _addMoneyController.text.replaceAll(",", "");
                              if (_formKey.currentState!.validate()) {
                                //todo add money submit
                                addMoney(
                                    widget.savedAmt +
                                        int.parse(_addMoneyController.text),
                                    widget.goalId);
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Add'),
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
