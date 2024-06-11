import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:mynotebook2/Pages/login.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';
import 'package:mynotebook2/Database/Models/User.dart';
import 'package:mynotebook2/Database/helpers/UserHelper.dart';
import 'package:sqflite/sqflite.dart';




class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // TextEditingController fname;
  UserHelper userHelper = UserHelper();

  bool login = true;
  bool register = false;
  bool loginIndicator = false;
  bool registerIndicator = false;

  TextEditingController fName  =TextEditingController();
  TextEditingController lName =TextEditingController();
  TextEditingController password =TextEditingController();
  TextEditingController email =TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // void saveUserInfo(data) {
  //   // final SharedPreferences preferences = await SharedPreferences.getInstance();
  //   // preferences
  //   print(" this is from saveuserinfo method");
  //   print(data);
  // }
    Future<void> saveUserInfo(data) async{


String base64UrlEncode(input) {

        var bytes = utf8.encode(input);

        var encoded = base64Url.encode(bytes);
        return encoded;
      }
    final SharedPreferences preferences = await SharedPreferences.getInstance();

      final plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';

      final key = encrypt.Key.fromSecureRandom(32);
      final iv = encrypt.IV.fromSecureRandom(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));


      final encrypted = encrypter.encrypt(data[1], iv: iv);
      // final decrypted = encrypter.decrypt(encrypted, iv: iv);

      // print(decrypted);
      // print(encrypted.bytes);
      // print(encrypted.base16);
      // print(encrypted.base64);

      final encryptedString = encrypted;

                String  ? pass = "CzTebebJLHs7RnaI0TBt0On8cnDZZ9IzBo3RTDRqB5AvpwPbxd./a";

                //  storedPassword = base64UrlEncode(pass);
    preferences.setString('Email', data[0]);
    preferences.setString('password', pass);
    preferences.setString('memory', base64UrlEncode(data[1]));




    //
      final encryptedPass = preferences.getString('password');

// Check if the retrieved string is not null
//       if (encryptedPass != null) {
//         // Decode the Base64 string to get the encrypted data
//         final encryptedData = encrypt.Encrypted.fromBase64(encryptedPass);
//
//         // Decrypt the encrypted data
//         final decrypted = encrypter.decrypt(encryptedData, iv: iv);
//         print(decrypted);
//
//       } else {
//         // Handle the case where the encrypted string is null
//         // This could be an indication of missing or corrupted data
//       }
  }
  void getUserInfo() async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.getString('Email');
    preferences.getString('password');
    Future.delayed(Duration(seconds: 2));

  }

  Future<void> addUser(Map<String, dynamic> userData) async {

     Database db = await userHelper.database;
      int  insert = await db.insert('users', userData);
     if (insert >0)
        {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(duration:Duration(seconds: 5) ,
                content: Center(
                  child:  Text('Registered Successfully'
                  ),
                )
               ),
          );

        }
    else{
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(duration:Duration(seconds: 5) ,
             content: Text('Something Went wrong',
             )),
       );
     }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(50,0,50,0), // Add padding if needed
          child:
            Form(
            key: _formKey,
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

                  SizedBox(height: 16),
                  Text('First Name',
                      style: TextStyle(
                      )),

                  TextFormField(
                    controller: fName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {

                        return 'Please Enter First Name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter First Name',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text('Last Name'), // Add space between fields
                  TextFormField(
                    controller: lName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {

                        return 'Please Enter Last Name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Last Name',
                    ),
                  ),

                SizedBox(height: 16.0),
                Text('Email'),// Add space between fields
                TextFormField(
                  controller: email,
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
                  controller:password ,
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

                    SizedBox(height: 10),//create account button
                    TextButton(onPressed:(){
                      if (_formKey.currentState!.validate()) {
                        var userinfo= [];



                        // User user = User(fName.text,lName.text,email.text,password.text);
                        // user.printDetails();
                        // Map<String, dynamic> data = user.toMap();
                        // print(data);

                        userinfo.add(email.text);
                        userinfo.add(password.text);
                        // UserHelper userHelper = UserHelper();
                        // await userHelper.insert('users', userData);

                           Map<String, dynamic> toMap() {
                          return {
                            'fName': fName.text,
                            'lName': lName.text,
                            'email': email.text,
                            'password': password.text,
                          };
                        }
                           var  data = toMap();
                        addUser(data);




                        // print( userinfo);
                        saveUserInfo(userinfo);
                        getUserInfo();
                      }

                    } ,
                      child:
                      Center(
                          child:
                          Text("Create Account",
                              style: TextStyle(
                                letterSpacing:1 ,

                                // backgroundColor:Colors.cyan,
                                // color: Colors.white,
                                fontSize: 18,

                              ))
                      ),
                    ),
    SizedBox(height: 10),
                    TextButton(onPressed:() {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginForm()),
                      );


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

