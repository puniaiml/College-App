// ignore_for_file: avoid_print

import 'dart:io';
import 'package:college_app/admin/a_notes/view_pdf.dart';
import 'package:college_app/admin/ad_home.dart';
// import 'package:college_app/widgets/bottom_navigation_foradmin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class UploadPdfPage extends StatefulWidget {
  final String selectedCollege;
  final String branch;
  final String semester;
  final String subject;
  final String module;

  const UploadPdfPage({
    super.key,
    required this.selectedCollege,
    required this.branch,
    required this.semester,
    required this.subject,
    required this.module,
  });

  @override
  // ignore: library_private_types_in_public_api
  _UploadPdfPageState createState() => _UploadPdfPageState();
}

class _UploadPdfPageState extends State<UploadPdfPage> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future<void> uploadFile() async {
    if (pickedFile == null) return;

    final path =
        'Notes/${widget.selectedCollege}/${widget.branch}/${widget.semester}/${widget.subject}/${widget.module}/${pickedFile!.name}';
    final file = pickedFile!.path;

    if (file == null) return;

    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putFile(File(file));
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();

    await _firebaseFirestore.collection("notes").add({
      "college": widget.selectedCollege,
      "branch": widget.branch,
      "semester": widget.semester,
      "subject": widget.subject,
      "module": widget.module,
      "name": pickedFile!.name,
      "url": urlDownload,
    });

    setState(() {
      uploadTask = null;
    });

    print('Download-Link: $urlDownload');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 12, 215, 246),
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.5),
        leading: InkWell(
          onTap: () {
            // Navigate to AdHomePage using GetX when image is tapped
            Get.to(() => const AdHomePage());
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/partners.png',
              fit: BoxFit.contain,
              height: 50,
            ),
          ),
        ),
        title: Text(
          'Upload PDF for ${widget.branch} - ${widget.semester} - ${widget.module}',
          style: const TextStyle(
            fontFamily: 'Lobster',
            fontSize: 22,
            color: Color.fromARGB(255, 219, 64, 25),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 12, 215, 246),
                Color.fromARGB(255, 0, 123, 255)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CustomButton(
                  title: 'Select PDF',
                  onTap: selectFile,
                ),
                if (pickedFile != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      'Selected File: ${pickedFile!.name}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'PT_Serif',
                      ),
                    ),
                  ),
                _CustomButton(
                  title: 'Upload PDF',
                  onTap: uploadFile,
                ),
                const SizedBox(height: 20),
                uploadTask != null ? buildUploadStatus(uploadTask!) : Container(),
                _CustomButton(
                  title: 'View Uploaded PDFs',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewPdfPage(
                          selectedCollege: widget.selectedCollege,
                          branch: widget.branch,
                          semester: widget.semester,
                          subject: widget.subject,
                          module: widget.module,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              'Upload: $percentage %',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
}

class _CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _CustomButton({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(118, 12, 215, 246),
            Color.fromARGB(107, 0, 123, 255),
            Color.fromARGB(118, 12, 246, 184)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: const EdgeInsets.all(20.0),
          elevation: 0,
        ),
        onPressed: onTap,
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: 'PT_Serif',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
