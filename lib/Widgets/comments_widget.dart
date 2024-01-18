import 'package:flutter/material.dart';

class CommentWidget extends StatefulWidget {

  final String commentId;
  final String commentBody;
  final String commentorId;
  final String commentorName;
  final String commentorImageUrl;

  const CommentWidget({
    required this.commentId,
    required this.commentBody,
    required this.commentorId,
    required this.commentorName,
    required this.commentorImageUrl,
  });


  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {

  final List<Color> _colors = [
    Colors.blueAccent,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.pink.shade200,
    Colors.teal,
    Colors.cyan,
    Colors.indigo,
    Colors.brown,
    Colors.lime,
    Colors.amber,
    Colors.grey,
    Colors.deepOrange,
  ];

  @override
  Widget build(BuildContext context) {
    _colors.shuffle();
    return InkWell(
      onTap: (){},
      child:Row(
        crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: _colors[0],
                width: 2,
              ),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(widget.commentorImageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: 6,),
        Flexible(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.commentorName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4,),
              Text(
                widget.commentBody,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    );
  }
}
