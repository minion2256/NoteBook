import 'package:flutter/material.dart';
import 'package:mynotebook2/Pages/search.dart';

class Editnote extends StatefulWidget {
  const Editnote({super.key, required this.id});

final int id;
  @override
  State<Editnote> createState() => _EditnoteState();
}

class _EditnoteState extends State<Editnote> {
  bool  edit =false;
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
                  },
                  icon:  Icon(Icons.add_circle),
                ),
                if(edit)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        edit = false;
                            print(note.text);
                            print(note.value);
                        // note =  widget.id as TextEditingController;

                      });
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
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),

                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage('https://media.istockphoto.com/id/1399788030/photo/portrait-of-young-confident-indian-woman-pose-on-background.jpg?s=1024x1024&w=is&k=20&c=VQ_i-ojGNiLSNYrco2c2xM0iUjsZKLF7zRJ4PSMpmEI='),
                    ),
                    Text(
                      'Alvin John Maganga',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'pinyojohn@gmail.com',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
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
