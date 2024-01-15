import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vc_v1/Jobs/jobs_screen.dart';

class JobDetailsScreen extends StatefulWidget {

  final String jobId;
  final String uploadedBy;

  JobDetailsScreen({
    required this.jobId,
    required this.uploadedBy,
  });

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {

  String? authorName;
  String? userImageUrl;
  String? jobCategory;
  String? jobDescription;
  String? jobTitle;
  bool? recruitment;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadLineDateTimeStamp;
  String? postedDate;
  String? deadLineDate;
  String? locationCompany ='';
  String? emailCompany ='';
  int applicants = 0;
  bool isDeadLineAvailable = false;

  void getJobData() async
  {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uploadedBy)
        .get();

    if(userDoc == null)
      {
        return;
      }
    else
      {
        setState(() {
          authorName = userDoc.get('name');
          userImageUrl = userDoc.get('imageUrl');
        });
      }
    final DocumentSnapshot jobDatabase = await FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.jobId)
        .get();

    if(jobDatabase == null)
      {
        return;
      }
    else
      {
        setState(() {
          jobCategory = jobDatabase.get('jobCategory');
          jobDescription = jobDatabase.get('jobDescription');
          jobTitle = jobDatabase.get('jobTitle');
          recruitment = jobDatabase.get('recruitment');
          emailCompany = jobDatabase.get('email');
          postedDateTimeStamp = jobDatabase.get('createdAt');
          deadLineDateTimeStamp = jobDatabase.get('jobDeadlineTimeStamp');
          locationCompany = jobDatabase.get('location');
          emailCompany = jobDatabase.get('email');
          applicants = jobDatabase.get('applicants');
          deadLineDate = jobDatabase.get('jobDeadline');
          var postDate = postedDateTimeStamp!.toDate();
          postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
        });

        var date = deadLineDateTimeStamp!.toDate();
        isDeadLineAvailable = date.isAfter(DateTime.now());
      }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getJobData();
  }

  @override
  Widget build(BuildContext context) {
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
          leading: IconButton(
            icon: const Icon(Icons.close, size: 40, color: Colors.white,),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JobScreen()));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            jobTitle == null
                                ? ''
                                : jobTitle!,
                            maxLines: 3,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
