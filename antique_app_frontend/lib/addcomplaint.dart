import 'dart:convert';

import 'package:antique_app/services/utilityservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AddComplaint extends StatefulWidget {
  const AddComplaint({super.key});

  @override
  State<AddComplaint> createState() => _AddComplaintState();
}

class _AddComplaintState extends State<AddComplaint> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _subject = '';
  String _complaint = '';
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  UtilityService _utilityService = UtilityService();
  final storage = const FlutterSecureStorage();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with submitting the complaint
      // You can implement your submission logic here
      print('Subject:' + t1.text);
      print('Complaint' + t2.text);
      Map<String, String> allValues = await storage.readAll();
      String? userid = allValues["userid"];
      var detailes = jsonEncode(
          {"userid": userid, "subject": t1.text, "complaint": t2.text});

      try {
        final Response res = await _utilityService.addComplaint(detailes);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Complaint Added"),
                content: Text("Complaint added successfully"),
                actions: [
                  TextButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      } on DioException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error occurred,please try again"),
          duration: Duration(milliseconds: 300),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: t1,
                decoration: InputDecoration(labelText: 'Subject'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
                onSaved: (value) {
                  _subject = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: t2,
                decoration: InputDecoration(labelText: 'Complaint'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a complaint';
                  }
                  return null;
                },
                onSaved: (value) {
                  _complaint = value!;
                },
                maxLines: 5,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
