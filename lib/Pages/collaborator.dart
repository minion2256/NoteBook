import'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:mynotebook2/Database/helpers/UserHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';



class Collabo extends StatefulWidget {
  // const Collabo({Key? key,this.noteid}) : super(key: key);
  const Collabo({super.key, required this.noteid});



  final  int noteid;

  @override
  State<Collabo> createState() => _CollaboState();
}

class _CollaboState extends State<Collabo> {
  UserHelper userHelper = UserHelper();

  final _formKey = GlobalKey<FormState>();
  var dataCollaborator=[];
  int totalCollaborator=5;
   bool editCollaborator = false;
   bool editable = false;
   var mycollaborators ;
   bool longPressed = false;
   int mycollaboratorsL =0 ;
  bool? selected = false;
  bool? netcheker ;
  String ?feedBackMsg ;

  bool showBottomNavBar =false;

  var checker =[];

  TextEditingController Collaborator  =TextEditingController();
  TextEditingController myCollaborator  =TextEditingController();


  void initState() {

    super.initState();
      thecollaborators();
  }

  void taken(){
    // print("token is: ${csrfToken}");
    // Map<String, dynamic> data = {
    //   'email': email,
    // };
    // //
    // var url2 = Uri.https('yourbooknote.000webhostapp.com', 'api/csrftoken');
    // var response2 = await http.post(url2,body:  json.encode(data));
    // if (response2.statusCode == 200) {
    //   var message = json.decode(response2.body);
    //   print("token is: ${message['message']}");
    //   return message['message'];
    // } else {
    //   print('Request to url2 failed with status: ${response2.statusCode}.');
    //   print("token  not sent correctly");
    //   return "not passed";
    // }
  }

  void checkForIteamInChecker(value) {
    if(selected!)
    {
      selected= false;
    }

    // if(checker.length ==itemCounter)
    // {
    //
    //   selected= true;
    //
    // }
    if (checker.contains(value)) {
      print(" ${value} is already in the list");
      checker.remove(value);

      selected = false;

    } else {
      checker.add(value);

      // if(checker.length == itemCounter)
      // {
      //   selected = true;
      // }


      // print(" length is : ${checker.length}");
      // _isChecked = true;
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
    print(checker);
  }

  // void getUserNotes() async
  // {
  //   dataCollaborator= await getnotes();
  //   if(dataCollaborator.length>0){
  //     setState(() {
  //
  //       collaboratorCounter = dataCollaborator.length;
  //     });
  //   }else{
  //     collaboratorCounter =0;
  //   }
  // }

  void thecollaborators() async
  {
    var  getColl =await getCollaborators();
    setState(() {
      if(getColl.length > 0){
        mycollaboratorsL = getColl.length;
        mycollaborators=  getColl;
      }else{
        mycollaboratorsL =0;
      }
    });
  }
  Future<bool> fetchCsrfToken() async {
    var url = Uri.https('yourbooknote.000webhostapp.com', 'api/csrftoken');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var theadata = json.decode(response.body);
      String csrfToken = theadata['csrf_token'];
      if (csrfToken.length == 25) {
        int tokenValue = int.parse(csrfToken.substring(23));
        if (tokenValue >= 0 && tokenValue <= 100) {
          //
          print(csrfToken);
          return true;
        } else {
          print('message Token value out of range.');
          return false;
        }
      } else {
        print('message token contains more than 25 characters. ${csrfToken}' );

        return false;
      }
    } else {
      print('message Request failed with status: ${response.statusCode}.');
      return false;
    }
  }

