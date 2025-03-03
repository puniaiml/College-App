// ignore_for_file: unused_field

import 'package:college_app/admin/a_notes/ad_branch.dart'; // Import your SelectBranchAdmin page
import 'package:college_app/admin/ad_home.dart';
// import 'package:college_app/widgets/bottom_navigation_foradmin.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:get/get.dart';

class CollegeSelectionPage extends StatefulWidget {
  const CollegeSelectionPage({super.key});

  @override
  _CollegeSelectionPageState createState() => _CollegeSelectionPageState();
}

class _CollegeSelectionPageState extends State<CollegeSelectionPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot> _colleges = [];
  List<QueryDocumentSnapshot> _filteredColleges = []; // List for filtered colleges
  String? _selectedCollege;
  String _searchQuery = ''; // Search query for filtering

  @override
  void initState() {
    super.initState();
    _fetchColleges(); // Fetch colleges from Firestore
  }

  Future<void> _fetchColleges() async {
    final snapshot = await _firestore.collection('colleges').get();
    setState(() {
      _colleges = snapshot.docs; // Store the fetched colleges in the state
      _filteredColleges = _colleges; // Initialize filtered list
    });
  }

  Future<void> _navigateToBranchSelection() async {
    if (_selectedCollege != null) {
      // Adding a short delay for a smoother transition
      await Future.delayed(const Duration(milliseconds: 200));
      Get.to(() => SelectBranchAdmin(selectedCollege: _selectedCollege!));
    } else {
      // Show a message if no college is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a college')),
      );
    }
  }

  void _filterColleges(String query) {
    setState(() {
      _searchQuery = query;
      _filteredColleges = _colleges.where((college) {
        final collegeName = (college.data() as Map<String, dynamic>)['name'].toString().toLowerCase();
        return collegeName.contains(query.toLowerCase()); // Filter colleges by name
      }).toList();
    });
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
          'Select College',
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: SingleChildScrollView( // Enable scrolling
            child: Column(
              children: [
                const SizedBox(height: 20),
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
                    'Available Colleges',
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

                // Search TextField
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Search Colleges',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: _filterColleges, // Filter colleges based on user input
                ),
                const SizedBox(height: 20),

                // List of filtered colleges
                ListView.builder(
                  shrinkWrap: true, // Make the ListView shrink to fit its children
                  physics: const NeverScrollableScrollPhysics(), // Disable scrolling in the ListView
                  itemCount: _filteredColleges.length,
                  itemBuilder: (context, index) {
                    final college = _filteredColleges[index].data() as Map<String, dynamic>;
                    return _CollegeItem(
                      title: college['name'],
                      isSelected: _selectedCollege == college['name'],
                      onTap: () {
                        setState(() {
                          _selectedCollege = college['name']; // Update selected college
                        });
                      },
                    );
                  },
                ),

                // Animated Button for navigation
                Container(
                  width: double.infinity, // Make the button full width
                  margin: const EdgeInsets.only(top: 50), // Margin for spacing
                  child: AnimatedButton(
                    onPress: _navigateToBranchSelection,
                    text: 'Next',
                    isReverse: true, // Set to false for forward animation
                    selectedTextColor: Colors.black,
                    transitionType: TransitionType.LEFT_TO_RIGHT,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.blueAccent,
                    borderColor: const Color.fromARGB(255, 0, 100, 50),
                    borderRadius: 30,
                    borderWidth: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CollegeItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _CollegeItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[100] : Colors.white, // Change color if selected
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
            Radio<String>(
              value: title,
              groupValue: isSelected ? title : null,
              onChanged: (_) {
                onTap(); // Trigger onTap when radio is selected
              },
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
