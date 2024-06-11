import 'package:mynotebook2/imports.dart';

class User {

  int _id = 0;
  String  ? fname ;
  String ? lname ;
  String  ? email ;
  String ? password ;

  User(this.fname, this.lname, this.email, this.password);
  void  printDetails() {
    print('First Name: $fname');
    print('Last Name: $lname');
    print('Email: $email');
    print('Password: $password');
  }


  Map<String, dynamic> toMap() {
          return {
            'firstName': fname,
            'lastName': lname,
            'email': email,
            'password': password,
          };
     }
// User.withId(this._id,this.fname,this.lname,this.email,this.password);
//
//   int get id => _id;
//
//   String get fname => _fname;
//
//   String get lname => _lname;
//
//   String get email => _email;
//
//   String get pass => _password;
//
//   set fname(String Fname) {
//     if (Fname != "") {
//       this._fname = Fname;
//     }
//   }
//
//   set lname(String Lname) {
//     if (Lname != "") {
//       this._lname = Lname;
//     }
//   }
//
//   set email(String Email) {
//     if (Email != "") {
//       this._email = Email;
//     }
//   }
//
//   set pass(String Pass) {
//     if (Pass != "") {
//       this._password = Pass;
//     }
//   }


}
