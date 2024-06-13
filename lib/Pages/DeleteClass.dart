import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mynotebook2/Database/helpers/UserHelper.dart';
import 'package:sqflite/sqflite.dart';

class DeleteClass {
  int number = 0;
  String name = '';
   dynamic list ;

  DeleteClass(this.number, this.name,this.list);

  UserHelper userHelper = UserHelper();


  Future<int> deleteNotes  () async{
    print("list is ${list}");
    String ids = list.join(',');
    Database db = await userHelper.database;
    var datanotes =  await db.delete("notes",  where: 'id IN ($ids)');
    return datanotes;

  }
  Future<int> deleteValues(BuildContext context) async {
    // Perform deletion logic
    Navigator.of(context).pop();
    var deleted = await deleteNotes();

    AlertDialog deletion = AlertDialog(

      content: Text( deleted>0 ? "$deleted $name Deleted Successfully":"Failed to delete !!!" ),

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
