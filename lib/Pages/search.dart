  import 'package:flutter/material.dart';
  import 'package:styled_text/styled_text.dart';
class SearchInside extends SearchDelegate<String> {
   SearchInside({required this.id});
   String  id ;

   String highlightCharacter(String text, String charToHighlight) {
     return text.replaceAll(charToHighlight, '<highlight>$charToHighlight</highlight>');
   }

   // styleText
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: (){
        print("button cliecked");
        query = "";
      }, icon: Icon(Icons.clear))
    ];
    throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    // throw UnimplementedError();
    return
      IconButton(
          icon:AnimatedIcon(
              icon:AnimatedIcons.menu_arrow,
              progress:transitionAnimation
          ),
          onPressed: (){
        close(context,"");
      }
      ) ;

  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Center(
      child: Text(query),
    );
    String character = "L";

    RegExp regExp = RegExp(r'\b' + character + r'\w*', caseSensitive: false);
    Iterable<RegExpMatch> matches = regExp.allMatches(id);


    return
      IconButton(onPressed: (){
        print("button cliecked");
      }, icon: Icon(Icons.clear))
    ;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    // throw UnimplementedError();
    String ?  suggestion ='';

      if(query.isEmpty)
        {
          suggestion = id;
        }
      else{
        // suggestion = id;



         suggestion = highlightCharacter(id,query);

        return
          Container(
            child:Padding(
              padding:EdgeInsets.all(10) ,
              child: StyledText(
                text:suggestion,
                tags: {
                  'highlight': StyledTextCustomTag(
                    baseStyle: TextStyle(backgroundColor: Colors.red),
                    parse: (baseStyle, attributes) {

                      return baseStyle;
                    },
                  ),
                },
              ),
            )
            ,
          );
        // print(id.length);

      }
    return

    Container(
      child:Padding(
        padding:EdgeInsets.all(10) ,
        child:Text(suggestion) ,
      )
      ,
    );



    ;
  }
  
}


