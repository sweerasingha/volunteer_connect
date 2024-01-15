import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vc_v1/Services/global_methods.dart';

import '../Jobs/jobs_details.dart';

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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  _deleteDialog()
  {
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () async {
                if (!mounted) return; // Add this check to ensure the widget is still in the tree

                try {
                  if (widget.uploadedBy == _uid) {
                    await FirebaseFirestore.instance.collection('jobs').doc(widget.jobId).delete();
                    await Fluttertoast.showToast(
                      msg: 'Job deleted successfully',
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 18.0,
                    );

                    if (mounted) { // Check again before calling Navigator
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                    }
                  } else {
                    GlobalMethod.showErrorDialog(
                      error: 'You are not authorized to delete this job',
                      ctx: ctx,
                    );
                  }
                } catch (error) {
                  print('error occured $error');
                  if (mounted) { // Check again before showing the error dialog
                    GlobalMethod.showErrorDialog(
                      error: error.toString(),
                      ctx: ctx,
                    );
                  }
                }
              },

              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 30,
                  ),
                  Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    );
  }

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
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => JobDetailsScreen(
                uploadedBy: widget.uploadedBy,
                jobId: widget.jobId,
              ),
            ),
          );

        },
        onLongPress: () {
          _deleteDialog();
        },
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
