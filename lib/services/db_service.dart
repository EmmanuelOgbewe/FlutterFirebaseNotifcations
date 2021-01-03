import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:push_notifications_firebase/models/post.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PostService {

  final db = FirebaseFirestore.instance;
  final fcm = FirebaseMessaging();

  Future<void> newPost(String post, String username) async{
   
    var data = {
      "post" : post,
      "creator" : username,
      "created" : DateTime.now()
    };

    await db.collection("posts").add(data);
  }

  void removePost(String id) {
     db.collection("posts").doc(id).delete();
  }

  Stream<List<Post>> getAllPosts(){
    return  db.collection("posts").orderBy('created', descending: true).snapshots().map((snapshot) => snapshot.docs.map((snap) => Post.fromJson(snap.data(), snap.id)).toList());
  }

  Future<void> saveToken(String token) async {
    // get auth instance 
    String userID = "";

    await db.collection("users").doc(userID).update({
      "tokens" : FieldValue.arrayUnion([token])
    });
  }

  void subscribeToTopic(String topicName) {
    fcm.subscribeToTopic(topicName);
  }
  
}
