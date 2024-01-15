import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vc_v1/Search/search_job.dart';
import 'package:vc_v1/Widgets/bottom_nav_bar.dart';
import 'package:vc_v1/Widgets/job_widget.dart';
import 'package:vc_v1/user_state.dart';

import '../Persistent/persistent.dart';

class JobScreen extends StatefulWidget {

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {

  String? jobCategoryfilter;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Text(
              'Job Category',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Persistent.jobCategoryList.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          jobCategoryfilter = Persistent
                              .jobCategoryList[index];
                        });
                        Navigator.canPop(context) ? Navigator.pop(context) : null;
                        print(
                          'jobCategoryfilter: $jobCategoryfilter'
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_right_alt_outlined,
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Persistent.jobCategoryList[index],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    jobCategoryfilter = null;
                  });
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                  'Clear',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
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
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 0),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepOrange.shade300, Colors.blueAccent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.2,0.9],
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Colors.black,),
            onPressed: (){
              _showTaskCategoriesDialog(size: size);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search_outlined, color: Colors.black,),
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => SearchScreen()));

              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('jobs')
              .where('recruitment', isEqualTo: true)
              .orderBy('createdAt', descending: false)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Filter the jobs by the jobCategoryfilter if it's not null
            var filteredDocs = jobCategoryfilter != null
                ? snapshot.data!.docs.where((doc) => doc['jobCategory'] == jobCategoryfilter).toList()
                : snapshot.data!.docs;

            if (filteredDocs.isEmpty) {
              return const Center(
                child: Text(
                  'No jobs found',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: filteredDocs.length,
              itemBuilder: (BuildContext context, int index) {
                var doc = filteredDocs[index];
                return JobWidget(
                  jobTitle: doc['jobTitle'],
                  jobDescription: doc['jobDescription'],
                  jobId: doc['jobId'],
                  uploadedBy: doc['uploadedBy'],
                  userImage: doc['userImage'],
                  name: doc['name'],
                  recruitment: doc['recruitment'],
                  email: doc['email'],
                  location: doc['location'],
                );
              },
            );
          },
        )

      ),
      );
  }
}
