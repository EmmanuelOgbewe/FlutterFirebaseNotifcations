import 'package:flutter/material.dart';
import 'package:push_notifications_firebase/services/db_service.dart';

class PostCard extends StatefulWidget {
  final post;
  final username;
  final id;
  final liked;

   PostCard({
    Key key,
    this.post,
    this.id,
    this.username,
    this.liked = false
  }) : super(key: key) ;

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final postService = PostService();
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
          "https://cdn.now.howstuffworks.com/media-content/0b7f4e9b-f59c-4024-9f06-b3dc12850ab7-1920-1080.jpg"
        ),
      ),
      title: Text.rich(
        TextSpan(children: [
          TextSpan(
            text : widget.username + " ",
            style: TextStyle(
              
            )
          ),
          TextSpan(
            text : 'now',
            style: TextStyle(
              color: Colors.grey.shade700
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
            postService.likePost("robot64", widget.id);
          } else {
             postService.unlikePost("robot64", widget.id);
          }
        },
      ),
    );
  }
}