  Future<bool> sendData( String email,int creator,int note,List users) async {
    // print("users from senddata method  ${users}");
    // print("creator is ${creator}");
    // feedBackMsg='testing';
    // return false;
    var data;
     var dataWithNoUser ={
       'email':email,
       'owner':users[0]['email'],
       'noteid':widget.noteid
     };
     var dataWithUser ={
       'email':email,
       'creator':creator,
       'fname':users[0]['fname'],
       'lname':users[0]['lname'],
       'owner':users[0]['email'],
       'code':users[0]['password'],
       'noteid':widget.noteid
     };
    var url2; var response2;
     if(creator ==1)
       {
         url2  = Uri.https('yourbooknote.000webhostapp.com', 'api/insertCollaboWithUser');

         response2 = await http.post(url2,body:json.encode(dataWithUser),headers: {
           'Content-Type': 'application/json',  // Set the content type
         },);
       }else{
       url2  = Uri.https('yourbooknote.000webhostapp.com', 'api/insertCollabo');

       response2 = await http.post(url2,body:json.encode(dataWithNoUser),headers: {
         'Content-Type': 'application/json',  // Set the content type
       },);
     }

    if (response2.statusCode == 200) {
      var thedata = json.decode(response2.body);
      String themsg = thedata['message'];
      String thestatus = thedata['status']  ;
      if (thestatus  =='true') {
        // thecollaborators();
        feedBackMsg = themsg;
         return  true;
      } else {
        print('Request failed with status: ${response2.body}.');
        feedBackMsg = themsg;
        return false;
      }
    } else {
      print('Request failed with status: ${response2.body}.');
      // return "Request Failed ";
      feedBackMsg = 'Request failed Server Error';
      return false;
    }
  }

  Future<List> getCollaborators  () async{
    // print("widget.noteid ${widget.noteid}");
    Database db = await userHelper.database;
    var collaborators = await db.rawQuery(
   'SELECT collaborator,collaborators.date,collaborator_id  FROM collaborators JOIN invited ON invited.invited_id = invited_collabo LEFT JOIN notes ON invited.note_id = notes.id WHERE note_id = ?',[widget.noteid]
    );
    print("collaborators \n ${collaborators}");
    return collaborators;

  }

  Future<List> getIndCollaborator  (int id) async{
    var indicollaborator ;
    Database db = await userHelper.database;
    var myquery  = await db.query('invited', where: 'note_id =?',whereArgs: [widget.noteid]);
    if(myquery.length>0)
      {
        var  queryid = myquery[0]['invited_id'];
        print("widget.noteid  and the data is ${widget.noteid} ${myquery}");
        //  indicollaborator = await db.rawQuery(
        //     'SELECT collaborator FROM collaborators JOIN invited ON invited.invited_id = invited_collabo  WHERE invited_collabo = ? and where collaborator_id=? ',[widget.noteid,id]
        // );
                                indicollaborator = await db.rawQuery('''
                                      SELECT collaborator 
                                      FROM collaborators 
                                      JOIN invited ON invited.invited_id = invited_collabo
                                      WHERE invited_collabo = ? AND collaborator_id = ?
                                          ''', [queryid, id]);

        print("collaborators \n ${indicollaborator}");
      }
    else{
      indicollaborator =[];
    }

    return indicollaborator ;

  }
  void notesCollabo(collabos,content,db,creator,userData) async{
    //
    DateTime now = DateTime.now();
    print("mo3");

    bool ? datatoken;
    bool ? insertionVerifier ;

//

    var invited_id = await db.rawQuery('SELECT invited_id FROM invited ORDER BY invited_id DESC LIMIT 1');
    int  insert = await db.insert('invited', userData);
    //


    // return;
    print("datau");

    print( " the datau is : ${datatoken}");


    var theCollaboratorCounter = await db.rawQuery('''
                                      SELECT count(*) as counter 
                                      FROM collaborators 
                                      JOIN invited ON invited.invited_id = invited_collabo
                                      LEFT JOIN notes ON invited.note_id = notes.id
                                       WHERE invited.note_id = ? 
                                          ''', [widget.noteid]);
    print("the counter of coll is  : ${theCollaboratorCounter[0]['counter']}");
    if(theCollaboratorCounter[0]['counter'] <= totalCollaborator){
      datatoken = await fetchCsrfToken();
      if(datatoken!)
      {

        var users = await db.query("users");

        insertionVerifier = await sendData(collabos,creator,widget.noteid,users);
        print('the insertionVerifier : ${insertionVerifier}');

        if( insertionVerifier! )
        {
          int insertInvited;
          var invited_id;
          int invitedID =0;
          if(creator ==1)
            {


              Map<String, dynamic> data = {
                'collabo': 1,
              };

              int updated = await db.update('notes', data, where: 'id=?', whereArgs: [widget.noteid]);
              if (updated > 0) {
                invited_id = await db.query(
                    'invited', where: 'note_id =?', whereArgs: [widget.noteid]);
                if (invited_id.length > 0) {
                  invitedID = invited_id[0]['invited_id'];
                }
              }else{
                feeback("something went wrong....!!");
                return;
              }
            }else{

         insertInvited = await db.insert('invited', userData);
         if(insertInvited>0)
           {

         invited_id = await db.rawQuery('SELECT invited_id FROM invited ORDER BY invited_id DESC LIMIT 1');
         invitedID = invited_id[0]['invited_id'];
           }
         else{
           feeback('Something Went wrong.....!!');
         }

          }

          Map<String, dynamic> toMap() {
            return {
              'collaborator ': collabos,
              'invitedId':invitedID,
              'content': content,
              'date': DateFormat().format(now),
            };
          }
          Map<String, dynamic> tocollaborators() {
            return {
              'invited_collabo':invitedID,
              'collaborator ': collabos,
              'date': DateFormat().format(now),
            };
          }
          var  data2 = toMap();
          var  data3 = tocollaborators();

          int  col_notes = await db.insert('col_notes', data2);

          int  data3_result = await db.insert('collaborators', data3);
          print( " the datau2 is : ${datatoken}");

          if( col_notes >0 &&  data3_result >0)
            {
              feeback('Collaborator added Successfully');
              print(" inserting data4");
              Navigator.pop(context);
              netcheker = false;
              Collaborator.clear();
              thecollaborators();
              print("datau");
              // String datau = await fetchCsrfToken(collabos);
              // print(datau);
            }
          else{
            feeback('Something Went wrong.....!!');
          }



        }else{
          feeback(feedBackMsg!);
        }

      }else{
        feeback('Request Failed ');
      }
    }
    else{
      feeback("You Can Have Only ${totalCollaborator} Collaborators Per Notes");
    }
    // return;



    //

  }

