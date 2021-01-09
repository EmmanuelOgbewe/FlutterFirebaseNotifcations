import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:push_notifications_firebase/models/post.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PostService {

  final db = FirebaseFirestore.instance;
  final fcm = FirebaseMessaging();

  Future<void> addUserInfo(String userID, String username) async {
    await db.collection("users").doc(userID).set({
      "userID" : userID,
      "username" : username,
    });
  }

  Future<void> newPost(String post, String username, String userID, String profileImg) async{
   
    var data = {
      "post" : post,
      "profileImg": profileImg,
      "creator" : username,
      "creatorID" : userID,
      "created" : DateTime.now()
    };

    await db.collection("posts").add(data);
  }

  void removePost(String id) {
     db.collection("posts").doc(id).delete();
  }
  
  void likePost(String userID, String postID){
    db.collection("posts").doc(postID).update({
        "likes" : FieldValue.arrayUnion([userID])
    });
  }

  void unlikePost(String userID, String postID){
     db.collection("posts").doc(postID).update({
        "likes" : FieldValue.arrayRemove([userID])
    });
  }

  Stream<List<Post>> getAllPosts(){
    return  db.collection("posts").orderBy('created', descending: true).snapshots().map((snapshot) => snapshot.docs.map((snap) => Post.fromJson(snap.data(), snap.id)).toList());
  }

  Future<void> saveToken(String token, String userID) async {
    // get auth instance 
 

    await db.collection("users").doc(userID).set({
      "tokens" : FieldValue.arrayUnion([token])
    }, SetOptions(merge: true));
  }

  void subscribeToTopic(String topicName) {
    fcm.subscribeToTopic(topicName);
  }
  
}
