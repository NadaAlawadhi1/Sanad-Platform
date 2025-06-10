import 'package:flutter/material.dart';
import 'package:sanad_dashboared/models/DoctorUser_Model.dart';
import 'package:sanad_dashboared/services/database_service.dart';

class EditTherapistScreen extends StatefulWidget {
  final Doctor doctor;

  EditTherapistScreen({required this.doctor});

  @override
  _EditTherapistScreenState createState() => _EditTherapistScreenState();
}

class _EditTherapistScreenState extends State<EditTherapistScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _aboutController;
  late TextEditingController _specialistController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.doctor.name);
    _emailController = TextEditingController(text: widget.doctor.email);
    _aboutController = TextEditingController(text: widget.doctor.about);
    _specialistController = TextEditingController(text: widget.doctor.specialist);
    _priceController = TextEditingController(text: widget.doctor.price);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _aboutController.dispose();
    _specialistController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    DatabaseService.updateDoctorInfo(
        doctorId: widget.doctor.id,
      name: _nameController.text,
      email: _emailController.text,
      bio:  _aboutController.text,
      yearOfExperience: widget.doctor.yearOfExperience, // Retain year of experience,
      specialist: _specialistController.text,
      price:  _priceController.text,

    );
    Navigator.pop(context); // Return the updated doctor
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Therapist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _aboutController,
              decoration: InputDecoration(labelText: 'About'),
            ),
            TextField(
              controller: _specialistController,
              decoration: InputDecoration(labelText: 'Specialization'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
