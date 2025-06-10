// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Log in`
  String get loginInButton {
    return Intl.message(
      'Log in',
      name: 'loginInButton',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get nameHint {
    return Intl.message(
      'Name',
      name: 'nameHint',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordHint {
    return Intl.message(
      'Password',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? `
  String get dontHaveAccountText {
    return Intl.message(
      'Don\'t have an account? ',
      name: 'dontHaveAccountText',
      desc: '',
      args: [],
    );
  }

  /// `Hi, Welcome Back`
  String get hiWelcomeBackText {
    return Intl.message(
      'Hi, Welcome Back',
      name: 'hiWelcomeBackText',
      desc: '',
      args: [],
    );
  }

  /// `Hello Doctor, you've been missed`
  String get helloDoctorYouHaveBeenMissedText {
    return Intl.message(
      'Hello Doctor, you\'ve been missed',
      name: 'helloDoctorYouHaveBeenMissedText',
      desc: '',
      args: [],
    );
  }

  /// `We make it easier for you to deliver quality mental health care.`
  String get joinTherapistMainText {
    return Intl.message(
      'We make it easier for you to deliver quality mental health care.',
      name: 'joinTherapistMainText',
      desc: '',
      args: [],
    );
  }

  /// `Apply Now`
  String get applyButton {
    return Intl.message(
      'Apply Now',
      name: 'applyButton',
      desc: '',
      args: [],
    );
  }

  /// `Requirements for joining to Sanad therapists`
  String get requirementsTitle {
    return Intl.message(
      'Requirements for joining to Sanad therapists',
      name: 'requirementsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Valid classification from Yemeni Ministry of Health`
  String get requirements1 {
    return Intl.message(
      'Valid classification from Yemeni Ministry of Health',
      name: 'requirements1',
      desc: '',
      args: [],
    );
  }

  /// `Bachelor/'s degree in psychology, psychiatry medicine or family medicine`
  String get requirements2 {
    return Intl.message(
      'Bachelor/\'s degree in psychology, psychiatry medicine or family medicine',
      name: 'requirements2',
      desc: '',
      args: [],
    );
  }

  /// `Continuous clinical experience, two or more years in presenting psychological sessions`
  String get requirements3 {
    return Intl.message(
      'Continuous clinical experience, two or more years in presenting psychological sessions',
      name: 'requirements3',
      desc: '',
      args: [],
    );
  }

  /// `Autofill Application:`
  String get autoFillText {
    return Intl.message(
      'Autofill Application:',
      name: 'autoFillText',
      desc: '',
      args: [],
    );
  }

  /// ` Upload your resume in seconds with the autofill option.`
  String get uploadText {
    return Intl.message(
      ' Upload your resume in seconds with the autofill option.',
      name: 'uploadText',
      desc: '',
      args: [],
    );
  }

  /// `Drag here or click to upload the PDF CV`
  String get dragText {
    return Intl.message(
      'Drag here or click to upload the PDF CV',
      name: 'dragText',
      desc: '',
      args: [],
    );
  }

  /// `Personal Information`
  String get personalInfoText {
    return Intl.message(
      'Personal Information',
      name: 'personalInfoText',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstNameHint {
    return Intl.message(
      'First Name',
      name: 'firstNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastNameHint {
    return Intl.message(
      'Last Name',
      name: 'lastNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get emailHint {
    return Intl.message(
      'Email',
      name: 'emailHint',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumHint {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumHint',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get genderHint {
    return Intl.message(
      'Gender',
      name: 'genderHint',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get femaleOption {
    return Intl.message(
      'Female',
      name: 'femaleOption',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get maleOption {
    return Intl.message(
      'Male',
      name: 'maleOption',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get cityHint {
    return Intl.message(
      'City',
      name: 'cityHint',
      desc: '',
      args: [],
    );
  }

  /// `Ibb`
  String get city1 {
    return Intl.message(
      'Ibb',
      name: 'city1',
      desc: '',
      args: [],
    );
  }

  /// `Sana'a`
  String get city2 {
    return Intl.message(
      'Sana\'a',
      name: 'city2',
      desc: '',
      args: [],
    );
  }

  /// `Aden`
  String get city3 {
    return Intl.message(
      'Aden',
      name: 'city3',
      desc: '',
      args: [],
    );
  }

  /// `Mukala`
  String get city4 {
    return Intl.message(
      'Mukala',
      name: 'city4',
      desc: '',
      args: [],
    );
  }

  /// `Taiz`
  String get city5 {
    return Intl.message(
      'Taiz',
      name: 'city5',
      desc: '',
      args: [],
    );
  }

  /// `Hodeidah`
  String get city6 {
    return Intl.message(
      'Hodeidah',
      name: 'city6',
      desc: '',
      args: [],
    );
  }

  /// `Dhamar`
  String get city7 {
    return Intl.message(
      'Dhamar',
      name: 'city7',
      desc: '',
      args: [],
    );
  }

  /// `Al-Mukha`
  String get city8 {
    return Intl.message(
      'Al-Mukha',
      name: 'city8',
      desc: '',
      args: [],
    );
  }

  /// `Al-Jawf`
  String get city9 {
    return Intl.message(
      'Al-Jawf',
      name: 'city9',
      desc: '',
      args: [],
    );
  }

  /// `Marib`
  String get city10 {
    return Intl.message(
      'Marib',
      name: 'city10',
      desc: '',
      args: [],
    );
  }

  /// `Raymah`
  String get city11 {
    return Intl.message(
      'Raymah',
      name: 'city11',
      desc: '',
      args: [],
    );
  }

  /// `Amran`
  String get city12 {
    return Intl.message(
      'Amran',
      name: 'city12',
      desc: '',
      args: [],
    );
  }

  /// `Sa'dah`
  String get city13 {
    return Intl.message(
      'Sa\'dah',
      name: 'city13',
      desc: '',
      args: [],
    );
  }

  /// `Al-Bayda`
  String get city14 {
    return Intl.message(
      'Al-Bayda',
      name: 'city14',
      desc: '',
      args: [],
    );
  }

  /// `Experience in Years`
  String get experienceHint {
    return Intl.message(
      'Experience in Years',
      name: 'experienceHint',
      desc: '',
      args: [],
    );
  }

  /// `Registered As`
  String get registeredAsHint {
    return Intl.message(
      'Registered As',
      name: 'registeredAsHint',
      desc: '',
      args: [],
    );
  }

  /// `Doctor`
  String get doctorOption {
    return Intl.message(
      'Doctor',
      name: 'doctorOption',
      desc: '',
      args: [],
    );
  }

  /// `Specialist`
  String get specialistHint {
    return Intl.message(
      'Specialist',
      name: 'specialistHint',
      desc: '',
      args: [],
    );
  }

  /// `Pick Profile Picture`
  String get pickUpText {
    return Intl.message(
      'Pick Profile Picture',
      name: 'pickUpText',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsText {
    return Intl.message(
      'Settings',
      name: 'settingsText',
      desc: '',
      args: [],
    );
  }

  /// `Your account`
  String get yourAccount {
    return Intl.message(
      'Your account',
      name: 'yourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notificationsButton {
    return Intl.message(
      'Notifications',
      name: 'notificationsButton',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get languagesButton {
    return Intl.message(
      'Languages',
      name: 'languagesButton',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logOutButton {
    return Intl.message(
      'Logout',
      name: 'logOutButton',
      desc: '',
      args: [],
    );
  }

  /// `Informations`
  String get informations {
    return Intl.message(
      'Informations',
      name: 'informations',
      desc: '',
      args: [],
    );
  }

  /// `Update Profile`
  String get updateProfile {
    return Intl.message(
      'Update Profile',
      name: 'updateProfile',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Update Password`
  String get updatePassword {
    return Intl.message(
      'Update Password',
      name: 'updatePassword',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Privacy policy`
  String get privacyPolicyButton {
    return Intl.message(
      'Privacy policy',
      name: 'privacyPolicyButton',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Effective Date: January 1, 2024`
  String get effectiveDate {
    return Intl.message(
      'Effective Date: January 1, 2024',
      name: 'effectiveDate',
      desc: '',
      args: [],
    );
  }

  /// `Introduction`
  String get introduction {
    return Intl.message(
      'Introduction',
      name: 'introduction',
      desc: '',
      args: [],
    );
  }

  /// `Your privacy is important to us. This privacy policy explains how we collect, use, and protect your information when you use our app.`
  String get privacyImportance {
    return Intl.message(
      'Your privacy is important to us. This privacy policy explains how we collect, use, and protect your information when you use our app.',
      name: 'privacyImportance',
      desc: '',
      args: [],
    );
  }

  /// `Information We Collect`
  String get informationWeCollect {
    return Intl.message(
      'Information We Collect',
      name: 'informationWeCollect',
      desc: '',
      args: [],
    );
  }

  /// `We may collect the following types of information:\n• Personal Information: Name, email address, etc.\n• Usage Data: Information about how you use our app.`
  String get typesOfInformation {
    return Intl.message(
      'We may collect the following types of information:\n• Personal Information: Name, email address, etc.\n• Usage Data: Information about how you use our app.',
      name: 'typesOfInformation',
      desc: '',
      args: [],
    );
  }

  /// `How We Use Your Information`
  String get howWeUseInformation {
    return Intl.message(
      'How We Use Your Information',
      name: 'howWeUseInformation',
      desc: '',
      args: [],
    );
  }

  /// `We may use your information to:\n• Provide and maintain our service.\n• Improve, personalize, and expand our app.\n• Communicate with you.`
  String get useInformationExplanation {
    return Intl.message(
      'We may use your information to:\n• Provide and maintain our service.\n• Improve, personalize, and expand our app.\n• Communicate with you.',
      name: 'useInformationExplanation',
      desc: '',
      args: [],
    );
  }

  /// `Data Security`
  String get dataSecurity {
    return Intl.message(
      'Data Security',
      name: 'dataSecurity',
      desc: '',
      args: [],
    );
  }

  /// `We take data security seriously and implement measures to protect your personal information.`
  String get dataSecurityExplanation {
    return Intl.message(
      'We take data security seriously and implement measures to protect your personal information.',
      name: 'dataSecurityExplanation',
      desc: '',
      args: [],
    );
  }

  /// `Changes to This Privacy Policy`
  String get changesToPrivacyPolicy {
    return Intl.message(
      'Changes to This Privacy Policy',
      name: 'changesToPrivacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `We may update our privacy policy from time to time. We will notify you of any changes by posting the new policy here.`
  String get privacyPolicyUpdates {
    return Intl.message(
      'We may update our privacy policy from time to time. We will notify you of any changes by posting the new policy here.',
      name: 'privacyPolicyUpdates',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message(
      'Contact Us',
      name: 'contactUs',
      desc: '',
      args: [],
    );
  }

  /// `If you have any questions about this privacy policy, please contact us at   779090900`
  String get contactInfo {
    return Intl.message(
      'If you have any questions about this privacy policy, please contact us at   779090900',
      name: 'contactInfo',
      desc: '',
      args: [],
    );
  }

  /// `Compliant`
  String get compliant {
    return Intl.message(
      'Compliant',
      name: 'compliant',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Submission`
  String get confirmationDialogTitle {
    return Intl.message(
      'Confirm Submission',
      name: 'confirmationDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to submit this complaint?`
  String get confirmationDialogContent {
    return Intl.message(
      'Are you sure you want to submit this complaint?',
      name: 'confirmationDialogContent',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelButtonText {
    return Intl.message(
      'Cancel',
      name: 'cancelButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submitButtonText {
    return Intl.message(
      'Submit',
      name: 'submitButtonText',
      desc: '',
      args: [],
    );
  }

  /// `We value your feedback and are committed to improving our services. Your complaints help us serve you better.`
  String get feedbackMessage {
    return Intl.message(
      'We value your feedback and are committed to improving our services. Your complaints help us serve you better.',
      name: 'feedbackMessage',
      desc: '',
      args: [],
    );
  }

  /// `Select Complaint Type`
  String get selectComplaintTypeLabel {
    return Intl.message(
      'Select Complaint Type',
      name: 'selectComplaintTypeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Technical`
  String get technicalChoice {
    return Intl.message(
      'Technical',
      name: 'technicalChoice',
      desc: '',
      args: [],
    );
  }

  /// `Administrative`
  String get administrativeChoice {
    return Intl.message(
      'Administrative',
      name: 'administrativeChoice',
      desc: '',
      args: [],
    );
  }

  /// `Write your complaint here`
  String get writeComplaintLabel {
    return Intl.message(
      'Write your complaint here',
      name: 'writeComplaintLabel',
      desc: '',
      args: [],
    );
  }

  /// `Submit Complaint`
  String get submitComplaintButton {
    return Intl.message(
      'Submit Complaint',
      name: 'submitComplaintButton',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get calendarMainText {
    return Intl.message(
      'Calendar',
      name: 'calendarMainText',
      desc: '',
      args: [],
    );
  }

  /// `BE `
  String get beText {
    return Intl.message(
      'BE ',
      name: 'beText',
      desc: '',
      args: [],
    );
  }

  /// `READY`
  String get readyText {
    return Intl.message(
      'READY',
      name: 'readyText',
      desc: '',
      args: [],
    );
  }

  /// `For your appointment`
  String get appointmentMessage {
    return Intl.message(
      'For your appointment',
      name: 'appointmentMessage',
      desc: '',
      args: [],
    );
  }

  /// `To make sure you remember all the important points, keep a record of them and refer back to your notes as needed.`
  String get reminderMessage {
    return Intl.message(
      'To make sure you remember all the important points, keep a record of them and refer back to your notes as needed.',
      name: 'reminderMessage',
      desc: '',
      args: [],
    );
  }

  /// `Add Note`
  String get addNoteButtonText {
    return Intl.message(
      'Add Note',
      name: 'addNoteButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Diary`
  String get diaryMainText {
    return Intl.message(
      'Diary',
      name: 'diaryMainText',
      desc: '',
      args: [],
    );
  }

  /// `Write down your thoughts!`
  String get writedownMessage {
    return Intl.message(
      'Write down your thoughts!',
      name: 'writedownMessage',
      desc: '',
      args: [],
    );
  }

  /// `No notes available.`
  String get noNotesMessage {
    return Intl.message(
      'No notes available.',
      name: 'noNotesMessage',
      desc: '',
      args: [],
    );
  }

  /// `Add a new Note`
  String get addNewNoteTitle {
    return Intl.message(
      'Add a new Note',
      name: 'addNewNoteTitle',
      desc: '',
      args: [],
    );
  }

  /// `Note Title`
  String get noteTitleHint {
    return Intl.message(
      'Note Title',
      name: 'noteTitleHint',
      desc: '',
      args: [],
    );
  }

  /// `Note Content`
  String get noteContentHint {
    return Intl.message(
      'Note Content',
      name: 'noteContentHint',
      desc: '',
      args: [],
    );
  }

  /// `Note Reader`
  String get notereader {
    return Intl.message(
      'Note Reader',
      name: 'notereader',
      desc: '',
      args: [],
    );
  }

  /// `Messages`
  String get messagesMainText {
    return Intl.message(
      'Messages',
      name: 'messagesMainText',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
