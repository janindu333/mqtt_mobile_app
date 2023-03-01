import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blocks/blood_request_block_provider.dart';

class MyDialogBox extends StatefulWidget {
  @override
  _MyDialogBoxState createState() => _MyDialogBoxState();
}

class _MyDialogBoxState extends State<MyDialogBox> {
  final _formKey = GlobalKey<FormState>();
  String delayTime = "0";

  @override
  Widget build(BuildContext context) {
    return Consumer<BloodRequestProvider>(
      builder: (context, bloodRequestProvider, child) {
        return AlertDialog(
          title: Text('Enter Delay Time'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Delay Time (seconds)',
                    ),
                    onSaved: (value) {
                      delayTime = value;
                      print("delay time entered : $value");
                    },
                  )
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                // Call save method of form state to trigger onSaved callbacks
                _formKey.currentState.save();

                if (_formKey.currentState.validate()) {
                  bloodRequestProvider.saveDelayTime(time: delayTime);
                  // Do something with the form data
                  print('delay time entered : $delayTime');
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
