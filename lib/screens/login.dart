import 'package:flutter/material.dart';
import 'package:push_notifications_firebase/screens/signup.dart';
import 'package:push_notifications_firebase/services/auth_service.dart';


class Login extends StatefulWidget {
  static const String routeName = "login";
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  

  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
       backgroundColor: Colors.white,
       body: Padding(
         padding: const EdgeInsets.only(left: 15.0, right: 15.0),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Text("Login", style: Theme.of(context).primaryTextTheme.headline6),
             TextFormField(
               controller: emailController,
               decoration: InputDecoration(
                 helperText: "Email",
               ),
               
             ),
             TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                 helperText: "Password",
               ),
              
             ),
              RaisedButton(
               child: Text('Sign Up'),
               onPressed: (){
                 Navigator.of(context).pushNamed(SignUp.routeName);
               },
             ),
             RaisedButton(
               child: Text("Login"),
               onPressed: (){
                 // log user in 
                 FocusScope.of(context).unfocus();
                 if(passwordController.text.isNotEmpty && emailController.text.isNotEmpty){
                   print("log user in ");
                   auth.loginUser(emailController.text, passwordController.text);
                 }
               },
             )
           ],
         ),
       ) ,
    );
  }
}