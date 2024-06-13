import 'package:flutter/material.dart';

// import 'package:share_plus/share_plus.dart';
import 'package:mynotebook2/Pages/DeleteClass.dart';
import 'package:mynotebook2/Pages/home.dart';
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
          var datanotes =  await db.query('notes',orderBy: "id desc");
          print('current user is \n ${data}');
          print('notes are   \n ${datanotes}');



    }else{
      print("creating a sqlite database");
      UserHelper userHelper = UserHelper();
         await userHelper.database;
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
