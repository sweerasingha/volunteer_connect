import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:vc_v1/Jobs/upload_job.dart';
import 'package:vc_v1/Search/search_companies.dart';

import '../Jobs/jobs_screen.dart';
import '../Search/pofile_company.dart';

class BottomNavigationBarForApp extends StatelessWidget {

  int indexNum = 0;

  BottomNavigationBarForApp({required this.indexNum});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color : Colors.deepOrange.shade400,
      backgroundColor: Colors.blueAccent,
      buttonBackgroundColor: Colors.deepOrange.shade300,
      height: 50,
      index: indexNum,
      items: [
        Icon(Icons.list, size: 19, color: Colors.black),
        Icon(Icons.search, size: 19, color: Colors.black),
        Icon(Icons.add, size: 19, color: Colors.black),
        Icon(Icons.person_pin, size: 19, color: Colors.black),
      ],
      animationDuration: Duration(
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
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
            }

        }
    );
  }
}
