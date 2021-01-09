
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:push_notifications_firebase/services/db_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_notifications_firebase/models/post.dart';
import 'package:push_notifications_firebase/widgets/post_card.dart';

import 'new_post.dart';

class Home extends StatefulWidget {
  static const String routeName = "home";
  Home({Key key}) : super(key: key);

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final PostService postService = PostService();
  final String currentUserID = FirebaseAuth.instance.currentUser.uid;

 @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: ${message['aps']['alert']['body']}");
        Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 5),
          content: ListTile(
            title:  Text("New Tweet"),
            subtitle: Text(message['aps']['alert']['body']),
          )
        ));
      
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
       
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
       
      },
    );

    if(Platform.isIOS){
      _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
        sound: true, badge: true, alert: true, provisional: true));

      _firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });
    }

     _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      // send token to database 
      postService.saveToken(token, currentUserID);
      //subscribe user to topic
      postService.subscribeToTopic("feed");
      print('TOKEN: $token');
    });
  
  }
   
  @override
  Widget build(BuildContext context) {
    return Posts();
  }
}

class Posts extends StatelessWidget {
  Posts({Key key}) : super(key: key);
  static const String routeName = "postsFeed";

  final globalKey = GlobalKey<ScaffoldState>();
  final PostService postService = PostService();
  final String currentUserID = FirebaseAuth.instance.currentUser.uid;
  final String username = FirebaseAuth.instance.currentUser.displayName;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.white,
      appBar: new AppBar(
        brightness: Brightness.light,
        leading: IconButton(icon: Icon(Icons.settings, color: Colors.black), onPressed: (){
          print("show settings");
          showModalBottomSheet(context: context, builder: (BuildContext context){
              return Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height / 6,
              width: double.infinity,
              padding: EdgeInsets.only(left: 10, top: 10),
              child: ListTile(leading: Icon(Icons.logout), title: Text('Log out of $username'), onTap: () async {
                // log user out
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              }),
            );
          });
           
        },),
        title: new Text("Home"),
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
    
          Navigator.of(context).pushNamed(NewPost.routeName, arguments: {"test" : "a"} );
        
        },
      ),
      body: Container(
      padding: EdgeInsets.only(top: 0.0),
      child: Stack(
        children: [
            StreamBuilder<List<Post>>(
            stream: postService.getAllPosts(),
            builder: (context, snapshot) {
              if(snapshot.hasError){

                return Container();
              }
              if(snapshot.hasData){
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, idx){
                    
                    return PostCard(key: new GlobalKey() ,post: snapshot.data[idx].post, id: snapshot.data[idx].postID, username: snapshot.data[idx].username, liked: snapshot.data[idx].userLikedPost(currentUserID), profileImg: snapshot.data[idx].profileImg,);
                  },
                );
              }

              return Container();
              
            }
          ),
        ],
      )
    ));
  }
}

class ScrollSheet extends StatelessWidget {
  const ScrollSheet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet( 
      initialChildSize: 0.25 ,
      minChildSize: 0.20,
      maxChildSize: 1.0,
      
      builder: (context,controller){
      
      return Container(
   
          child: ListView.builder(
            controller: controller,
            itemCount: 25,
            itemBuilder: (context, index){
              return ListTile(title: Text('Index $index'));
          }),
         decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0))
        )
      );
    });
  }
}