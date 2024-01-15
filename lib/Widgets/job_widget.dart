import 'package:flutter/material.dart';

class JobWidget extends StatefulWidget {

  final String jobTitle;
  final String jobDescription;
  final String jobId;
  final String uploadedBy;
  final String userImage;
  final String name;
  final bool recruitment;
  final String email;
  final String location;

  const JobWidget({
    required this.jobTitle,
    required this.jobDescription,
    required this.jobId,
    required this.uploadedBy,
    required this.userImage,
    required this.name,
    required this.recruitment,
    required this.email,
    required this.location,
  });

  @override
  State<JobWidget> createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {
  @override
  Widget build(BuildContext context) {
    print("test all ");
    print('test title - ${widget.jobTitle} ');
    print('test description - ${widget.jobDescription} ');
    print('test id - ${widget.jobId} ');
    print('test uploadedBy - ${widget.uploadedBy} ');
    print('test userImage - ${widget.userImage} ');
    print('test name - ${widget.name} ');
    print('test recruitment - ${widget.recruitment} ');
    print('test email - ${widget.email} ');
    print('test location - ${widget.location} ');
     return Card(
      color: Colors.white24,
      elevation: 8,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      child: ListTile(
        onTap: () {},
        onLongPress: () {},
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(
                width: 1,
                color: Colors.white24,
              ),
            ),
          ),
          child: Image.network(
            widget.userImage,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          widget.jobTitle,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.jobDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          color: Colors.black,
          size: 30,
        ),
      ),
    );
  }
}
