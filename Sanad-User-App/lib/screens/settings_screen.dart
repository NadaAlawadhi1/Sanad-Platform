import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sanad/generated/l10n.dart';
import 'package:sanad/main.dart';
import 'package:sanad/services/database_service.dart';
import 'package:sanad/services/alert_service.dart';
import 'package:sanad/services/auth_service.dart';
import 'package:sanad/services/navigation_service.dart';
import 'package:sanad/utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _image;
  final GetIt _getIt = GetIt.instance;

  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;

  @override
  void initState() {
    super.initState();
    // Initialize services
    _authService = GetIt.instance.get<AuthService>();
    _navigationService = GetIt.instance.get<NavigationService>();
    _alertService = GetIt.instance.get<AlertService>();
  }

  // bottom Sheet to Pick image
  void _showBottomSheet() {
    showModalBottomSheet(
        backgroundColor: MyColors.lightCornflowerBlue,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(2))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            children: [
              //pick profile picture label
              Text(S.of(context).pickUpText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  )),

              //for adding some space
              SizedBox(height: 20),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                      ),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          //log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          DatabaseService.updateProfilePicture(File(_image!));
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: const Icon(Icons.image_outlined)),
                  //take picture from camera button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                      ),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          //  log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          DatabaseService.updateProfilePicture(File(_image!));
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: const Icon(Icons.camera)),
                ],
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    log('image : ${DatabaseService.me.image}');
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settingsText),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: MyColors.skyBlue), // Back arrow icon
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture Placeholder
            Center(
              child: InkWell(
                onTap: () => _showBottomSheet(),
                child: CircleAvatar(
                  radius: 50, // Adjust radius as needed
                  backgroundColor: MyColors
                      .lightCornflowerBlue, // Optional: background color
                  child: ClipOval(
                    child: DatabaseService.me.image != null &&
                            DatabaseService.me.image.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: DatabaseService.me.image, // Image URL
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(
                              color: MyColors.skyBlue,
                            ), // Loading indicator
                            errorWidget: (context, url, error) => const Icon(
                              Icons.person,
                              size: 70,
                              color: MyColors.white,
                            ), // Fallback icon if loading fails
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  imageProvider, // Set background image when loaded
                            ),
                          )
                        : Icon(Icons.person,
                            size:
                                50), // Show icon if image URL is null or empty
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.account_circle,
                  color: MyColors.skyBlue), // Sky blue icon
              title: Text(S.of(context).yourAccount),
              onTap: () {
                // Handle navigation to Your account
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          YourAccountScreen()), // Example navigation
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.privacy_tip,
                  color: MyColors.skyBlue), // Sky blue icon
              title: Text(S.of(context).privacyPolicyButton),
              onTap: () {
                // Handle navigation to privacy policy
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PrivacyPolicyScreen()), // Example navigation
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.info,
                  color: MyColors.skyBlue), // Sky blue icon
              title: Text(S.of(context).compliant),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CompliantScreen()), // Example navigation
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.language,
                  color: MyColors.skyBlue), // Sky blue icon
              title: Text(S.of(context).languagesButton),
              onTap: () {
                Provider.of<LanguageProvider>(context, listen: false)
                    .toggleLanguage();
              },
            ),
            Divider(),
            const Spacer(),
            TextButton(
              onPressed: () async {
                bool result = await _authService.logout();
                if (result) {
                  _alertService.showToast(
                      text: "Successfully logged out", icon: Icons.check);
                  _navigationService.pushReplacementNamed("/login");
                }
              },
              child: Center(
                child: Text(
                  S.of(context).logOutButton,
                  style: TextStyle(color: MyColors.skyBlue), // Set text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy screens for navigation

////////////////////////////////////////////////////////////////////////////////////

class YourAccountScreen extends StatefulWidget {
  @override
  _YourAccountScreenState createState() => _YourAccountScreenState();
}

class _YourAccountScreenState extends State<YourAccountScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() {
    final user = DatabaseService.me;
    if (user != null) {
      emailController.text = user.email ?? '';
      nameController.text = user.name ?? '';
    }
  }

  Future<void> _updateProfileInfo() async {
    try {
      // Update profile information TODO:: put this function on DatabaseService
      await DatabaseService.firestore
          .collection('users')
          .doc(DatabaseService.user.uid)
          .update({
        'name': nameController.text,
      });

      // Refresh local user data
      setState(() {
        DatabaseService.me = DatabaseService.me.copyWith(
          name: nameController.text,
          email: emailController.text,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  Future<void> _updatePassword() async {
    if (newPasswordController.text == confirmPasswordController.text) {
      try {
        await DatabaseService.auth.currentUser!
            .updatePassword(newPasswordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating password: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).yourAccount),
        backgroundColor: MyColors.lightCornflowerBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: DatabaseService.me.image != null &&
                        DatabaseService.me.image.isNotEmpty
                    ? NetworkImage(DatabaseService.me.image)
                    : AssetImage('assets/person_icon.png') as ImageProvider,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.person,
                    color: MyColors.skyBlue,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    S.of(context).informations,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 45,
                  ),
                  Text(
                    emailController.text,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 80),
                child: Divider(),
              ),
              SizedBox(height: 10),
              _buildTextField(nameController, S.of(context).nameHint, false),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  TextButton(
                    onPressed: _updateProfileInfo,
                    child: Text(S.of(context).updateProfile,
                        style: TextStyle(color: MyColors.skyBlue)),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.privacy_tip_rounded,
                    color: MyColors.skyBlue,
                  ),
                  SizedBox(width: 5),
                  Text(
                    S.of(context).changePassword,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildTextField(currentPasswordController,
                  S.of(context).currentPassword, true),
              SizedBox(height: 10),
              _buildTextField(
                  newPasswordController, S.of(context).newPassword, true),
              SizedBox(height: 10),
              _buildTextField(confirmPasswordController,
                  S.of(context).confirmPassword, true),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  TextButton(
                    onPressed: _updatePassword,
                    child: Text(S.of(context).updatePassword,
                        style: TextStyle(color: MyColors.skyBlue)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 80),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(fontSize: 12),
          border: UnderlineInputBorder(),
        ),
      ),
    );
  }
}
/////////////////////////////////////////////////////////////////

class CompliantScreen extends StatefulWidget {
  @override
  _CompliantScreenState createState() => _CompliantScreenState();
}

class _CompliantScreenState extends State<CompliantScreen> {
  String? complaintType;
  final TextEditingController _complaintController = TextEditingController();
  bool _isLoading = false;

  void _submitComplaint() {
    if (complaintType == null || _complaintController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Please select a complaint type and enter your complaint.')),
      );
      return;
    }

    _showConfirmationDialog();
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).confirmationDialogTitle),
          content: Text(S.of(context).confirmationDialogContent),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).cancelButtonText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(S.of(context).submitButtonText),
              onPressed: () {
                Navigator.of(context).pop();
                _handleSubmission();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleSubmission() {
    setState(() {
      _isLoading = true;
    });
    DatabaseService.addComplaint(
            complaintType.toString(), _complaintController.text)
        .then(
      (value) {
        // Reset fields
        setState(() {
          complaintType = null;
          _complaintController.clear();
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Complaint submitted successfully!')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).compliant),
        backgroundColor: MyColors.lightCornflowerBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              S.of(context).feedbackMessage,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: complaintType,
              decoration: InputDecoration(
                labelText: S.of(context).selectComplaintTypeLabel,
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: 'Technical',
                  child: Text(S.of(context).technicalChoice),
                ),
                DropdownMenuItem(
                  value: 'Administrative',
                  child: Text(S.of(context).administrativeChoice),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  complaintType = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _complaintController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: S.of(context).writeComplaintLabel,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: _isLoading ? null : _submitComplaint,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      S.of(context).submitComplaintButton,
                      style: TextStyle(
                        color: MyColors.skyBlue,
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).privacyPolicyButton),
        backgroundColor: MyColors.lightCornflowerBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).privacyPolicy,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              S.of(context).effectiveDate,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 20),
            Text(
              S.of(context).introduction,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 10),
            Text(
              S.of(context).privacyImportance,
            ),
            SizedBox(height: 20),
            Text(
              S.of(context).informationWeCollect,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 10),
            Text(
              S.of(context).typesOfInformation,
            ),
            SizedBox(height: 20),
            Text(
              S.of(context).howWeUseInformation,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 10),
            Text(
              S.of(context).useInformationExplanation,
            ),
            SizedBox(height: 20),
            Text(
              S.of(context).dataSecurity,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 10),
            Text(
              S.of(context).dataSecurityExplanation,
            ),
            SizedBox(height: 20),
            Text(
              S.of(context).changesToPrivacyPolicy,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 10),
            Text(
              S.of(context).privacyPolicyUpdates,
            ),
            SizedBox(height: 20),
            Text(
              S.of(context).contactUs,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 10),
            Text(
              S.of(context).contactInfo,
            ),
          ],
        ),
      ),
    );
  }
}
