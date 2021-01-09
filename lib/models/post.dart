import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String post;
  final String username;
  final Timestamp created; 
  final String postID;
  final String profileImg;
  final List<dynamic> likedIds;

  const Post({this.post,this.username, this.created, this.postID, this.likedIds, this.profileImg});

  factory Post.fromJson(Map<String,dynamic> data, String id){
    return Post(post: data["post"], username: data["creator"], created: data["created"], postID: id, likedIds: data["likes"] ?? [], profileImg: data["profileImg"]);
  }
  //retunr true if user liked post
  bool userLikedPost(String userID){
    return likedIds.contains(userID);
  }

}