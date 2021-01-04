import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'db_service.dart';

class AuthService {


  FirebaseAuth auth = FirebaseAuth.instance;
  PostService dbService = PostService();

  Future<void> createUser(String email, String password, String username) async {

    try{
      UserCredential credential =  await auth.createUserWithEmailAndPassword(email: email, password: password);
      assert(credential.user.uid != "");
      await dbService.addUserInfo(credential.user.uid, username);

    } on FirebaseException catch( e) {
      print(e);
    } catch (err) {
      print(err);
    }
    
  }
  
  Future<void> loginUser(String email, String password) async{
    try{
      UserCredential credential = await auth.signInWithEmailAndPassword(email: email, password: password);
      print("user is logged in " + credential.user.uid);
    } on FirebaseAuthException catch(err){
      print(err);
    } catch (err){
      print(err);
    }
  }

}