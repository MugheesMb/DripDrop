import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_water/home_screen.dart';
import 'auth/bloc/auth_bloc.dart';
import 'auth/ui/login_signup_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
// runApp(MultiBlocProvider(
//     providers: [
//       BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
//    ],
// child: const MyApp(),
//  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Aqua Squad',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.lightBlue[900],
          fontFamily: GoogleFonts.poppins().fontFamily,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue[900] as Color),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.lightBlue[900],
            titleTextStyle: TextStyle(color: Colors.white, fontFamily: GoogleFonts.poppins().fontFamily,fontSize: 16),
            iconTheme: const IconThemeData(color: Colors.white)
          ),
          useMaterial3: true,
        ),
        home: FirebaseAuth.instance.currentUser == null
            ? const LoginSignupScreen()
            : const ProviderScope(child: HomePage()),
      ),
    );
  }
}