  void feeback( String text)
  {
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(duration:Duration(seconds: 3) ,
          content: Center(
            child:  Text(text),
          )
      ),
    );
  }
  //connection to internet
  Future<bool> _checkConnection() async {
    final Connectivity _connectivity = Connectivity();

    ConnectivityResult result;
    try {
      result = (await _connectivity.checkConnectivity()) as ConnectivityResult;
    } catch (e) {
      print("Connectivity check failed: ${e}"); // Log any errors

      result = ConnectivityResult.none;
    }
    if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) {

      return true;
    } else {

      return false;


    }
    }

    void netcheckermethod() async{
       netcheker  = await _checkConnection();


    }

  Future<void> addUser(Map<String, dynamic> userData) async {

    Database db = await userHelper.database;

      var checkNotes = await db.query('notes',where: 'id=?',whereArgs: [widget.noteid] );
    print('checkNotes ${checkNotes}');
      // var thecontent = await db.query('notes',where: 'id=?',whereArgs: [widget.noteid] );
      if(checkNotes[0]['collabo'] ==0)
      {

        notesCollabo(Collaborator.text,checkNotes[0]['content'],db,1,userData);

      }
      if(checkNotes[0]['collabo'] ==1){
        //collabo ==1
        notesCollabo(Collaborator.text,checkNotes[0]['content'],db,0,userData);

      }

  }
