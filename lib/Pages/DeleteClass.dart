import 'dart:async';

import 'package:flutter/material.dart';

class DeleteClass {
  int number = 0;
  String name = '';

  DeleteClass(this.number, this.name);


  Future<int> deleteValues(BuildContext context) async {
    // Perform deletion logic
    Navigator.of(context).pop();

    AlertDialog deletion = AlertDialog(
      content: Text( "$number $name Deleted Successfully"),

    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return deletion;
      },
    );
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pop();
    return number;


  }


  Future<int> showAlertDialog (BuildContext context) {
    // set up the butto
    Completer<int> completer = Completer<int>();

    // n
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
        completer.complete(0);
// e the dialog when Cancel button is pressed
      },
    );

    Widget okButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        deleteValues(context).then((value) {
          completer.complete(value); // Complete the future with the returned value
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete"),
      content: Text("Are you sure you want to delete $number $name?"),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    return completer.future;

  }
}
