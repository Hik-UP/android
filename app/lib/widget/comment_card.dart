import "package:flutter/material.dart";
import "package:hikup/model/comment.dart";

class CommentCard extends StatelessWidget {
  final Comment comment;
  const CommentCard({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
