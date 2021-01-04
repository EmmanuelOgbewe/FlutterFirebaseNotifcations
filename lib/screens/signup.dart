
import 'package:flutter/material.dart';
import 'package:push_notifications_firebase/screens/login.dart';
import 'package:push_notifications_firebase/services/auth_service.dart';


class SignUp extends StatefulWidget {
 static const String routeName = "signup";
 SignUp({Key key}) : super(key: key);

  @override
   SignUpState createState() =>  SignUpState();
}

class  SignUpState extends State<SignUp> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Padding(
         padding: const EdgeInsets.only(left: 15.0, right: 15.0),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           
           children: [
             Text("Login", style: Theme.of(context).primaryTextTheme.headline6),
             TextFormField(
               controller: usernameController,
               decoration: InputDecoration(
                 helperText: "Username",
               ),
               
             ),
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
               child: Text("Login"),
               onPressed: (){
                 Navigator.of(context).pop();
               },
             ),
             RaisedButton(
                child: Text("Sign Up"),
              
                onPressed: ()  {
                 // log user in 
                FocusScope.of(context).unfocus();
                 if(passwordController.text.isNotEmpty && emailController.text.isNotEmpty && usernameController.text.isNotEmpty){
                   
                   auth.createUser(emailController.text, passwordController.text, usernameController.text);
                 } 
               },
             )
           ],
         ),
       ) ,
    );
  }
}