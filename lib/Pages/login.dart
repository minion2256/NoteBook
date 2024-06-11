
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:mynotebook2/Pages/register.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _loginFormState();
}

class _loginFormState extends State<LoginForm> {
  // TextEditingController fname;
  bool login = true;
  bool register = false;
  bool loginIndicator = false;
  bool registerIndicator = false;

  TextEditingController loginpassword =TextEditingController();
  TextEditingController loginemail =TextEditingController();
  final _loginformKey = GlobalKey<FormState>();
  // void saveUserInfo(data) {
  //   // final SharedPreferences preferences = await SharedPreferences.getInstance();
  //   // preferences
  //   print(" this is from saveuserinfo method");
  //   print(data);
  // }
  Future<void> saveUserInfo(data) async{
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(duration:Duration(seconds: 5) ,
          content: Text('Processing Data',
          )),
    );

    final SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString('Email', data[0]);
    preferences.setString('password', data[1]);
  }
  void getUserInfo() async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.getString('Email');
    preferences.getString('password');
    Future.delayed(Duration(seconds: 2));
    print(preferences.getString('Email'));
    print(" get userinformation");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            padding: EdgeInsets.fromLTRB(50,0,50,0), // Add padding if needed
            child:
            Form(
              key: _loginformKey,
              child:

              Column(
                // mainAxisSize: MainAxisSize.min, // Make the column take minimum space
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,// Center the children within the column
                children: [
                  Center(
                    child:  Text("This is done once when installing our noteBook App",
                        style: TextStyle(
                          fontWeight:FontWeight.w100,
                          letterSpacing:.4,
                        )),
                  ),



                  SizedBox(height: 16.0),
                  Text('Email'),// Add space between fields
                  TextFormField(
                    controller: loginemail,
                    validator: (value) {
                      if (value == null || value.isEmpty) {

                        return 'Please Enter Email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Email',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text('Password'),// Add space between fields
                  TextFormField(
                    controller:loginpassword ,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(

                      hintText: 'Enter Password',
                    ),
                  ),
                  SizedBox(height: 20.0), // Add space between fields
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(!register)...[
                        TextButton(onPressed:() {

                            if (_loginformKey.currentState!.validate()) {
                              // var userinfo= [];
                              // userinfo.add(fName.text);
                              // userinfo.add(lName.text);
                              // userinfo.add(email.text);
                              // userinfo.add(password.text);
                              // // print();
                              // saveUserInfo(userinfo);
                              // getUserInfo();

                            }

                        },
                          child:
                          Center(
                              child:
                              Text("Login",
                                  style: TextStyle(
                                    letterSpacing:1 ,

                                    // backgroundColor:Colors.cyan,
                                    // color: Colors.white,
                                    fontSize: 18,

                                  ))
                          ),
                        ),
                        SizedBox(height: 10),//create account button
                        TextButton(onPressed:(){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register()),
                          );
                        } ,
                          child:
                          Center(
                              child:
                              Text("Not Registered ? Create Account",
                                  style: TextStyle(
                                    letterSpacing:1 ,

                                    // backgroundColor:Colors.cyan,
                                    // color: Colors.white,
                                    fontSize: 18,

                                  ))
                          ),
                        ),
                      ],


                    ],

                  ),


                ],
              ),
            )

        ),
      ),






    );
  }
}

