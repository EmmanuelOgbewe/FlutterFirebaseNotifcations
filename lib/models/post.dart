import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String post;
  final String username;
  final Timestamp created; 
  final String postID;
  final List<dynamic> likedIds;

  const Post({this.post,this.username, this.created, this.postID, this.likedIds});

  factory Post.fromJson(Map<String,dynamic> data, String id){
    return Post(post: data["post"], username: data["creator"], created: data["created"], postID: id, likedIds: data["likes"] ?? []);
  }
  //retunr true if user liked post
  bool userLikedPost(String username){
    return likedIds.contains(username);
  }

}