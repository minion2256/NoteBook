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
  bool showBottomNavBar = false; // Variable to control visibility of BottomNavigationBar
  bool longPressed = false;
  bool? _isChecked = false;

  var checker = [];


  void _showDeleteDialog() async {
    DeleteClass deleteClass = DeleteClass(checker.length, "note");
    int feedback = await deleteClass.showAlertDialog(context);
    print('Feedback: $feedback');
    if(checker.length == feedback)
    {
      print(checker);
      setState(() {


        for (var a = checker.length - 1; a >= 0; a--) {
          checker.removeAt(a);
        }
        if(checker.length ==0)
        {
          longPressed = false;
          showBottomNavBar = false;

        }

      });
    }
    // Perform actions based on the feedback value if needed
  }
  void shareContent() async
  {
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
  void  checkForIteamInChecker(value)
  {
    if(checker.contains(value)) {
      print(" ${value} is already in the list");
      checker.remove(value);
      _counter--;

    }else{
      checker.add(value);
      _isChecked= true;
      _counter++;
    }
    print(checker);
    if(checker.length ==0){
      showBottomNavBar = false;
      longPressed = false;


    } if(checker.length ==1){
      showBottomNavBar = true;
      longPressed = true;

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        child:Padding(
          padding:EdgeInsets.all(10),

          child: GridView(
            children: <Widget>[

              GestureDetector(
                onTap: () {
                  // Your event handling code here
                  print('Container one tapped!');
                  if(!longPressed)
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>Editnote(id:2)));
                  else
                    setState(() {
                      checkForIteamInChecker(1);
                    });

                },
                onLongPress: ()
                {
                  print(" long pressed the container ");
                  setState(() {
                    checkForIteamInChecker(1);

                  });
                },

                child:Stack(
                  children: [
                    Container(
                      height: 1000,
                      width:350,
                      padding: EdgeInsets.all(10),
                      decoration:BoxDecoration(borderRadius: BorderRadius.circular(20),color:Colors.grey),

                      child: Text("Lorem ipsum dolor sit amet,, consectetur adipiscing elit. "
                          ,style:TextStyle(fontSize: 15,color: Colors.black)),),

                    if(longPressed) Checkbox(value: checker.contains(1),
                        activeColor: Colors.red,
                        onChanged: ( value){
                          setState(()
                          {
                            checkForIteamInChecker(1);

                          });
                        }
                    )
                  ],
                )
                ,),
              GestureDetector(
                onTap: () {
                  // Your event handling code here
                  print('Container one tapped!');
                  if(!longPressed)
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>Editnote(id:2)));
                  else
                    setState(() {
                      checkForIteamInChecker(11);
                    });

                },
                onLongPress: ()
                {
                  print(" long pressed the container ");
                  setState(() {
                    checkForIteamInChecker(11);

                  });
                },

                child:Stack(
                  children: [
                    Container(
                      height: 1000,
                      width:350,
                      padding: EdgeInsets.all(10),
                      decoration:BoxDecoration(borderRadius: BorderRadius.circular(20),color:Colors.purple),

                      child: Text("Lorem ipsum dolor sit amet,, consectetur adipiscing elit. "
                          ,style:TextStyle(fontSize: 15,color: Colors.black)),),

                    if(longPressed) Checkbox(value: checker.contains(11),
                        activeColor: Colors.red,
                        onChanged: ( value){
                          setState(()
                          {
                            checkForIteamInChecker(11);

                          });
                        }
                    )
                  ],
                )
                ,),
              GestureDetector(
                onTap: () {
                  // Your event handling code here
                  print('Container one tapped!');
                  if(!longPressed)
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>Editnote(id:2)));
                  else
                    setState(() {
                      checkForIteamInChecker(12);
                    });

                },
                onLongPress: ()
                {
                  print(" long pressed the container ");
                  setState(() {
                    checkForIteamInChecker(12);

                  });
                },

                child:Stack(
                  children: [
                    Container(
                      height: 1000,
                      width:350,
                      padding: EdgeInsets.all(10),
                      decoration:BoxDecoration(borderRadius: BorderRadius.circular(20),color:Colors.grey),

                      child: Text("Lorem ipsum dolor sit amet,, consectetur adipiscing elit. "
                          ,style:TextStyle(fontSize: 15,color: Colors.black)),),

                    if(longPressed) Checkbox(value: checker.contains(12),
                        activeColor: Colors.red,
                        onChanged: ( value){
                          setState(()
                          {
                            checkForIteamInChecker(12);

                          });
                        }
                    )
                  ],
                )
                ,),
              GestureDetector(
                onTap: () {
                  // Your event handling code here
                  print('Container one tapped!');
                  if(!longPressed)
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>Editnote(id:2)));
                  else
                    setState(() {
                      checkForIteamInChecker(13);
                    });

                },
                onLongPress: ()
                {
                  print(" long pressed the container ");
                  setState(() {
                    checkForIteamInChecker(13);

                  });
                },

                child:Stack(
                  children: [
                    Container(
                      height: 1000,
                      width:350,
                      padding: EdgeInsets.all(10),
                      decoration:BoxDecoration(borderRadius: BorderRadius.circular(20),color:Colors.grey),

                      child: Text("Lorem ipsum dolor sit amet,, consectetur adipiscing elit. "
                          ,style:TextStyle(fontSize: 15,color: Colors.black)),),

                    if(longPressed) Checkbox(value: checker.contains(13),
                        activeColor: Colors.red,
                        onChanged: ( value){
                          setState(()
                          {
                            checkForIteamInChecker(13);

                          });
                        }
                    )
                  ],
                )
                ,),
              GestureDetector(
                onTap: () {
                  // Your event handling code here
                  print('Container one tapped!');
                  if(!longPressed)
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>Editnote(id:2)));
                  else
                    setState(() {
                      checkForIteamInChecker(14);
                    });

                },
                onLongPress: ()
                {
                  print(" long pressed the container ");
                  setState(() {
                    checkForIteamInChecker(14);

                  });
                },

                child:Stack(
                  children: [
                    Container(
                      height: 1000,
                      width:350,
                      padding: EdgeInsets.all(10),
                      decoration:BoxDecoration(borderRadius: BorderRadius.circular(20),color:Colors.purple),

                      child: Text("Lorem ipsum dolor sit amet,, consectetur adipiscing elit. "
                          ,style:TextStyle(fontSize: 15,color: Colors.black)),),

                    if(longPressed) Checkbox(value: checker.contains(14),
                        activeColor: Colors.red,
                        onChanged: ( value){
                          setState(()
                          {
                            checkForIteamInChecker(14);

                          });
                        }
                    )
                  ],
                )
                ,),
              GestureDetector(
                onTap: () {
                  // Your event handling code here
                  print('Container one tapped!');
                  if(!longPressed)
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>Editnote(id:2)));
                  else
                    setState(() {
                      checkForIteamInChecker(15);
                    });

                },
                onLongPress: ()
                {
                  print(" long pressed the container ");
                  setState(() {
                    checkForIteamInChecker(15);

                  });
                },

                child:Stack(
                  children: [
                    Container(
                      height: 1000,
                      width:350,
                      padding: EdgeInsets.all(10),
                      decoration:BoxDecoration(borderRadius: BorderRadius.circular(20),color:Colors.grey),

                      child: Text("Lorem ipsum dolor sit amet,, consectetur adipiscing elit. "
                          ,style:TextStyle(fontSize: 15,color: Colors.black)),),

                    if(longPressed) Checkbox(value: checker.contains(15),
                        activeColor: Colors.red,
                        onChanged: ( value){
                          setState(()
                          {
                            // _isChecked = value;
                            checkForIteamInChecker(15);


                          });
                        }
                    )
                  ],
                )
                ,),



            ],
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 10,crossAxisSpacing: 10),
          ),
        ),
      ),

      floatingActionButton:
      longPressed==false ? FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.edit_note),
      ):null,
      bottomNavigationBar:
      showBottomNavBar ?
      BottomNavigationBar(
        onTap: (value) {
          if(checker.length ==1){
            if (value == 0) print('1 selected');
            if (value == 1)
            {
              shareContent();
              print('2 share');

            }
            if (value == 2) print('3 secure');
            if (value == 3)
            {

              _showDeleteDialog();
            }
          }else if(checker.length >1){
            print(value);
            if (value == 0) print('1 more selected');
            // if (value == 1)
            if (value == 2)
            {
              print("inside number 2");
              _showDeleteDialog();
            }

          }

        },
        items:  <BottomNavigationBarItem>[

          BottomNavigationBarItem(
            icon: Icon(Icons.ac_unit_outlined),
            label: '${checker.length} Selected',
          ),
          if (checker.length < 2)
            BottomNavigationBarItem(
              icon: Icon(Icons.share),
              label: 'Share',
            ),

          BottomNavigationBarItem(icon: Icon(Icons.lock),
              label: 'secure'),
          BottomNavigationBarItem(
              icon: Icon(Icons.delete),
              label: 'delete'
          ),


        ],
        type: BottomNavigationBarType.fixed,
      ): null,
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
