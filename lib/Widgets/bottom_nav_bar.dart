import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vc_v1/Jobs/upload_job.dart';
import 'package:vc_v1/Search/search_companies.dart';
import 'package:vc_v1/user_state.dart';

import '../Jobs/jobs_screen.dart';
import '../Search/pofile_company.dart';

class BottomNavigationBarForApp extends StatelessWidget {

  int indexNum = 0;

  BottomNavigationBarForApp({required this.indexNum});

  void _logout(context)
  {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    showDialog(
      context: context,
      builder: (context)
        {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                ),
              ],
            ),
            content: const Text(
              'Are you sure you want to sign out?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                  'No',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                onPressed: (){
                  _auth.signOut();
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => UserState()));
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color : Colors.redAccent.shade200,
      backgroundColor: Colors.white,
      buttonBackgroundColor: Colors.redAccent.shade400,
      height: 50,
      index: indexNum,
      items: const [
        Icon(Icons.list, size: 19, color: Colors.black),
        Icon(Icons.search, size: 19, color: Colors.black),
        Icon(Icons.add, size: 19, color: Colors.black),
        Icon(Icons.person_pin, size: 19, color: Colors.black),
        Icon(Icons.exit_to_app, size: 19, color: Colors.black),
      ],
      animationDuration: const Duration(
        milliseconds: 300,
      ),
      animationCurve: Curves.bounceInOut,
      onTap: (index)
        {
          if (index == 0)
            {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => JobScreen()));
            }
          else if (index == 1)
            {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AllWorkersScreen()));
            }
          else if (index == 2)
            {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => UploadJobNow()));
            }
          else if (index == 3)
            {
              final FirebaseAuth _auth = FirebaseAuth.instance;
              final User? user = _auth.currentUser;
              final String? uid = user!.uid;
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfileScreen(
                userId: uid!,
              )));
            }
          else if (index == 4)
            {
              _logout(context);
            }

        }
    );
  }
}
