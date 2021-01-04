
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

  final PostService postService = PostService();
  static const String routeName = "postsFeed";
  final globalKey = GlobalKey<ScaffoldState>();

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
              child: ListTile(leading: Icon(Icons.logout), title: Text("Logout"), onTap: () async {
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
      padding: EdgeInsets.only(top: 21.0),
      child: StreamBuilder<List<Post>>(
        stream: postService.getAllPosts(),
        builder: (context, snapshot) {
          if(snapshot.hasError){

            return Container();
          }
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, idx){
                
                return PostCard(key: new GlobalKey() ,post: snapshot.data[idx].post, id: snapshot.data[idx].postID, username: snapshot.data[idx].username, liked: snapshot.data[idx].userLikedPost("robot64"));
              },
            );
          }

          return Container();
          
        }
      ),
    ));
  }
}