import 'package:flutter/material.dart';
import 'package:push_notifications_firebase/services/db_service.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key key}) : super(key: key);
  static const routeName = "newPost";
  
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  String post = ""; 
  final PostService postService = PostService();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          elevation: 0.0,
          leadingWidth: 100.0,
          leading: TextButton(
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.black,
                fontSize: 17.0
              ),
            ),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          actions: [
            TextButton(
              child: Text(
                "Send",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 17.0
                ),
              ),
              onPressed: () async {
                // send post to database
                await postService.newPost(post, "robot64");
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: Container(
          child: TextField(
            onChanged: (str){
              post = str;
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
              hintText: "What's on your mind?",
              hintStyle: TextStyle(
                fontSize: 17.0
              )
            ),
            maxLines: 25,
          ),
        ),
      ),
    );
  }
}