Future <bool>deleteCollaborator(Map<String, dynamic> userData) async{

    return true;
}



  Future<void> EditUser(Map<String, dynamic> userData) async {
        Database db = await userHelper.database;

    var invited_id = await db.update('collaborators',userData, where: 'collaborator_id=?',whereArgs:[checker[0]] );
    if(invited_id>0)
    {
      editCollaborator = false;
       thecollaborators();
      Navigator.pop(context);
      myCollaborator.clear();

      feeback("Successfully Update Collaborator");
    }


  }
  Future<void> deleteValues() async{

    print("list is ${checker}");
    Database db = await userHelper.database;
    String ids = checker.join(',');
    print(ids);
     var allCollaborator = await db.rawQuery('''
                                      SELECT collaborator 
                                      FROM collaborators 
                                      JOIN invited ON invited.invited_id = invited_collabo
                                      LEFT JOIN notes ON invited.note_id = notes.id
                                       WHERE invited.note_id = ? AND
                                      collaborator_id in ($ids) 
                                          ''', [widget.noteid]);
            var collaboEmaild =
            {
              "email": allCollaborator,
            };
 var collaboemail=[];
    for (var item in allCollaborator) {
      // var collaborator = item['collaborator'];
         print("all collabors are ${item['collaborator']}");
         // allCollaborator[a]['collaborator'];
      collaboemail.add(item['collaborator']);
       }

    var data3 ={
      "email":collaboemail,
      "note_id":widget.noteid
    };
    var url3 = Uri.https('yourbooknote.000webhostapp.com', 'api/deleteCollaborator');
 print(url3);

    var response3 = await http.post(url3,body:json.encode(data3),headers: {
      'Content-Type': 'application/json',  // Set the content type
    },);

    try{
      if (response3.statusCode == 200) {
        print( "the body" + response3.body);
      }
      else{
        feeback('failed to connect to the server ${ response3.body}');

      }
   }catch(e)
    {
      print("failed with $e");
    }


    // Database db = await userHelper.database;
    // var datanotes =  await db.delete("collaborators",  where: 'id IN ($ids)');
    // return datanotes;
    print(" collaborators are- \n ${allCollaborator}");
  }
  void showDeleteDialog(BuildContext context)
  {


    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
        // completer.complete(0);
// e the dialog when Cancel button is pressed
      },
    );

    Widget okButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        deleteValues();
        // deleteValues(context).then((value) {
        //   // completer.complete(value); // Complete the future with the returned value
        // });
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Delete"),
      content: Text("Are you sure you want to delete ${checker.length} Collaborator${checker.length > 1 ? 's ?' : ' ?'}"),
      actions: [
        cancelButton,
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showAlertDialog (BuildContext context,bool indicator)  async{
    var theemail ="";
    if (indicator)
  {
    editCollaborator = true;

    var  email = await getIndCollaborator(checker[0]);
     if(email.length>0)
       {

     theemail = email[0]['collaborator'];
       }

  }
    AlertDialog alert = AlertDialog(
      title: Text("Collaborator"),
      content:
      SizedBox(
        height: 150,
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: theemail.isNotEmpty
                    ? myCollaborator =TextEditingController(text: theemail)
                    : Collaborator,

                validator: (value) {
                  if (value == null || value.isEmpty) {

                    return "Please Enter collaborator email";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: 'Enter collaborator email'
                ),
              ),
            ),
            TextButton(
                onPressed: ()
                {
                  print("object");
                  if (_formKey.currentState!.validate()) {

                    DateTime now = DateTime.now();
                    Map<String, dynamic> toMap() {
                      return {
                        'note_id': widget.noteid,
                        'date': DateFormat().format(now),
                      };
                    }
                    var  data = toMap();
                    addUser(data);

                  }
                }, child:
                       editCollaborator ==false ? Text('add') :Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           TextButton(onPressed: (){
                             DateTime now = DateTime.now();
                                  Map<String, dynamic> collaboratorEdited() {
                                  return {
                                  'collaborator ': myCollaborator.text,
                                  'date': DateFormat().format(now),
                                  };
                                  }
    print("the editable email is ${myCollaborator.text}");
                                  var dataEdit = collaboratorEdited();
                              EditUser(dataEdit);

                           }, child: Text('Edit') ),
                           TextButton(onPressed: (){
                             print("before press ${editCollaborator}");
                               Navigator.pop(context);
                             setState(() {
                               editCollaborator = false;
                             });

                             print("after press ${editCollaborator}");

                           }, child: Text('Cancel') )
                         ],
                       )
            )
          ],
        ),
      ),

    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

  }
  void showFailerEdit (BuildContext context) {
    AlertDialog edit = AlertDialog(
      title: Text("Edit Collaborator"),
      content:
      SizedBox(
        height: 100,
        child:
       Text(" You can only edit one collaborator at a time")
      ),

    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return edit;
      },
    );

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          title:Row(
              children: [
                Text('collaborators')
              ]
          )
      ),
      body:Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if(mycollaboratorsL==0)
                Center(
                  child:
                  Text("you dont have collaborators, click person to add"),
                )
            else if(mycollaboratorsL>0)
              if(longPressed)Row(
                mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  Padding(padding: EdgeInsets.only(left: 5),
                    child:
                    Checkbox(
                      value: selected,
                      activeColor: Colors.purple[300],
                      onChanged: (value) {
                        setState(() {
                          selected =value!;
                          // print("checker is ${checker}");
                          //
                          if(selected!)
                          {

                            print("checker is ${checker}  ${mycollaboratorsL}");
                            for(var a=0; a<mycollaboratorsL;a++)
                            {
                              var picker = mycollaborators[a];
                              print(picker);

                              if(!checker.contains(picker['collaborator_id']))
                                checker.add(picker['collaborator_id']);
                            }
                            print("checker is ${checker}  ");
                          }else{
                            checker.clear();
                          }


                          // checkForIteamInChecker(data['collaborator_id']);
                        });
                      },
                    ),
                  ),
                  Text('All')


                ],
              ),
              Container(
                child: ListView.separated(

                  shrinkWrap: true,
                  padding:  EdgeInsets.all(8),
                    itemCount: mycollaboratorsL,
                    itemBuilder:(context, index) {
                          int indexCouter = index+1;
                        var data = mycollaborators[index];
                          DateTime parsedDate = DateFormat('MMMM dd, yyyy hh:mm:ss').parse(data['date']);
                          String formattedDate = DateFormat('MMMM dd, yyyy').format(parsedDate);
                    return SizedBox(
                      height: 30,
                      child: GestureDetector(
                        onTap: (){
                          print("taped");
                        },
                        onLongPress: (){
                          setState(() {

                          longPressed =true;
                          showBottomNavBar  =true;
                          });
                          print(" userselected");
                        }
                        ,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if(longPressed)
                            Checkbox(
                              value: checker.contains(data['collaborator_id']),
                              activeColor: Colors.purple[200],
                              onChanged: (value) {
                                print("checkbox");
                                setState(() {
                                  selected =value!;
                                  // print("checker is ${checker}");
                                  //
                                  // if(_selected!)
                                  // {
                                  //
                                  //   print("checker is ${checker}");
                                  //   for(var a=0; a<itemCounter;a++)
                                  //   {
                                  //     var picker = dataNotes[a];
                                  //
                                  //     if(!checker.contains(picker['id']))
                                  //       checker.add(picker['id']);
                                  //   }
                                  //
                                  // }else{
                                  //   checker.clear();
                                  // }
                                  checkForIteamInChecker(data['collaborator_id']);
                                });
                              },
                            ),
                            Text( "${indexCouter}. ${data['collaborator']}"),
                            Text(formattedDate),


                          ],
                        ),
                      ),
                    );
                    }
                    ,
                  separatorBuilder: (BuildContext context, int index) => const Divider(),),
              ),
              


          ],

        ),

      ) , bottomNavigationBar: showBottomNavBar
        ? BottomNavigationBar(
      onTap: (value) {
        // if (checker.length >=1) {
          if (value == 0){
            if(checker.length==1)
              {

                showAlertDialog(context,true);
              }else{
              if(editCollaborator)
                {
                  editCollaborator = false;
                }
            showFailerEdit (context) ;
            }
          }
          if (value == 1) {


            netcheckermethod();
            if(netcheker!)
            {
              showDeleteDialog(context);
            }
            else{
              feeback("Connect To Internet To Delete Collaborators");
            }


            print('2 deletion');
          }
        //
        //   if (value == 2) {
        //     // _showDeleteDialog();
        //   }
        // }
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
          icon: Icon(Icons.save_as),
          label: 'Edit',
        ),

        BottomNavigationBarItem(
            icon: Icon(Icons.delete), label: 'delete'),
      ],
      type: BottomNavigationBarType.fixed,
    )
        : null,
      floatingActionButton: longPressed == false ? FloatingActionButton(
        onPressed: (){
          // print( "the is ${widget.noteid}");
          // showAlertDialog (context,false);
            netcheckermethod();
            if(netcheker!)
              {
                showAlertDialog (context,false);
              }
              else{
              feeback("Connect To Internet To Add Collaborators");
              }

        }
        ,
        tooltip: 'Increment',
        child: const Icon(Icons.person_add),
      ):null,

    );
  }
}



