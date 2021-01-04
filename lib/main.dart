import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:push_notifications_firebase/screens/login.dart';
import 'package:push_notifications_firebase/screens/new_post.dart';
import 'package:push_notifications_firebase/screens/signup.dart';
import 'screens/home.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context,snapshot){
          
          if(snapshot.hasError){
            print(snapshot.error);
            return Container();
          }
         
            if(snapshot.connectionState == ConnectionState.done){
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: new ThemeData(
                  primaryColor: Colors.black,
                  accentColor: Colors.blue,
                  buttonColor: Colors.blue,
                  textTheme: TextTheme(
                    bodyText2: TextStyle(color: Colors.purple), 
                    headline6: TextStyle(color:Colors.black, fontSize: 35.0)),
                  appBarTheme: AppBarTheme(
                    textTheme: TextTheme(
                      headline6: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600
                    ))
                  )
                ),
                onGenerateRoute: (settings){
                  String routeName = settings.name;
                  // Object arguments = settings.arguments;
                  switch(routeName){
                    case "/":
                      return MaterialPageRoute(builder : (context){
                        return SwitchNavigator();
                      });
                    case "login":
                      return MaterialPageRoute(builder : (context){
                        return Login();
                      });
                    case "signup":
                      return MaterialPageRoute(builder : (context){
                        return SignUp();
                      });
                    case 'home':
                      return MaterialPageRoute(builder: (context){
                        return Home(); 
                      });
                    case "newPost": 
                    return MaterialPageRoute(fullscreenDialog: true, builder: (context){
                      return NewPost();
                    });
                    default:
                      return MaterialPageRoute(builder: (context){
                        return Container(color: Colors.red);
                      });
                  }
                },
              
              );
          }
          return Container();
        },
    );
  }
}

class SwitchNavigator extends StatefulWidget {
  SwitchNavigator({Key key}) : super(key: key);

  @override
  _SwitchNavigatorState createState() => _SwitchNavigatorState();
}

class _SwitchNavigatorState extends State<SwitchNavigator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: StreamBuilder(
         stream: FirebaseAuth.instance.authStateChanges(),
         builder: (context, AsyncSnapshot<User> snapshot){
            if(snapshot.hasError){
              print(snapshot.error);
              return Container();
            }
              if(snapshot.connectionState == ConnectionState.active){
                  if(snapshot.data == null){
                    return Login();
                  } else {
                    return Home();
                  }
              }
            return Login();
         }
       )
    );
  }
}




