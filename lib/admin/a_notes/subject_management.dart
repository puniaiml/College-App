import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/admin/a_notes/select_module.dart';
import 'package:college_app/admin/ad_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:college_app/widgets/bottom_navigation_foradmin.dart';

class SubjectManagementPage extends StatefulWidget {
  final String selectedCollege;
  final String branch;
  final String semester;

  const SubjectManagementPage({
    super.key,
    required this.selectedCollege,
    required this.branch,
    required this.semester,
  });

  @override
  _SubjectManagementPageState createState() => _SubjectManagementPageState();
}

class _SubjectManagementPageState extends State<SubjectManagementPage> {
  final TextEditingController _subjectController = TextEditingController();
  List<String> subjects = [];

  @override
  void initState() {
    super.initState();
    fetchSubjects();
  }

  Future<void> fetchSubjects() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('subjects')
        .doc('${widget.selectedCollege}_${widget.branch}_${widget.semester}')
        .get();

    if (snapshot.exists) {
      final data = snapshot.data();
      setState(() {
        subjects = List<String>.from(data?['subjects'] ?? []);
      });
    }
  }

  Future<void> addSubject() async {
    if (_subjectController.text.trim().isEmpty) return;

    final newSubject = _subjectController.text.trim();
    setState(() {
      subjects.add(newSubject);
      _subjectController.clear();
    });

    await FirebaseFirestore.instance
        .collection('subjects')
        .doc('${widget.selectedCollege}_${widget.branch}_${widget.semester}')
        .set({'subjects': subjects}, SetOptions(merge: true));
  }

  Future<void> deleteSubject(String subject) async {
    setState(() {
      subjects.remove(subject);
    });

    await FirebaseFirestore.instance
        .collection('subjects')
        .doc('${widget.selectedCollege}_${widget.branch}_${widget.semester}')
        .set({'subjects': subjects}, SetOptions(merge: true));
  }

  void navigateToModulesPage(String subject) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChapterModulePage(
          selectedCollege: widget.selectedCollege,
          branch: widget.branch,
          semester: widget.semester,
          subject: subject,
        ),
      ),
    );
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
            // Navigate to BottomNavigationadminPage when image is tapped
            Get.to(() => const AdHomePage());
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/partners.png', // Your partners image path
              fit: BoxFit.contain,
              height: 50,
            ),
          ),
        ),
        title: const Text(
          'Manage Subjects',
          style: TextStyle(
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
                Color.fromARGB(255, 0, 123, 255),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 60.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 0, 250, 63),
                    Color.fromARGB(255, 0, 150, 100),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 8.0,
                  ),
                ],
                border: Border.all(
                  color: const Color.fromARGB(255, 0, 100, 50),
                  width: 2.0,
                ),
              ),
              child: const Text(
                'Subject List',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      color: Colors.black54,
                      blurRadius: 4.0,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: 'Add New Subject',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                prefixIcon: const Icon(Icons.add),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addSubject,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                'Add Subject',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return InkWell(
                    onTap: () => navigateToModulesPage(subject),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 4),
                            blurRadius: 8.0,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(15.0),
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: [
                          Text(
                            subject,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteSubject(subject),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
