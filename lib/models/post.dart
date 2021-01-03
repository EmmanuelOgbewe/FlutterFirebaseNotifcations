import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String post;
  final String username;
  final Timestamp created; 
  final String postID;
  const Post({this.post,this.username, this.created, this.postID});

  factory Post.fromJson(Map<String,dynamic> data, String id){
    return Post(post: data["post"], username: data["creator"], created: data["created"], postID: id);
  }

}