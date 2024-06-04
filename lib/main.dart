import 'package:flutter/material.dart';
import 'package:mynotebook2/Pages/Editnote.dart';
import 'package:mynotebook2/Pages/DeleteClass.dart';
// import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'My Note Book'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  // final showBottomNavBar = false; // Variable to control visibility of BottomNavigationBar
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DeleteClass indelete; // Declare indelete variable

  int _counter = 0;
  bool showBottomNavBar =
      false; // Variable to control visibility of BottomNavigationBar
  bool longPressed = false;
  bool? _isChecked = false;
  bool? _selected =false;

  var checker = [];


  void _showDeleteDialog() async {
    DeleteClass deleteClass = DeleteClass(checker.length, "note");
    int feedback = await deleteClass.showAlertDialog(context);
    print('Feedback: $feedback');
    if (checker.length == feedback) {
      print(checker);
      setState(() {
        for (var a = checker.length - 1; a >= 0; a--) {
          checker.removeAt(a);
        }
        if (checker.length == 0) {
          longPressed = false;
          showBottomNavBar = false;
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
    setState(() {
      // _counter++;
    });
  }

  void checkForIteamInChecker(value) {
    if(_selected!)
      {
        _selected= false;
      }


    if(checker.length ==6)
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

        if(checker.length == 6)
        {
          _selected = true;
        }


      print(" length is : ${checker.length}");
      _isChecked = true;
      _counter++;
    }
    print(checker);
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
    return OrientationBuilder(
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

                if(checker.length==0)
                Text('6 Notes', style: TextStyle(fontSize: 20)),
                Text(
                    'Orientation: ${orientation == Orientation.portrait ? 'Portrait' : 'Landscape'}',
                    style: TextStyle(fontSize: 20)),
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
                  if(_selected!)
                    {
                      for(var a=1; a<=6;a++)
                        {
                          if(!checker.contains(a))
                          checker.add(a);
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
                itemCount: 6, // Replace this with the actual item count
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  int itemId = index + 1; // Example to generate unique IDs
                  return GestureDetector(
                    onTap: () {
                      print('Container $itemId tapped!');
                      if (!longPressed) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Editnote(id: itemId)),
                        );
                      } else {
                        setState(() {
                          checkForIteamInChecker(itemId);
                        });
                      }
                    },
                    onLongPress: () {
                      print('Long pressed container $itemId');
                      setState(() {
                        checkForIteamInChecker(itemId);
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 500,
                          width:300,
                          padding: EdgeInsets.fromLTRB(10, 22, 10, 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[100],
                            // color: index % 2 == 0 ? Colors.grey : Colors.purple,
                          ),

                          child: Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                        if (longPressed)
                          Checkbox(
                            value: checker.contains(itemId),
                            activeColor: Colors.red,
                            onChanged: (value) {
                              setState(() {
                                checkForIteamInChecker(itemId);
                              });
                            },
                          ),
                      ],
                    ),
                  );
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
