import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Services/global_variables.dart' as globals; // import as globals

class Persistent {
  static List<String> jobCategoryList = [
    'Architecture and Construction',
    'Education and Training',
    'Finance',
    'Health Science',
    'Hospitality and Tourism',
    'Human Services',
    'Information Technology',
    'Development - Programming',
    'Business',
    'Design',
    'Marketing',
    'Accounting',
  ];

  void getMyData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    globals.name = userDoc['name']; // use globals.name
    globals.userImage = userDoc['imageUrl']; // use globals.userImage
    globals.location = userDoc['location']; // use globals.location
  }
}
