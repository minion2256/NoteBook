import 'package:flutter/material.dart';
import 'package:mynotebook2/Pages/Editnote.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:mynotebook2/Pages/DeleteClass.dart';
import 'package:mynotebook2/Pages/register.dart';
import 'package:mynotebook2/Pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart' as http;
import 'package:mynotebook2/Database/helpers/UserHelper.dart';
import 'package:sqflite/sqflite.dart';


import 'dart:convert';


import 'dart:async';


void main() {
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
   MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {



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
      home:  Loader(),
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
  int itemCounter =7;

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

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Editnote(id: ++itemCounter,type: 'create')),
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


      // print(" length is : ${checker.length}");
      _isChecked = true;
      _counter++;
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

                if(checker.length==0)
                Text('6 Notes', style: TextStyle(fontSize: 20)),
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
                itemCount: itemCounter, //  item count
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

                  crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
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
                              builder: (context) => Editnote(id: itemId,type: "update",)),
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
                          height: orientation == Orientation.portrait ? 500 : 200,
                          width:300,
                          padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
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


class Loader extends StatefulWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  bool checkuser = false;

  @override
  void initState() {
    super.initState();
    _initializeUserInfo();
  }


  // String base64UrlEncode(input) {
  //
  //   var bytes = utf8.encode(input);
  //
  //   var encoded = base64Url.encode(bytes);
  //   return encoded;
  // }

  String base64UrlDecode( encoded) {

    var bytes = base64Url.decode(encoded);

    var decoded = utf8.decode(bytes);
    return decoded;
  }

  void _initializeUserInfo() async {
    bool thechecker = await getUserInfo();
    if (thechecker) {
      setState(() {
        checkuser = true;
      });
      UserHelper userHelper = UserHelper();
      Database db = await userHelper.database;
          var data =  await db.query('users');
          var datanotes =  await db.query('notes');
          print('current user is \n ${data}');
          print('notes are   \n ${datanotes}');



    }else{
      print("creating a sqlite database");
      UserHelper userHelper = UserHelper();
         userHelper.database;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => checkuser
            ? const MyHomePage(title: 'My Note Book')
            : const LoginForm(),
      ),
    );
  }

  //function for getting crsf token
  // Future<String> fetchCsrfToken() async {
  //   var url =
  //   Uri.http('127.0.0.1:8000', 'api/csrftoken');
  //   // http('www.googleapis.com', '/books/v1/volumes', {'q': '7'});
  //
  //   // Await the http get response, then decode the json-formatted response.
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //
  //     return  "passed";
  //     // print('Number of books about http: $itemCount.');
  //   } else {
  //     print('Request failed with status: ${response.statusCode}.');
  //     return "not passed";
  //   }
  // }
  void awaitdata() async {
    String datau = await fetchCsrfToken();
    print(datau);
  }
  Future<String> fetchCsrfToken() async {
    var csrfTokenUrl = Uri.http('127.0.0.1:8000', 'api/csrftoken');

    // try {
      final response = await http.get(csrfTokenUrl);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['csrf_token'];
      } else {
        print('Failed to fetch CSRF token: ${response.statusCode}');
        return "null";
      }
    // } catch (e) {
    //   print('Error fetching CSRF token: $e');
    //   return null;
    // }
  }

  Future<bool> getUserInfo() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
      // preferences.remove('Email');
      // preferences.remove('password');


    // Simulating a delay for demonstration purposes
    print("get user information 67");

    await Future.delayed(Duration(seconds: 3));
    try {
    if( preferences.containsKey('Email') && preferences.containsKey('password') && preferences.containsKey('memory') )
    {


      String ? storedPassword =    preferences.getString('password');
      String ? storedMemory =    preferences.getString('memory');
      String ? storedEmail = preferences.getString('Email');
// storedPassword = base64UrlEncode(storedPassword);
      String decodedp = base64UrlDecode(storedMemory);

      print(storedEmail);
      print(storedPassword);
      print(storedMemory);
      print(decodedp);
      return true;
      // print(decodedp);
      // if(storedPassword == decodedp)
      //   {
      //
      // // print("get user information well infromation ");
      //     awaitdata();
      //
      //
      //   }
      // else{
      //   return false;
      // }
      // return true;
    }else{
      return false;
    }
    } catch (e) {
      print('Error checking SharedPreferences data: $e');
      return false;
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.lightBlue,
        body:Center(
          child: LoadingAnimationWidget.inkDrop(
            color:Colors.lightBlue ,
            size: 200,
          ),

        )
    );
  }
}
