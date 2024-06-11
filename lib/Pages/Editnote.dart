import 'package:flutter/material.dart';
import 'package:mynotebook2/Pages/search.dart';
import 'package:mynotebook2/Database/helpers/UserHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
class Editnote extends StatefulWidget {
  const Editnote({super.key, required this.id,this.type});

final int id;
final String ?  type;
  @override
  State<Editnote> createState() => _EditnoteState();
}

class _EditnoteState extends State<Editnote> {
  bool  edit =false;
  UserHelper userHelper = UserHelper();


  Future<void> saveNotes(Map<String, dynamic> userData) async {

    Database db = await userHelper.database;
    int  insert = await db.insert('notes', userData);
    if (insert >0)
    {
      edit = false;
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

  void initState() {

    super.initState();
    if(widget.type =="create")
    {
        edit = true;
        print("widget type");
        print(widget.type);
        print(widget.id
        );
      // setState(() {
      // });
    }
  }

  var note = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Title"),
            Row(
              children: [
               if(edit==false)
                IconButton(
                  onPressed: () {
                    setState(() {
                    edit = true;
                    note = TextEditingController(text: '${widget.id} ' );
                    //   note =  widget.id as TextEditingController;

                    });
                    print("icon pressed");
                    print(widget.type);
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
                    print("icon pressed");
                    String data ="Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum";
                    showSearch(context:context, delegate:SearchInside(id:data));

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
              ListTile(
                leading: Icon(Icons.save),
                title: Text('save as'),
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
              if(!edit)Text(widget.id.toString())
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
