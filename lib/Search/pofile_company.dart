import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vc_v1/user_state.dart';

import '../Widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {

  final String userId;

  const ProfileScreen({
    required this.userId,
});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? name;
  String? email ='';
  String? phoneNumber ='';
  String? imageUrl ='';
  String? joinedAt ='';
  bool _isLoading = false;
  bool _isSameUser = false;

  void getUserData() async{
    try
        {
          _isLoading = true;
          final DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userId)
              .get();
          if(userDoc == null )
          {
            return;
          }
          else
          {
            setState(() {
              name = userDoc.get('name');
              email = userDoc.get('email');
              phoneNumber = userDoc.get('phoneNumber');
              imageUrl = userDoc.get('imageUrl');
              Timestamp joinedAtTimeStamp = userDoc.get('createdAt');
              var joinedDate = joinedAtTimeStamp.toDate();
              joinedAt = '${joinedDate.year} - ${joinedDate.month} - ${joinedDate.day}';
            });
            User? user = _auth.currentUser;
            final _uid = user!.uid;
            setState(() {
              if(_uid == widget.userId)
              {
                _isSameUser = true;
              }
              else
              {
                _isSameUser = false;
              }
            });
          }
        }
        catch(error){}
    finally
        {
          _isLoading = false;
        }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  Widget userInfo({required IconData icon, required String content})
  {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              color: Colors.white54,
            ),
          ),
        ),
      ],
    );
  }

  Widget _contactBy
      ({
    required Color color,
    required Function fct,
    required IconData icon,
      })
  {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 23,
        child: IconButton(
          onPressed: (){
            fct();
          },
          icon: Icon(
            icon,
            color: color,
          ),
        ),
      ),
    );
  }

  void _openWhatsAppChat() async
  {
    var url = 'https://wa.me/$phoneNumber?text=HelloWold';
    launchUrlString(url);
  }

  void _mailTo() async
  {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Write subject here, Please&body=Hello, please write details here',
    );
    final url = params.toString();
    launchUrlString(url);
  }

  void _call() async
  {
    var url = 'tel://$phoneNumber';
    launchUrlString(url);
  }


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrange.shade300, Colors.blueAccent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.2,0.9],
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 3,),
        backgroundColor: Colors.transparent,
        body: Center(
          child: _isLoading
              ?
              const Center(child: CircularProgressIndicator(),)
              :
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Stack(
                    children: [
                      Card(
                        color: Colors.white10,
                        margin: const EdgeInsets.all(30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 100,),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  name == null
                                      ?
                                  'Name here'
                                      :
                                  name!,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15,),
                              const Divider(
                                color: Colors.white,
                                thickness: 1,
                              ),
                              const SizedBox(height: 30,),
                              const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Account Information',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.white54,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: userInfo(icon: Icons.email, content: email == null ? 'Email here' : email!),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: userInfo(icon: Icons.phone, content: phoneNumber == null ? 'Phone number here' : phoneNumber!),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Divider(
                                color: Colors.white,
                                thickness: 1,
                              ),
                              const SizedBox(
                                height: 35,
                              ),
                              _isSameUser
                                  ?
                                  Container()
                                  :
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      _contactBy(color: Colors.green, fct: _openWhatsAppChat, icon: FontAwesome.whatsapp),
                                      _contactBy(color: Colors.red, fct: _mailTo, icon: Icons.mail_outline),
                                      _contactBy(color: Colors.blue, fct: _call, icon: Icons.call),
                                    ],
                                  ),
                              const SizedBox(
                                height: 25,
                              ),
                              ! _isSameUser
                                  ?
                                  Container()
                                  :
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 30),
                                      child: MaterialButton(
                                        onPressed: (){
                                          _auth.signOut();
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(
                                                builder: (context)=> UserState(),));
                                        },
                                        color: Colors.black,
                                        elevation: 8,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(13),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 14),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Log Out',
                                                style: TextStyle(
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontFamily: 'Signatra',
                                                ),
                                              ),
                                              SizedBox(width: 8,),
                                              Icon(
                                                Icons.logout,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size.width * 0.26,
                            height: size.width * 0.26,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                width: 8,
                              ),
                              image: DecorationImage(
                                image: imageUrl == null
                                    ?
                                const NetworkImage('https://pushinka.top/uploads/posts/2023-03/1679887666_pushinka-top-p-matematika-avatarka-vkontakte-68.jpg')
                                    :
                                NetworkImage(imageUrl!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
