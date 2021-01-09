
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:push_notifications_firebase/services/auth_service.dart';

import 'home.dart';


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
  final TextEditingController imageUrlController = TextEditingController();

  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Padding(
         padding: const EdgeInsets.only(left: 15.0, right: 15.0),
         child: Center(
           child: SingleChildScrollView(
             reverse: true,
              child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               
               children: [
                 Text("Sign Up", style: TextStyle(fontSize: 24.0 ,color: Colors.black)),
                 SizedBox(height: 20),
                 TextFormField(
                   controller: usernameController,
                   decoration: InputDecoration(
                     helperText: "Username",
                   ),
                   
                 ),
                 TextFormField(
                   controller: imageUrlController,
                   maxLength: 120,
                   decoration: InputDecoration(
                     helperText: "Profile Image Url",
                     
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
                 SizedBox(height: 50.0),
                 Container(
                   height: 45.0,
                   width: double.infinity,
                   child: RaisedButton(
                     child: Text("Login", style: TextStyle(fontSize: 17.0, color:Colors.white)),
                     onPressed: (){
                       Navigator.of(context).pop();
                     },
                   ),
                 ),
                 SizedBox(height: 10.0),
                 Container(
                   height: 45.0,
                    width: double.infinity,
                   child: RaisedButton(
                      child: Text("Sign Up", style: TextStyle(fontSize: 17.0, color:Colors.white)),
                    
                      onPressed: ()  async {
                       // log user in 
                      FocusScope.of(context).unfocus();
                       if(passwordController.text.isNotEmpty && emailController.text.isNotEmpty && usernameController.text.isNotEmpty && imageUrlController.text.isNotEmpty){
                         try{
                           await  auth.createUser(emailController.text, passwordController.text, usernameController.text, imageUrlController.text);
                           Navigator.of(context).pushReplacementNamed(Home.routeName);
                         } catch (err){
                           print("ERROR Caught: " + err.message);
                         }
                        
                       } 
                     },
                   ),
                 )
               ],
             ),
           ),
         ),
       ) ,
    );
  }
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
  }
}