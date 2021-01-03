
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:push_notifications_firebase/models/post.dart';
import 'package:push_notifications_firebase/services/db_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.blue,
        textTheme: TextTheme(bodyText2: TextStyle(color: Colors.purple)),
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.black,
              fontSize: 17.0,
              fontWeight: FontWeight.w600
          ))
        )
      ),
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot){
          if(snapshot.hasError){
            print(snapshot.error);
            return Container();
          }

          if(snapshot.connectionState == ConnectionState.done){
            return MyHomePage();
          }

          return Container(color: Colors.white);
        },
      ),
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
   final PostService postService = PostService();

   @override
  void initState() {
    super.initState();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        
      
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
    return Scaffold(
    
      backgroundColor: Colors.white,
      appBar: new AppBar(
        brightness: Brightness.light,
        title: new Text("Home"),
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          // open up text view
          
          Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context){
              return NewPost();
            }
          ));
        },
      ),
      body: Posts(),
    );
  }
}

class Posts extends StatelessWidget {
  Posts({Key key}) : super(key: key);

  final PostService postService = PostService();

  @override
  Widget build(BuildContext context) {
    return Container(
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
                return PostCard(post: snapshot.data[idx].post, id: snapshot.data[idx].postID, username: snapshot.data[idx].username);
              },
            );
          }

          return Container();
          
        }
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final post;
  final username;
  final id;

   PostCard({
    Key key,
    this.post,
    this.id,
    this.username,
  }) : super(key: key) ;

  final postService = PostService();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          "https://cdn.now.howstuffworks.com/media-content/0b7f4e9b-f59c-4024-9f06-b3dc12850ab7-1920-1080.jpg"
        ),
      ),
      title: Text.rich(
        TextSpan(children: [
          TextSpan(
            text : username + " ",
            style: TextStyle(
              
            )
          ),
          TextSpan(
            text : 'now',
            style: TextStyle(
              color: Colors.grey.shade700
            )
          ),

        ])
      ),
      subtitle: Text(post),
      trailing: IconButton(
        icon : Icon(Icons.cancel),
        onPressed: (){
          postService.removePost(id);
        },
      ),
    );
  }
}

class NewPost extends StatefulWidget {
  const NewPost({Key key}) : super(key: key);

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

