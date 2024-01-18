import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vc_v1/Search/pofile_company.dart';

class AllWorkersWidget extends StatefulWidget {

  final String userId;
  final String userName;
  final String userEmail;
  final String userImageUrl;
  final String phoneNumber;

  AllWorkersWidget({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userImageUrl,
    required this.phoneNumber,
  });

  @override
  State<AllWorkersWidget> createState() => _AllWorkersWidgetState();
}

class _AllWorkersWidgetState extends State<AllWorkersWidget> {

  void _mailTo() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: widget.userEmail,
      query: 'subject=Write subject here, Please&body=Hello, please write details here',
    );
    final url = params.toString();
    try {
      await launchUrlString(url);
    } catch (e) {
      print('Could not launch $url. Exception: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.white10,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfileScreen(userId: widget.userId)));
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20,
            backgroundImage: NetworkImage(
                widget.userImageUrl == null
                    ? 'https://pushinka.top/uploads/posts/2023-03/1679887666_pushinka-top-p-matematika-avatarka-vkontakte-68.jpg'
                    : widget.userImageUrl
            ),
          ),
        ),
        title: Text(
          widget.userName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Visit Profile',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing: IconButton(
           icon: const Icon(
            Icons.mail_outline,
            color: Colors.grey,
            size: 30,
          ),
          onPressed: () {
            _mailTo();
          },
        ),
      ),
    );
  }
}
