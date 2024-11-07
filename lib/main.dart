import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:practica_5/firebase_options.dart';
import 'package:practica_5/provider/test_provider.dart';
import 'package:practica_5/screeens/detaill_popular_screen.dart';
import 'package:practica_5/screeens/favorite_list_screen.dart';
import 'package:practica_5/screeens/home_screen.dart';
import 'package:practica_5/screeens/login_screen.dart';
import 'package:practica_5/screeens/movies_screen.dart';
import 'package:practica_5/screeens/movies_screen_fireBase.dart';
import 'package:practica_5/screeens/popular_screen.dart';
import 'package:practica_5/screeens/register_screen.dart';
import 'package:practica_5/settings/global_values.dart';
import 'package:practica_5/settings/theme_settings.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: GlobalValues.banThemeDark,
        builder: (context, value, widget) {
          return ChangeNotifierProvider(
            create: (context) => TestProvider(),
            child: MaterialApp(
              theme: value
                  ? ThemeSettings.darkTheme()
                  : ThemeSettings.ligthTheme(),
              // theme: value ? ThemeData.dark() : ThemeData.light(),
              debugShowCheckedModeBanner: false,
              title: 'Metrial App',
              home: const HomeScreen(),
              routes: {
                "/home": (context) => const HomeScreen(),
                "/db": (context) => const MoviesScreen(),
                "/popularMovies": (context) => const PopularScreen(),
                "/detaill": (context) => const DetaillPopularScreen(),
                "/register": (context) => const RegisterScreen(),
                "/firebaseMovies": (context) => const MoviesScreenFirebase(),
                "/favoriteList": (context) => const FavoritosScreen(),
              },
            ),
          );
        });
  }
}
