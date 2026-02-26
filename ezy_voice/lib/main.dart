// import 'package:ezy_voice/Screens/home_page.dart';
// import 'package:ezy_voice/Screens/plans_page.dart';
// import 'package:ezy_voice/Screens/support_page.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'Screens/lottiesplashscreen.dart';

// import 'firebase_options.dart'; // 👈 Required if you used flutterfire configure
// import 'models/history_item.dart';
// import 'Screens/voice_mode_page.dart';
// import 'Screens/history_page.dart';
// import 'Screens/login_screen.dart';
// import 'Screens/signup_screen.dart';  // 👈 Include signup also
// import 'models/sync_service.dart';
// import 'package:provider/provider.dart';
// import '../providers/usage_provider.dart';
// import 'providers/settings_provider.dart';// Change path based on your folder



// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize Firebase 
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   // Initialize Hive 📦
//   await Hive.initFlutter();
//   Hive.registerAdapter(HistoryItemAdapter());
//   await Hive.openBox<HistoryItem>('history');
//   await Hive.openBox('usageBox');
//   await SyncService().init();


//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Voice Calc',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(primarySwatch: Colors.deepPurple),

//       // 🔐 First screen = Login
//       initialRoute: '/lottie',

//       routes: {
//         '/lottie': (_) => LottieSplashScreen(),


//         // '/login': (_) => const LoginScreen(),
//         // '/signup': (_) => const SignupScreen(),
//         '/home': (_) => HomePage(),
//         '/voice_mode': (_) => VoiceModePage(),
//         '/history': (_) => const HistoryPage(),
//         '/plans': (_) => const PlansPage(),
//         '/support': (_) => const SupportPage(),
//       },
//     );
//   }
// }


import 'package:ezy_voice/Screens/home_page.dart';
import 'package:ezy_voice/Screens/plans_page.dart';
import 'package:ezy_voice/Screens/support_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart'; // 👈 Necessary

import 'Screens/lottiesplashscreen.dart';
import 'firebase_options.dart'; 
import 'models/history_item.dart';
import 'Screens/voice_mode_page.dart';
import 'Screens/history_page.dart';
import 'Screens/login_screen.dart';
import 'Screens/signup_screen.dart';  
import 'models/sync_service.dart';

// Import your Providers
import 'providers/usage_provider.dart';
import 'providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  Hive.registerAdapter(HistoryItemAdapter());
  await Hive.openBox<HistoryItem>('history');
  await Hive.openBox('usageBox');
  await SyncService().init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsageProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // We wrap the MaterialApp to use Settings from the Provider
    final settings = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      title: 'Voice Calc',
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode, // 🌓 Handles Dark/Light mode
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      darkTheme: ThemeData.dark(),
      
      initialRoute: '/lottie',

      routes: {
        '/lottie': (_) => LottieSplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/home': (_) => HomePage(),
        '/voice_mode': (_) => VoiceModePage(),
        '/history': (_) => const HistoryPage(),
        '/plans': (_) => const PlansPage(),
        '/support': (_) => const SupportPage(),
      },
    );
  }
}