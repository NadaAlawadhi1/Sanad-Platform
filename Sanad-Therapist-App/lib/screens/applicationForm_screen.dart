import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:sanad_therapists/generated/l10n.dart';
import 'package:sanad_therapists/services/database_service.dart';
import 'package:sanad_therapists/services/navigation_service.dart';
import 'package:sanad_therapists/utils.dart';

class ApplicationForm extends StatefulWidget {
  @override
  _ApplicationFormState createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<ApplicationForm> {
  late NavigationService _navigationService;

  @override
  void initState() {
    super.initState();
    _navigationService = GetIt.instance.get<NavigationService>();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phoneNumber;
  String? _gender;
  String? _city;
  String? _registrationStatus;
  String? _experience;
  String? _filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: const BoxDecoration(
        color: MyColors.lightCornflowerBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => _navigationService.goBack(),
            icon: Icon(Icons.arrow_back),
            color: MyColors.skyBlue,
            iconSize: 30,
          ),
          Image.asset(
            "assets/images/logo1.PNG",
            width: 120,
            height: 90,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilePicker(),
            const SizedBox(height: 20),
            _buildTextField(S.of(context).firstNameHint,
                'Please enter your first name', (value) => _firstName = value),
            const SizedBox(height: 16),
            _buildTextField(S.of(context).lastNameHint,
                'Please enter your last name', (value) => _lastName = value),
            const SizedBox(height: 16),
            _buildTextField(S.of(context).emailHint,
                'Please enter a valid email', (value) => _email = value,
                isEmail: true),
            const SizedBox(height: 16),
            _buildTextField(
                S.of(context).phoneNumHint,
                'Please enter a valid phone number',
                (value) => _phoneNumber = value,
                isPhone: true),
            const SizedBox(height: 16),
            _buildDropdown(
                S.of(context).genderHint,
                [S.of(context).femaleOption, S.of(context).maleOption],
                (value) => _gender = value,
                'Please select your gender'),
            const SizedBox(height: 16),
            _buildDropdown(
                S.of(context).cityHint,
                [
                  S.of(context).city1,
                  S.of(context).city2,
                  S.of(context).city3,
                  S.of(context).city4,
                  S.of(context).city5,
                  S.of(context).city6,
                  S.of(context).city7,
                  S.of(context).city8,
                  S.of(context).city9,
                  S.of(context).city10,
                  S.of(context).city11,
                  S.of(context).city12,
                  S.of(context).city13,
                  S.of(context).city14,
                ],
                (value) => _city = value,
                'Please select your city'),
            const SizedBox(height: 16),
            _buildTextField(
                S.of(context).experienceHint,
                'Please enter your years of experience',
                (value) => _experience = value,
                isNumber: true),
            const SizedBox(height: 16),
            _buildDropdown(
                S.of(context).registeredAsHint,
                [S.of(context).doctorOption, S.of(context).specialistHint],
                (value) => _registrationStatus = value,
                'Please select your registration status'),
            const SizedBox(height: 20),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePicker() {
    return GestureDetector(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowedExtensions: ['pdf'],
          type: FileType.custom,
        );
        if (result != null) {
          setState(() {
            _filePath = result.files.single.path;
          });
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('File selected: $_filePath')));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('No file selected')));
        }
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: MyColors.skyBlue,
        ),
        child: Center(
          child: Text(
            _filePath == null
                ? S.of(context).dragText
                : 'File Selected: $_filePath',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String errorMessage, ValueChanged<String> onChanged,
      {bool isEmail = false, bool isNumber = false, bool isPhone = false}) {
    return TextFormField(
      decoration:
          InputDecoration(labelText: label, border: OutlineInputBorder()),
      validator: (value) {
        if (value == null || value.isEmpty) return errorMessage;
        if (isEmail && !EMAIL_VALIDATION_REGEX.hasMatch(value))
          return 'Please enter a valid email';
        if (isPhone && !PHONE_VALIDATION_REGEX.hasMatch(value))
          return 'Phone number must be exactly 9 digits';
        if (isNumber && int.tryParse(value) == null)
          return 'Please enter a valid number';
        return null;
      },
      keyboardType:
          isPhone || isNumber ? TextInputType.number : TextInputType.text,
      onChanged: onChanged,
    );
  }

  Widget _buildDropdown<T>(String label, List<T> items,
      ValueChanged<T?> onChanged, String errorMessage) {
    return DropdownButtonFormField<T>(
      decoration:
          InputDecoration(labelText: label, border: OutlineInputBorder()),
      items: items
          .map((value) =>
              DropdownMenuItem(value: value, child: Text(value.toString())))
          .toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? errorMessage : null,
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            try {
              // Show a loading indicator if needed
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Uploading file, please wait...')));

              String? cvPath;
              if (_filePath != null) {
                // Upload the file to Firebase Storage and get the download URL
                cvPath = await DatabaseService.uploadFileToCVFolder(_filePath!);
              }

              // Submit data with the CV path
              await DatabaseService.addApplication(
                fullName: '$_firstName $_lastName',
                email: _email!,
                phoneNumber: _phoneNumber!,
                gender: _gender!,
                city: _city!,
                registrationStatus: _registrationStatus!,
                experience: int.parse(_experience!),
                cvPath: cvPath, // Pass the CV download URL
              );

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Application submitted successfully')));
            } catch (e) {
              // Handle errors gracefully
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Error: $e')));
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.skyBlue,
          foregroundColor: MyColors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        ),
        child: const Text('Submit'),
      ),
    );
  }
}
