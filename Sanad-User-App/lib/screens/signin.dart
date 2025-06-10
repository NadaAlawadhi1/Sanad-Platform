import 'dart:developer';
import 'dart:io';
import 'package:sanad/Widgets/custom_form_field.dart';
import 'package:sanad/generated/l10n.dart';
import 'package:sanad/models/chatUser_model.dart';
import 'package:sanad/services/alert_service.dart';
import 'package:sanad/services/auth_service.dart';
import 'package:sanad/services/database_service.dart';
import 'package:sanad/services/media_service.dart';
import 'package:sanad/services/navigation_service.dart';
import 'package:sanad/services/storage_service.dart';
import 'package:sanad/utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final GetIt _getIt = GetIt.instance;
  late MediaService _mediaService;
  late NavigationService _navigationService;
  late AuthService _authService;
  late StorageService _storageService;
  late DatabaseService _databaseService;
  late AlertService _alertService;
  final GlobalKey<FormState> _signinFormKey = GlobalKey();

  bool _obscurePassword = true;
  bool isLoading = false;
  String? email, password, name;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    _mediaService = _getIt.get<MediaService>();
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
    _storageService = _getIt.get<StorageService>();
    _databaseService = _getIt.get<DatabaseService>();
    _alertService = _getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 20,
      ),
      child: Column(
        children: [
          _header(),
          if (!isLoading) _siginForm(),
          if (!isLoading) _loginAnAccountLink(),
          if (isLoading)
            const Expanded(
                child: Center(
              child: CircularProgressIndicator(),
            ))
        ],
      ),
    ));
  }

  Widget _header() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).letsGetGoingText,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            S.of(context).letsMakeNewAccountText,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: MyColors.skyBlue),
          )
        ],
      ),
    );
  }

  Widget _siginForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.60,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.05,
      ),
      child: Form(
          key: _signinFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _pfpSelectionFiled(),
              CustomFormField(
                height: MediaQuery.of(context).size.height * 0.1,
                hintText: S.of(context).nameHint,
                onSaved: (value) {
                  setState(() {
                    name = value;
                  });
                },
                validationRegEx: NAME_VALIDATION_REGEX, // Your email regex
                obscureText: false, // Email field should not obscure text
              ),
              CustomFormField(
                height: MediaQuery.of(context).size.height * 0.1,
                hintText: S.of(context).emailHint,
                onSaved: (value) {
                  setState(() {
                    email = value;
                  });
                },
                validationRegEx: EMAIL_VALIDATION_REGEX, // Your email regex
                obscureText: false, // Email field should not obscure text
              ),
              CustomFormField(
                height: MediaQuery.of(context).size.height * 0.1,
                hintText: S.of(context).passwordHint,
                onSaved: (value) {
                  setState(() {
                    password = value; // Save password value
                  });
                },
                validationRegEx:
                    PASSWORD_VALIDATION_REGEX, // Your password regex
                obscureText: _obscurePassword, // Use toggle for password
                onToggleVisibility: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword; // Toggle visibility
                  });
                },
              ),
              _siginButton(),
            ],
          )),
    );
  }
  Widget _pfpSelectionFiled() {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaService.getImageFromGallery();
        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.15,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  Widget _siginButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: MaterialButton(
        onPressed: () async {
          if (_signinFormKey.currentState?.validate() ?? false) {
            _signinFormKey.currentState?.save();
            if (email != null && name != null && password != null) {
              setState(() {
                isLoading = true;
              });
              try {
                await _authService.registerUser(
                  email: email!,
                  name: name!,
                  password: password!,
                );
                _navigationService.pushReplacementNamed("/main");
              } catch (e) {
                log(' catch $e');
                _alertService.showToast(
                    text: "Failed to register, Please try again! $e",
                    icon: Icons.error);
              }
              setState(() {
                isLoading = false;
              });
            } else {
              _alertService.showToast(
                text: "Please complete all fields.",
                icon: Icons.error,
              );
            }
          }
        },
        color: MyColors.skyBlue,
        child: Text(
          S.of(context).signInButton,
          style: TextStyle(color: Colors.white), // Adjust text color
        ),
      ),
    );
  }


  Widget _loginAnAccountLink() {
    return Expanded(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          S.of(context).alreadyHaveAccountText,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: Text(
            S.of(context).loginInButton,
            style:
                TextStyle(fontWeight: FontWeight.w800, color: MyColors.skyBlue),
          ),
        ),
      ],
    ));
  }
}
