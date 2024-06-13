import 'package:flutter/material.dart';
import 'package:mynotebook2/Pages/search.dart';
import 'package:mynotebook2/Database/helpers/UserHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mynotebook2/Pages/login.dart';
import 'package:mynotebook2/Pages/home.dart';
import 'package:intl/intl.dart';
class Editnote extends StatefulWidget {
  const Editnote({super.key, required this.id,this.type,this.thecontent});

final int id;
final String ?  type;  final dynamic  thecontent;

  @override
  State<Editnote> createState() => _EditnoteState();
}

class _EditnoteState extends State<Editnote> {
  bool  edit =false;
  UserHelper userHelper = UserHelper();
   var currentNoteContainer ;


  Future<void> saveNotes(Map<String, dynamic> userData) async {

     int   insert =0 ;
    Database db = await userHelper.database;
    if(widget.type =="create")
    {
      insert = await db.insert('notes', userData);
    }else{
      insert = await db.update('notes', userData,where: 'id=?',whereArgs: [widget.id] );
    }

    if (insert >0)
    {
      edit = false;
      getCurrentNote();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(duration:Duration(seconds: 5) ,
            content: Center(
              child:  Text( ' Saved Successfully'
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



  void getCurrentNote() async
  {
     var cnote = await currentNote();
     if(cnote.length>0)
       {
           currentNoteContainer = cnote[0]['content'];
           print("this is content ${widget.id} and ${currentNoteContainer}");

       }
  }

  Future<List> currentNote() async {

    Database db = await userHelper.database;

    var query  = await db.query('notes', where: 'id=?',whereArgs: [widget.id]);

// print(" the  current data is ${query}");
      return query;
  }

  void initState() {

    super.initState();


      setState(() {
        if(widget.type =="create")
          {
            edit =true;
          }
        getCurrentNote();
      });
  }

  var note = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(title: 'My Note Book')),
                );

                // print("icon pressed");
                // print(widget.type);
              },
              icon:  Icon(Icons.arrow_back),
            ),
            Text("Title"),
            Row(
              children: [
               if(edit==false)
                IconButton(
                  onPressed: () {
                    setState(() {
                    edit = true;
                    note = TextEditingController(text: '${currentNoteContainer}' );
                    //   note =  widget.id as TextEditingController;

                    });
                    // print("icon pressed");
                    // print(widget.type);
                  },
                  icon:  Icon(Icons.add_circle),
                ),
                if(edit)
                  IconButton(
                    onPressed: () {

                            print(note.text);
                        DateTime now = DateTime.now();
                        Map<String, dynamic> toMap() {
                          return {
                            'title': 'null',
                            'content': note.text,
                            'date': DateFormat().format(now),
                          };
                        }
                        var  data = toMap();


                        saveNotes(data);


                        // note =  widget.id as TextEditingController;
                      // });
                      print(" save icon pressed");
                    },
                    icon:  Icon(Icons.save),
                  ),
                IconButton(
                  onPressed: () {
                    showSearch(context:context, delegate:SearchInside(id:currentNoteContainer));

                  },
                  icon: Icon(Icons.search),
                ),
                // IconButton(
                //   onPressed: () {
                //     Scaffold.of(context).openEndDrawer();
                //   },
                //   icon: Icon(Icons.more_vert),
                // ),
              ],
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        // Drawer contents go here
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
          ),
          child:
          ListView(
            children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 0)),

              ListTile(
                leading: Icon(Icons.read_more),
                title: Text('Reminder'),
                onTap: () {
                  // Handle item 1 tap
                },
              ),
              ListTile(
                leading: Icon(Icons.group_add),
                title: Text('Invite collaborators'),
                onTap: () {
                  // Handle item 1 tap
                },
              ),

            ],
          ),
        ),
      ),
      body:GestureDetector(

        child:Padding(
        padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              if(!edit)Text(currentNoteContainer?.isNotEmpty == true ? currentNoteContainer! : widget.thecontent)
              , if(edit) TextField(
                controller: note,
                autofocus: true,
                maxLines: null,
                decoration:InputDecoration(
                  border:InputBorder.none,

                ),


              )
            ],
          ),
        ), onTap: (){
        setState(() {
          edit = true;
          print("body clicked");
        });
      },

      )

    );

  }
}
