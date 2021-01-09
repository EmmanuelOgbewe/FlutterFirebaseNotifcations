import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:push_notifications_firebase/services/db_service.dart';


class PostCard extends StatefulWidget {
  final post;
  final username;
  final id;
  final profileImg;
  final liked;

   PostCard({
    Key key,
    this.post,
    this.id,
    this.username,
    this.profileImg,
    this.liked = false
  }) : super(key: key) ;

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final postService = PostService();
  final currentUserID = FirebaseAuth.instance.currentUser.uid;

  bool isLiked;

  @override
  void initState() {
    super.initState();
     isLiked =  widget.liked;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          widget.profileImg
        ) ,
      ) ,
      title: Text.rich(
        TextSpan(children: [
          TextSpan(
            text : widget.username + " ",
            style: TextStyle(
              
            )
          ),

        ])
      ),
      subtitle: Text(widget.post),
      trailing: IconButton(
        icon : Icon(Icons.favorite, color: isLiked ? Colors.red : Colors.grey.shade600,),
        onPressed: (){
          // like or unlike
          setState(() {
            isLiked = !isLiked;
          });
          if(isLiked){
            postService.likePost(currentUserID, widget.id);
          } else {
            postService.unlikePost(currentUserID, widget.id);
          }
        },
      ),
    );
  }
}