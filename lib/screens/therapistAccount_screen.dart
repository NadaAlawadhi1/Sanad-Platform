import 'package:flutter/material.dart';
import 'package:sanad_dashboared/models/DoctorUser_Model.dart';
import 'package:sanad_dashboared/screens/EditTherapistScreen.dart';
import 'package:sanad_dashboared/services/database_service.dart';
import 'package:sanad_dashboared/utils.dart';

class TherapistaccountScreen extends StatefulWidget {
  const TherapistaccountScreen({super.key});

  @override
  State<TherapistaccountScreen> createState() => _TherapistaccountScreenState();
}

class _TherapistaccountScreenState extends State<TherapistaccountScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = ''; // Variable to store the current search term
  // Function to truncate text based on word limit
  String truncateWithEllipsis(String text, int wordLimit) {
    List<String> words = text.split(' ');
    if (words.length <= wordLimit) {
      return text; // Return the full text if within the limit
    }
    return words.take(wordLimit).join(' ') +
        '...'; // Join the limited words and add ellipsis
  }

  void _editTherapist(Doctor doctor) {
    // Navigate to the edit screen, passing the doctor object
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTherapistScreen(doctor: doctor),
      ),
    );
  }

  void _deleteTherapist(String therapistId) async {
    String? errorMessage = await DatabaseService.deleteTherapist(therapistId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: StreamBuilder<int>(
                  stream:
                      DatabaseService.getCollectionLengthStream('therapists'),
                  builder: (context, snapshot) {
                    final count = snapshot.data ?? 0;
                    return _buildCard(
                      icon: Icons.pie_chart,
                      title: "# of Therapists",
                      count: "$count Therapists",
                      color: Colors.pink,
                    );
                  },
                ),
              ),
              Expanded(
                child: StreamBuilder<int>(
                  stream: DatabaseService.getCollectionLengthStream('users'),
                  builder: (context, snapshot) {
                    final count = snapshot.data ?? 0;
                    return _buildCard(
                      icon: Icons.people_alt,
                      title: "# of Users",
                      count: "$count Users",
                      color: Colors.purple,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Search Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            SizedBox(
              width: 300.0,
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Search...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black26,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchTerm = value.toLowerCase(); // Update search term
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 50,
          decoration: const BoxDecoration(
            color: MyColors.skyBlue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Manage Therapist",
                  style: TextStyle(
                      color: MyColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    _addTherapist(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.white,
                    foregroundColor: MyColors.skyBlue,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Add New Therapist',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          color: MyColors.white,
          height: 500,
          child: StreamBuilder<List<Doctor>>(
            stream: DatabaseService.getDoctors(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final doctors = snapshot.data;

              if (doctors == null || doctors.isEmpty) {
                return Center(child: Text('No therapists available.'));
              }

              // Filter doctors based on search term
              final filteredDoctors = doctors
                  .where((doctor) =>
                      doctor.name.toLowerCase().contains(_searchTerm) ||
                      doctor.specialist.toLowerCase().contains(_searchTerm) ||
                      doctor.about.toLowerCase().contains(_searchTerm))
                  .toList();

              if (filteredDoctors.isEmpty) {
                return Center(child: Text('No results found.'));
              }

              return DataTable(
                headingRowColor: MaterialStateProperty.resolveWith(
                  (states) => MyColors.lightgray,
                ),
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Experience')),
                  DataColumn(label: Text('Subspecialties')),
                  DataColumn(label: Text('Bio')),
                  DataColumn(label: Text('Session')),
                  DataColumn(label: Text('Actions')), // Actions column
                ],
                rows: filteredDoctors.map((doctor) {
                  return DataRow(cells: [
                    DataCell(Text(doctor.name.split(' ').first)),
                    DataCell(Text('${doctor.yearOfExperience} years')),
                    DataCell(Text(doctor.specialist)),
                    DataCell(Text(truncateWithEllipsis(doctor.about, 2))),
                    DataCell(Text(truncateWithEllipsis(doctor.price, 2))),
                    DataCell(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: MyColors.skyBlue),
                            onPressed: () => _editTherapist(doctor),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: MyColors.skyBlue),
                            onPressed: () => _deleteTherapist(doctor.id),
                          ),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////
  void _addTherapist(BuildContext context) {
    final TextEditingController _firstNameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _experienceController = TextEditingController();
    final TextEditingController _languagesController = TextEditingController();
    final TextEditingController _bioController = TextEditingController();
    final TextEditingController _sessionController = TextEditingController();

    List<String> _selectedSubspecialists = [];

    final List<String> _subspecialists = [
      'Doctor',
      'Specialist ',
    ];

    void _selectSubspecialists() async {
      final List<String>? results = await showDialog<List<String>>(
        context: context,
        builder: (BuildContext context) {
          List<String> selected = List.from(_selectedSubspecialists);
          return AlertDialog(
            title: Text('Select Subspecialists'),
            content: SingleChildScrollView(
              child: ListBody(
                children: _subspecialists.map((String subspecialist) {
                  return CheckboxListTile(
                    title: Text(subspecialist),
                    value: selected
                        .contains(subspecialist), // The state of the checkbox
                    onChanged: (bool? value) {
                      setState(() {
                        // Update the list of selected subspecialists based on the checkbox value
                        if (value == true) {
                          selected.add(subspecialist); // Add if checked
                        } else {
                          selected.remove(subspecialist); // Remove if unchecked
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                child: Text('Done'),
                onPressed: () {
                  Navigator.of(context).pop(selected);
                },
              ),
            ],
          );
        },
      );

      if (results != null) {
        _selectedSubspecialists = results;
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: MyColors.white,
          title: Text(
            'Account Form',
            style: TextStyle(color: MyColors.skyBlue),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(hintText: "Enter First Name"),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(hintText: "Enter Email"),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(hintText: "Enter Password"),
                  obscureText: true, // This masks the input
                ),
                TextField(
                  controller: _experienceController,
                  decoration:
                      InputDecoration(hintText: "Enter Experience (years)"),
                  keyboardType:
                      TextInputType.number, // Ensure the input is numeric
                ),
                TextField(
                  controller: _languagesController,
                  decoration: InputDecoration(hintText: "Enter Languages"),
                ),
                TextField(
                  controller: _bioController,
                  decoration: InputDecoration(
                    hintText: "Enter Bio",
                  ),
                  maxLines: 3, // Allow multiple lines
                ),
                TextField(
                  controller: _sessionController,
                  decoration: InputDecoration(
                      hintText: "Enter Session (e.g., price / time )"),
                  maxLines: 1, // Single line for session details
                ),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: _selectSubspecialists,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: MyColors.lightCornflowerBlue),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      _selectedSubspecialists.isEmpty
                          ? "Select Specialist"
                          : _selectedSubspecialists.join(', '),
                      style: TextStyle(color: MyColors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: MyColors.skyBlue,
              ),
              onPressed: () async {
                // Validate input before creating profile
                String firstName = _firstNameController.text.trim();
                String email = _emailController.text.trim();
                String password = _passwordController.text.trim();
                String bio = _bioController.text.trim();
                String session = _sessionController.text.trim();

                if (firstName.isEmpty || email.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Please fill in all required fields')),
                  );
                  return;
                }

// Email validation
                if (!EMAIL_VALIDATION_REGEX.hasMatch(email)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a valid email address'),
                    ),
                  );
                  return;
                }

                // Parse experience safely
                int experience = 0;
                try {
                  experience = int.parse(_experienceController.text);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Please enter a valid number for experience')),
                  );
                  return;
                }

                // Parse session price safely
                double price = 0.0;
                try {
                  price = double.parse(session);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid price')),
                  );
                  return;
                }

                // Call the function to create the doctor profile
                String? errorMessage =
                    await DatabaseService.createDoctorAccount(
                  name: firstName,
                  email: email,
                  yearOfExperience: experience,
                  specialist: _selectedSubspecialists.join(', '),
                  price: price.toString(),
                  password: password,
                  bio: bio,
                );

                if (errorMessage != null) {
                  // Show snackbar with the error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage)),
                  );
                } else {
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Account created successfully')),
                  );
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: Text('Create'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: MyColors.skyBlue,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

////////////////////////////////////////////////
////////////////////////////////////////////////
////////////////////////////////////////////////

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String count,
    required Color color,
  }) {
    return Flexible(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 26.0, color: color),
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Text(
                count,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 20,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
