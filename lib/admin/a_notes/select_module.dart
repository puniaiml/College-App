import 'package:college_app/admin/a_notes/upload_pdf.dart';
import 'package:college_app/admin/ad_home.dart';
// import 'package:college_app/widgets/bottom_navigation_foradmin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChapterModulePage extends StatelessWidget {
  final String selectedCollege;
  final String branch;
  final String semester;
  final String subject;

  const ChapterModulePage({super.key, required this.selectedCollege, required this.branch, required this.semester, required this.subject });

  @override
  Widget build(BuildContext context) {
    List<String> modules = getModules(selectedCollege, branch, semester, subject);

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
          'Select Module for $selectedCollege - $branch - $semester - $subject',
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
          child: ListView.builder(
            itemCount: modules.length,
            itemBuilder: (context, index) {
              return _ModuleButton(
                title: modules[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UploadPdfPage(
                        selectedCollege: selectedCollege,
                        branch: branch,
                        semester: semester,
                        subject: subject,
                        module: modules[index], // Pass the correct module
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // Function to get the list of modules based on branch and semester
  List<String> getModules(String selectedCollege, String branch, String semester, String subject) {
    // Fetch modules based on branch and semester
    // Replace with actual data fetching logic
    return ['Module 1', 'Module 2', 'Module 3', 'Module 4', 'Module 5'];
  }
}

class _ModuleButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _ModuleButton({required this.title, required this.onTap});

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
