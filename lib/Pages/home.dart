import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mynotebook2/Database/helpers/UserHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mynotebook2/Pages/DeleteClass.dart';
import 'package:mynotebook2/Pages/Editnote.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  // final showBottomNavBar = false; // Variable to control visibility of BottomNavigationBar
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DeleteClass indelete; // Declare indelete variable
  UserHelper userHelper = UserHelper();

  int _counter = 0;
  bool showBottomNavBar =false; // Variable to control visibility of BottomNavigationBar
  bool longPressed = false;
  bool? _isChecked = false;
  bool? _selected =false;
  int itemCounter =0;
  int theitemCounter =0;
  var dataNotes =[];

  void initState() {

    super.initState();
    setState(() {
      getUserNotes();
    });

  }

  void getUserNotes() async
  {
    print("itemCounter ${itemCounter}");
    dataNotes= await getnotes();
    if(dataNotes.length>0){
      setState(() {

        itemCounter = dataNotes.length;
print("itemCounter ${itemCounter}");
      });
    }else{
      itemCounter =0;
    }
  }
  Future<List> getnotes  () async{
    Database db = await userHelper.database;
    var datanotes =  await db.query('notes');
    return datanotes;

  }
  // Future<int> deleteNotes  () async{
  //   String ids = checker.join(',');
  //   Database db = await userHelper.database;
  //   var datanotes =  await db.delete("notes",  where: 'id IN ($ids)');
  //   return datanotes;
  //
  // }


  var checker = [];

  void _showDeleteDialog() async {
    DeleteClass deleteClass = DeleteClass(checker.length, "note",checker);
    int feedback = await deleteClass.showAlertDialog(context);
    // print('Feedback: $feedback');
    // print('Feedback: $checker');
 // var deleted = await deleteNotes();
    if (checker.length == feedback) {

      // print("deleted are ${deleted}");
      // print(checker);
      setState(() {
        for (var a = checker.length - 1; a >= 0; a--) {
          checker.removeAt(a);
        }
        if (checker.length == 0) {
          longPressed = false;
          showBottomNavBar = false;

          setState(() {
            getUserNotes();
          });
        }
      });

    }
    // Perform actions based on the feedback value if needed
  }

  void shareContent() async {
    try {
      // final ShareResult result = await Share.shareWithResult("alvin the don");

      // if (result.status == ShareResultStatus.success) {
      //   print('Shared successfully');
      // } else {
      //   print('Share failed');
      // }
    } catch (e) {
      print('Error sharing: $e');
    }
  }

  void _incrementCounter() {

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => Editnote(id:itemCounter,type: 'create',thecontent: '')),
    );
    setState(() {
      // _counter++;
    });
  }

  void checkForIteamInChecker(value) {
    if(_selected!)
    {
      _selected= false;
    }

    if(checker.length ==itemCounter)
    {

      _selected= true;

    }
    if (checker.contains(value)) {
      print(" ${value} is already in the list");
      checker.remove(value);

      _selected = false;

      _counter--;


    } else {
      checker.add(value);

      if(checker.length == itemCounter)
      {
        _selected = true;
      }


      // print(" length is : ${checker.length}");
      _isChecked = true;
    }
    // print(checker);
    if (checker.length == 0) {
      showBottomNavBar = false;
      longPressed = false;
    }
    if (checker.length == 1) {
      showBottomNavBar = true;
      longPressed = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      OrientationBuilder(
        builder: (context, orientation) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.title),
            ),
            body: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      if(checker.length==0 )

                        Text('${itemCounter} ${itemCounter == 1 ? 'Note' : 'Notes'}', style: TextStyle(fontSize: 20)),
                      // Text(
                      //     'Orientation: ${orientation == Orientation.portrait ? 'Portrait' : 'Landscape'}',
                      //     style: TextStyle(fontSize: 20)),
                      if(longPressed && checker.length>0)
                        Text('${checker.length} selected', style: TextStyle(fontSize: 20)),



                    ],
                  ),
                  if(longPressed)Row(
                    mainAxisAlignment: MainAxisAlignment.start,

                    children: [
                      Padding(padding: EdgeInsets.only(left: 5),
                        child:
                        Checkbox(
                          value: _selected,
                          activeColor: Colors.red,
                          onChanged: (value) {
                            setState(() {
                              _selected =value!;
                              print("checker is ${checker}");

                              if(_selected!)
                              {

                                print("checker is ${checker}");
                                for(var a=0; a<itemCounter;a++)
                                {
                                  var picker = dataNotes[a];

                                  if(!checker.contains(picker['id']))
                                    checker.add(picker['id']);
                                }

                              }else{
                                checker.clear();
                              }
                              // checkForIteamInChecker(itemId);
                            });
                          },
                        ),
                      ),
                      Text('All')


                    ],
                  ),
                  SizedBox(
                      height:
                      10), // Add some spacing between the Row and the GridView
                  Expanded(

                    child: GridView.builder(


                      shrinkWrap: true,
                      itemCount: itemCounter, //  item count
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

                        crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {


    if (index != null && index >= 0 && index < dataNotes.length) {
      var note = index != null ? dataNotes[index] : '';
      String noteContent = note['content'];
      return GestureDetector(
        onTap: () {
          if (!longPressed) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Editnote(id: note['id'],
                          type: "update",
                          thecontent: note['content'],collabo:note['collabo'])),
            );
          } else {
            setState(() {
              checkForIteamInChecker(note['id']);
            });
          }
        },
        onLongPress: () {
          setState(() {
            checkForIteamInChecker(note['id']);
          });
        },
        child: Stack(
          children: [
            Container(
              height: orientation == Orientation.portrait ? 500 : 200,
              width: 300,
              padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[100],
                // color: index % 2 == 0 ? Colors.grey : Colors.purple,
              ),

              child: Stack(

                children: [


                  Text(
                    noteContent.length > 100
                        ? "${noteContent.substring(0, 100)} ..."
                        : noteContent                    ,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  if (note['collabo'] ==1 )
                  Positioned(
                    top: 115,
                      left: 133,
                      child: Icon(color:Colors.purple[200],Icons.group_rounded))

                ],

              ),
            ),
            if (longPressed)
              Checkbox(
                value: checker.contains(note['id']),
                activeColor: Colors.red,
                onChanged: (value) {
                  setState(() {
                    checkForIteamInChecker(value);
                  });
                },
              ),
          ],
        ),
      );
    }
                      },
                    ),
                  ),
                ],
              ),
            ),

            floatingActionButton: longPressed == false
                ? FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.edit_note),
            )
                : null,
            bottomNavigationBar: showBottomNavBar
                ? BottomNavigationBar(
              onTap: (value) {
                if (checker.length >=1) {
                  if (value == 0) print('1 selected');
                  if (value == 1) {
                    shareContent();
                    print('2 share');
                  }

                  if (value == 2) {
                    _showDeleteDialog();
                  }
                }
                // else if (checker.length > 1) {
                //   print(value);
                //   if (value == 0) print('1 more selected');
                //   // if (value == 1)
                //   if (value == 2) {
                //     print("inside number 2");
                //     _showDeleteDialog();
                //   }
                // }
              },
              items: <BottomNavigationBarItem>[

                BottomNavigationBarItem(
                  icon: Icon(Icons.share),
                  label: 'Share',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.lock), label: 'secure'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.delete), label: 'delete'),
              ],
              type: BottomNavigationBarType.fixed,
            )
                : null,
            // This trailing comma makes auto-formatting nicer for build methods.
          );
        },);}
}
