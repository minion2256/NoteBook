import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';

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

  void _initializeUserInfo() async {
    bool thechecker = await getUserInfo();
    if (thechecker) {
      setState(() {
        checkuser = true;
      });
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
  Future<bool> getUserInfo() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String ? storedFirstName = preferences.getString('Firstname');
    String ? storedLastName = preferences.getString('Lastname');
    String ? storedEmail = preferences.getString('Email');
    String ? storedPassword = preferences.getString('password');

    // Simulating a delay for demonstration purposes
    await Future.delayed(Duration(seconds: 2));
    if(storedFirstName!.isNotEmpty && storedLastName!.isNotEmpty && storedEmail!.isNotEmpty && storedPassword!.isNotEmpty )
    {
      print(storedFirstName);
      print(storedLastName);
      print(storedEmail);
      print(storedPassword);
      print("get user information");
      return true;
    }else{
      return false;
    }
    print(storedFirstName);
    print("get user information");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue,
        body:Center(
          child: LoadingAnimationWidget.twistingDots(
            leftDotColor: const Color(0xFF1A1A3F),
            rightDotColor: const Color(0xFFEA3799),
            size: 200,
          ),

        )
    );
  }
}
