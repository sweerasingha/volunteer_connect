import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:vc_v1/Persistent/persistent.dart';

import '../Services/global_methods.dart';
import '../Services/global_variables.dart';
import '../Widgets/bottom_nav_bar.dart';

class UploadJobNow extends StatefulWidget {

  @override
  State<UploadJobNow> createState() => _UploadJobNowState();
}

class _UploadJobNowState extends State<UploadJobNow> {

  final TextEditingController _jobCategoryController = TextEditingController(
      text: 'Select Job Category');
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController = TextEditingController();
  final TextEditingController _jobDeadlineController = TextEditingController(
      text: 'Select Deadline Date');

  final _formKey = GlobalKey<FormState>();
  DateTime? picked;
  Timestamp? deadLineDateTimeStamp;
  bool _isLoading = false;

  void dispose()
  {
    _jobCategoryController.dispose();
    _jobTitleController.dispose();
    _jobDescriptionController.dispose();
    _jobDeadlineController.dispose();
    super.dispose();
  }

  Widget _textTitles({required String label}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _textFormFields({
    required String valueKey,
    required TextEditingController controller,
    required bool enabled,
    required Function fct,
    required int maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'Value is missing';
            }
            return null;
          },
          controller: controller,
          enabled: enabled,
          key: ValueKey(valueKey),
          style: const TextStyle(
            color: Colors.white,
          ),
          maxLines: valueKey == 'JobDescription' ? 3 : 1,
          // maxLength: valueKey == 'JobCategory' ? null : maxLength,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.black54,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
          ),
        ),

      ),
    );
  }

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
                          _jobCategoryController.text = Persistent
                              .jobCategoryList[index];
                        });
                        Navigator.pop(context);
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
                  'Cancel',
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

  void _pickDateDialog() async
  {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        const Duration(days: 0),
      ),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _jobDeadlineController.text =
        '${picked!.year} - ${picked!.month} - ${picked!.day}';
        deadLineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            picked!.microsecondsSinceEpoch);
      });
    }
  }

  void _uploadTask() async
  {
    final jobId = const Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final _uid = user!.uid;
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      if (_jobDeadlineController.text == 'Select Deadline Date' ||
          _jobCategoryController.text == 'Select Job Category') {
        GlobalMethod.showErrorDialog(
            error: 'Please select a deadline date and a job category',
            ctx: context);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance.collection('jobs').doc(jobId).set({
          'jobId': jobId,
          'uploadedBy': _uid,
          'email': user.email,
          'jobCategory': _jobCategoryController.text,
          'jobTitle': _jobTitleController.text,
          'jobDescription': _jobDescriptionController.text,
          'jobDeadline': _jobDeadlineController.text,
          'jobDeadlineTimeStamp': deadLineDateTimeStamp,
          'jobComments': [],
          'recruitment': true,
          'createdAt': Timestamp.now(),
          'name': name,
          'userImage': userImage,
          'location': location,
          'applicants': 0,
        });
        await Fluttertoast.showToast(
          msg: 'Job uploaded successfully',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.grey,
          fontSize: 18.0,
        );
        _jobTitleController.clear();
        _jobDescriptionController.clear();
        setState(() {
          _jobCategoryController.text = 'Select Job Category';
          _jobDeadlineController.text = 'Select Deadline Date';
        });
      }
      catch (error) {
        {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
      }
      }

    finally
    {
    setState(() {
    _isLoading = false;
    });
    }
  }

  else
  {
  print("It is not valid ");
  }
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
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 2,),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(7.0),
            child: Card(
              color: Colors.white10,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Please fill all fields',
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Signatra',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _textTitles(label: 'Job Category :'),
                            _textFormFields(
                              valueKey: 'JobCategory',
                              controller: _jobCategoryController,
                              enabled: false,
                              fct: (){
                                _showTaskCategoriesDialog(size: size);
                              },
                              maxLength: 100,
                            ),
                            _textTitles(label: 'Job Title :'),
                            _textFormFields(
                              valueKey: 'JobTitle',
                              controller: _jobTitleController,
                              enabled: true,
                              fct: (){},
                              maxLength: 100,
                            ),
                            _textTitles(label: 'Job Description :'),
                            _textFormFields(
                              valueKey: 'JobDescription',
                              controller: _jobDescriptionController,
                              enabled: true,
                              fct: (){},
                              maxLength: 100,
                            ),
                            _textTitles(label: 'Job Deadline Date :'),
                            _textFormFields(
                              valueKey: 'Deadline',
                              controller: _jobDeadlineController,
                              enabled: false,
                              fct: (){
                                _pickDateDialog();
                              },
                              maxLength: 100,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _isLoading
                          ? const CircularProgressIndicator()
                            : MaterialButton(
                          onPressed: (){
                            _uploadTask();
                          },
                          color: Colors.black,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Post Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Signatra',
                                  ),
                                ),
                                SizedBox(width: 9,),
                                Icon(
                                  Icons.upload_file,
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
          ),
        ),
      ),
    );
  }
}
