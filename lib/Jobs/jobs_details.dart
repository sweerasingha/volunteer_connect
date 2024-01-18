import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';
import 'package:vc_v1/Jobs/jobs_screen.dart';
import 'package:vc_v1/Services/global_methods.dart';

import '../Services/global_variables.dart';
import '../Widgets/comments_widget.dart';

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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _commentController = TextEditingController();

  bool _isCommenting = false;
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
  bool showComment = false;

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

  applyForJob()
  {
    final Uri params = Uri(
      scheme: 'mailto',
      path: emailCompany!,
      query: 'subject=Applying for the job: $jobTitle &body=Hello, please attach your CV/Resume to this email. Thank you.',
    );
    final url = params.toString();
    launchUrlString(url);
    addNewApplicants();
  }

  void addNewApplicants() async
  {
    var docRef = FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.jobId);
    docRef.update({
      'applicants': applicants + 1,
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getJobData();
  }

  Widget dividerWidget()
  {
    return const Column(

      children: [
        SizedBox(height: 10,),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        SizedBox(height: 10,),
      ],
    );
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
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 3,
                                ),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    userImageUrl == null
                                        ? 'https://climateisland.ru/wp-content/uploads/2023/05/Screenshot_9.png'
                                        : userImageUrl!,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authorName == null
                                        ? ''
                                        : authorName!,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  Text(
                                    locationCompany!,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        dividerWidget(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              applicants.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6,),
                            const Text(
                              'Applicants',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 10,),
                            const Icon(Icons.how_to_reg_sharp, color: Colors.grey,),
                          ],
                        ),
                        FirebaseAuth.instance.currentUser!.uid != widget.uploadedBy
                        ?
                            Container()
                            :
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                dividerWidget(),
                                const Text(
                                  'Recruitment',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        User? user = _auth.currentUser;
                                        final _uid = user!.uid;
                                        if(_uid == widget.uploadedBy)
                                          {
                                            try
                                                {
                                                  FirebaseFirestore.instance
                                                      .collection('jobs')
                                                      .doc(widget.jobId)
                                                      .update({
                                                    'recruitment': true,
                                                  });
                                                }
                                                catch(error)
                                        {
                                          GlobalMethod.showErrorDialog(
                                            error: 'Action cannot be performed $error',
                                            ctx: context,
                                          );
                                        }
                                          }
                                        else
                                          {
                                            GlobalMethod.showErrorDialog(
                                              error: 'You are not authorized to perform this action',
                                              ctx: context,
                                            );
                                          }
                                        getJobData();
                                      },
                                      child: Text(
                                        'On',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.normal,
                                          color: recruitment == true
                                              ? Colors.white
                                              : Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Opacity(
                                      opacity: recruitment == true ? 1 : 0,
                                      child: const Icon(
                                        Icons.check_box,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 40,),
                                    TextButton(
                                      onPressed: () {
                                        User? user = _auth.currentUser;
                                        final _uid = user!.uid;
                                        if(_uid == widget.uploadedBy)
                                        {
                                          try
                                          {
                                            FirebaseFirestore.instance
                                                .collection('jobs')
                                                .doc(widget.jobId)
                                                .update({
                                              'recruitment': false,
                                            });
                                          }
                                          catch(error)
                                          {
                                            GlobalMethod.showErrorDialog(
                                              error: 'Action cannot be performed $error',
                                              ctx: context,
                                            );
                                          }
                                        }
                                        else
                                        {
                                          GlobalMethod.showErrorDialog(
                                            error: 'You are not authorized to perform this action',
                                            ctx: context,
                                          );
                                        }
                                        getJobData();
                                      },
                                      child: Text(
                                        'Off',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.normal,
                                          color: recruitment == true
                                              ? Colors.white
                                              : Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Opacity(
                                      opacity: recruitment == false ? 1 : 0,
                                      child: const Icon(
                                        Icons.check_box,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        dividerWidget(),
                        const Text(
                          'Job Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text(
                          jobDescription == null
                              ? ''
                              : jobDescription!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                        ),
                        dividerWidget(),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10,),
                        Center(
                          child: Text(
                            isDeadLineAvailable
                            ?
                                'Actively Recruiting, Send CV/Resume:'
                            :
                                'Deadline Passed Away',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDeadLineAvailable
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6,),
                        Center(
                          child: MaterialButton(
                            onPressed: (){
                              applyForJob();
                            },
                            color: Colors.blueAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              child: Text(
                                'Easy Apply Now',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5,),
                        dividerWidget(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Uploaded on:',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              postedDate == null
                                  ? ''
                                  : postedDate!,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Deadline:',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              deadLineDate == null
                                  ? ''
                                  : deadLineDate!,
                              style: TextStyle(
                                fontSize: 15,
                                color: isDeadLineAvailable
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        dividerWidget(),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedSwitcher(
                          duration: Duration(
                            milliseconds: 500,
                          ),
                          child: _isCommenting
                              ?
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 3,
                                child: TextField(
                                  controller: _commentController,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  maxLength: 200,
                                  keyboardType: TextInputType.text,
                                  maxLines: 6,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.pink,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: MaterialButton(
                                        onPressed: () async {
                                          if(_commentController.text.length<7)
                                            {
                                              GlobalMethod.showErrorDialog(
                                                error: 'Comment must be at least 7 characters long',
                                                ctx: context,
                                              );
                                            }
                                          else
                                            {
                                              final _generatedId = const Uuid().v4();
                                              await FirebaseFirestore.instance
                                                  .collection('jobs')
                                                  .doc(widget.jobId)
                                              .update({
                                                'jobComments': FieldValue.arrayUnion([
                                                  {
                                                    'userID' : FirebaseAuth.instance.currentUser!.uid,
                                                    'commentId': _generatedId,
                                                    'name' : name,
                                                    'userImageUrl' : userImage,
                                                    'commentBody': _commentController.text,
                                                    'time': Timestamp.now(),
                                                  }
                                                ]),
                                              });
                                              await Fluttertoast.showToast(
                                                msg: 'Comment posted successfully',
                                                toastLength: Toast.LENGTH_LONG,
                                                backgroundColor: Colors.grey,
                                                textColor: Colors.white,
                                                fontSize: 18.0,
                                              );
                                              _commentController.clear();
                                            }
                                          setState(() {
                                            showComment = true;
                                          });
                                        },
                                        color: Colors.blueAccent,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'Post',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: (){
                                        setState(() {
                                          _isCommenting = !_isCommenting;
                                          showComment = false;
                                        });
                                      },
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                              :
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: (){
                                      setState(() {
                                        _isCommenting = !_isCommenting;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.add_comment,
                                      color: Colors.blueAccent,
                                      size: 40,
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                  IconButton(
                                    onPressed: (){
                                      setState(() {
                                        showComment = true;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.arrow_drop_down_circle,
                                      color: Colors.blueAccent,
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                        ),
                        showComment == false
                            ?
                        Container()
                            :
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('jobs')
                                    .doc(widget.jobId)
                                    .get(),
                                builder: (context, snapshot)
                                  {
                                    if(snapshot.connectionState == ConnectionState.waiting)
                                      {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    else
                                      {
                                        if(snapshot.data == null)
                                          {
                                            const Center(
                                              child: Text(
                                                'No comments yet',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                        return ListView.separated(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index)
                                            {
                                              return CommentWidget(
                                                commentId: snapshot.data!['jobComments'][index]['commentId'],
                                                commentorId: snapshot.data!['jobComments'][index]['userID'],
                                                commentorName: snapshot.data!['jobComments'][index]['name'],
                                                commentBody: snapshot.data!['jobComments'][index]['commentBody'],
                                                commentorImageUrl: snapshot.data!['jobComments'][index]['userImageUrl'],
                                              );
                                            },
                                          separatorBuilder: (context, index)
                                            {
                                              return const Divider(
                                                thickness: 1,
                                                color: Colors.grey,
                                              );
                                            },
                                          itemCount: snapshot.data!['jobComments'].length,
                                        );
                                      },
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
