import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sanad/generated/l10n.dart';
import 'package:sanad/services/share_preference.dart';
import 'screens/Therapists/cubit/therapist_cubit.dart';
import 'screens/chatPage/therapist_list_cubit.dart';
import 'utils.dart';
import 'package:sanad/services/navigation_service.dart';
import 'package:get_it/get_it.dart';
import 'package:sanad/services/auth_service.dart';

void main() async {
  await setup();
  runApp(
    ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: MyApp(),
    ),
  );
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await registerServices();
  await CashSaver.init();
  // Enable App Check
  await FirebaseAppCheck.instance.activate();
}

class MyApp extends StatelessWidget {
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late AuthService _authService;

  MyApp({super.key}) {
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MultiProvider(
      providers: [
        BlocProvider(create: (context) => TherapistCubit()),
        BlocProvider(create: (context) => TherapistListCubit()),
      ],
      child: MaterialApp(
        locale: languageProvider.locale,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        navigatorKey: _navigationService.navigatorKey,
        theme: ThemeData(
          primaryColor: MyColors.skyBlue,
          colorScheme: ColorScheme.fromSeed(seedColor: MyColors.skyBlue),
          useMaterial3: true,
        ),
        initialRoute: _authService.user != null ? "/main" : "/intro",
        routes: _navigationService.routes,
      ),
    );
  }
}

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('en'); // Default locale

  Locale get locale => _locale;

  void toggleLanguage() {
    if (_locale.languageCode == 'en') {
      _locale = const Locale('ar'); // Switch to Arabic
    } else {
      _locale = const Locale('en'); // Switch to English
    }
    notifyListeners(); // Notify listeners to rebuild
  }
}
