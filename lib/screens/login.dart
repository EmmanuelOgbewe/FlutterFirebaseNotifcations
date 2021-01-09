import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      
      resizeToAvoidBottomInset: true,
       backgroundColor: Colors.white,
       body: Center(
         child: Padding(
           padding: const EdgeInsets.only(left: 15.0, right: 15.0),
           child: SingleChildScrollView(
              reverse: true,
              child: Container(
              // color: Colors.red,
               width: double.infinity,
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text("Login", style: TextStyle(fontSize: 24.0 ,color: Colors.black)),
                   SizedBox(height: 20),
                   TextFormField(
                     controller: emailController,
                     decoration: InputDecoration(
                       helperText: "Email",
                     ),
                     
                   ),
                   TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                       helperText: "Password",
                     ),
                   ),
                   SizedBox(height: 50),
                    Container(
                      height: 45,
                      width: double.infinity,
                      child: RaisedButton(
                       child: Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 17.0)),
                       onPressed: (){
                         Navigator.of(context).pushNamed(SignUp.routeName);
                       },
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      height: 45,
                      width: double.infinity,
                      child: RaisedButton(
                        child: Text('Log In', style: TextStyle(color: Colors.white, fontSize: 17.0)),
                        onPressed: (){
                          // log user in 
                          FocusScope.of(context).unfocus();
                          if(passwordController.text.isNotEmpty && emailController.text.isNotEmpty){
                            print("log user in ");
                            auth.loginUser(emailController.text, passwordController.text);
                          }
                        },
                      ),
                    )
                 ],
               ),
             ),
           ),
         ),
       ) ,
    );

  }
  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    emailController.dispose();
  }
}