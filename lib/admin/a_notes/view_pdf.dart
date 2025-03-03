import 'package:college_app/admin/a_notes/pdf_viewer_screen.dart';
import 'package:college_app/admin/ad_home.dart';
// import 'package:college_app/widgets/bottom_navigation_foradmin.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ViewPdfPage extends StatefulWidget {
  final String selectedCollege;
  final String branch;
  final String semester;
  final String subject;
  final String module;

  const ViewPdfPage({
    super.key,
    required this.selectedCollege,
    required this.branch,
    required this.semester,
    required this.subject,
    required this.module,
  });

  @override
  State<ViewPdfPage> createState() => _ViewPdfPageState();
}

class _ViewPdfPageState extends State<ViewPdfPage> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> pdfData = [];
  bool isLoading = true; // Loading state
  bool hasData = false; // Check if data exists

  @override
  void initState() {
    super.initState();
    getFilteredPdfs();
  }

  Future<void> getFilteredPdfs() async {
    try {
      // Set loading to true
      final querySnapshot = await _firebaseFirestore
          .collection("notes")
          .where("college", isEqualTo: widget.selectedCollege)
          .where("branch", isEqualTo: widget.branch)
          .where("semester", isEqualTo: widget.semester)
          .where("subject", isEqualTo: widget.subject)
          .where("module", isEqualTo: widget.module)
          .get();

      setState(() {
        pdfData = querySnapshot.docs.map((e) => e.data() as Map<String, dynamic>).toList();
        hasData = pdfData.isNotEmpty; // Check if data exists
      });
    } catch (e) {
      print("Error fetching PDFs: $e");
    } finally {
      // Delay for 3 seconds before updating the loading state
      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        isLoading = false; // Update loading state
      });
    }
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
          'Files of ${widget.branch} - ${widget.semester} - ${widget.module}',
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
                Color.fromARGB(255, 0, 123, 255),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator()) // Show loading indicator
              : hasData // Check if data exists
                  ? GridView.builder(
                      itemCount: pdfData.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 0.75, // Adjust aspect ratio for better design
                      ),
                      itemBuilder: (context, index) {
                        return _PdfItem(
                          name: pdfData[index]['name'],
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PdfViewerScreen(
                                pdfUrl: pdfData[index]['url'],
                                pdfName: pdfData[index]['name'], // Pass the PDF name
                              ),
                            ));
                          },
                        );
                      },
                    )
                  : const Center(child: Text("No PDFs found for the selected criteria.")), // Show message if no PDFs
        ),
      ),
    );
  }
}

class _PdfItem extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const _PdfItem({required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(118, 12, 215, 246),
              Color.fromARGB(107, 0, 123, 255),
              Color.fromARGB(118, 12, 246, 184),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/images/pdf.png',
              height: 120,
              width: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PT_Serif',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
