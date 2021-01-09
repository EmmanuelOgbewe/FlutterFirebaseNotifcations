import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'db_service.dart';

class AuthService {


  FirebaseAuth _auth = FirebaseAuth.instance;
  PostService _dbService = PostService();

  Future<void> createUser(String email, String password, String username, String photoUrl) async {

    try{
      UserCredential credential =  await _auth.createUserWithEmailAndPassword(email: email, password: password);
      assert(credential.user.uid != "");
      
      await credential.user.updateProfile(displayName: username, photoURL: photoUrl);
      await _dbService.addUserInfo(credential.user.uid, username);

    } on FirebaseException catch( e) {
      throw(e);
     
    } catch (err) {
      throw(err);
     
    }
    
  }
  
  Future<void> loginUser(String email, String password) async{
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      print("user is logged in " + credential.user.uid);
    } on FirebaseAuthException catch(err){
      print(err);
    } catch (err){
      print(err);
    }
  }

}