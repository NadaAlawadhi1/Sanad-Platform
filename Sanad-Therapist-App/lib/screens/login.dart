import 'package:get_it/get_it.dart';
import 'package:sanad_therapists/Widgets/custom_form_field.dart';
import 'package:sanad_therapists/generated/l10n.dart';
import 'package:sanad_therapists/services/alert_service.dart';
// import 'package:sanad/services/auth_service.dart';
// import 'package:sanad/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:sanad_therapists/services/auth_service.dart';
import 'package:sanad_therapists/services/navigation_service.dart';
import 'package:sanad_therapists/utils.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _loginFormKey = GlobalKey();

  late NavigationService _navigationService;
  late AlertService _alertService;
  late AuthService _authService;
  bool _obscurePassword = true; // State for password visibility
  String? email, password;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _navigationService = _getIt.get<NavigationService>();
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
            _loginForm(),
            _creatAnAccountLink(),
          ],
        ),
      ),
    );
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
            S.of(context).hiWelcomeBackText,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            S.of(context).helloDoctorYouHaveBeenMissedText,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: MyColors.skyBlue),
          )
        ],
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.40,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.05,
      ),
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomFormField(
              height: MediaQuery.of(context).size.height * 0.1,
              hintText: S.of(context).emailHint,

              onSaved: (value) {
                setState(() {
                  email = value; // Save email value
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
              validationRegEx: PASSWORD_VALIDATION_REGEX, // Your password regex
              obscureText: _obscurePassword, // Use toggle for password
              onToggleVisibility: () {
                setState(() {
                  _obscurePassword = !_obscurePassword; // Toggle visibility
                });
              },
            ),
            _loginButton(),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: MaterialButton(
        onPressed: () async {
          if (_loginFormKey.currentState?.validate() ?? false) {
            _loginFormKey.currentState?.save();
            bool result = await _authService.login(email!, password!);
            if (result) {
              _navigationService.pushReplacementNamed("/main");
            } else {
              _alertService.showToast(
                  text: "Faild to login, Please try again!", icon: Icons.error);
            }
          }
        },
        color: MyColors.skyBlue,
        child: Text(
          S.of(context).loginInButton,
          style: TextStyle(color: Colors.white), // Adjust text color
        ),
      ),
    );
  }

  Widget _creatAnAccountLink() {
    return Expanded(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          S.of(context).dontHaveAccountText,
        ),
        GestureDetector(
          onTap: () {
                _navigationService.pushNamed('/join'); 

          },
          child: Text(
            S.of(context).applyButton,
            style:
                TextStyle(fontWeight: FontWeight.w800, color: MyColors.skyBlue),
          ),
        ),
      ],
    ));
  }
}
