import 'package:password_manager/screens/auth_screen.dart';
import 'package:password_manager/screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'screens/search_screen.dart';
import 'imports.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CardDataAdapter());
  Hive.registerAdapter(AccountAdapter());
  await Hive.openBox<CardData>('cards');
  await Hive.openBox<Account>('accounts');

  final prefs = await SharedPreferences.getInstance();
  final mode = prefs.getBool('isDarkMode') ?? false;
  runApp(MyApp(mode: mode));
}

class MyApp extends StatefulWidget {
  final bool mode;
  const MyApp({Key? key, required this.mode}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController userController = TextEditingController();
  bool isDarkMode = true;

  Future<void> setUser(String user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', user);
    setState(() {});
  }

  @override
  void dispose() {
    userController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      isDarkMode = widget.mode;
    });
    super.initState();
  }

  void changeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = !isDarkMode;
      prefs.setBool('isDarkMode', isDarkMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor:
            !isDarkMode ? HexColor('#262424') : Colors.white,
      ),
      child: MaterialApp(
        title: 'Password Manager',
        debugShowCheckedModeBanner: false,
        theme: isDarkMode ? lightTheme() : darkTheme(),
        builder: EasyLoading.init(),
        routes: {
          SearchScreen.routeName: (context) => const SearchScreen(),
          AuthScreen.routeName: (context) => const AuthScreen(),
          ProfileScreen.routeName: (context) => const ProfileScreen(),
          Dashboard.routeName: (context) => Dashboard(
                isDarkMode: isDarkMode,
                changeTheme: changeTheme,
                userController: userController,
                setUser: () => setUser(userController.text),
              ),
        },
        home: AnimatedSplashScreen(
          splash: Text(
            'Secrete',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 40),
          ),
          duration: 2000,
          backgroundColor: HexColor("#262424"),
          splashTransition: SplashTransition.rotationTransition,
          curve: Curves.easeInOut,
          nextScreen: const AuthScreen(),
        ),
      ),
    );
  }
}
