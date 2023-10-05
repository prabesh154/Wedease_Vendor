import 'package:wedeaseseller/const/const.dart';
import 'package:wedeaseseller/views/auth_screen/login_screen.dart';
import 'package:wedeaseseller/views/home_screen/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // checkUser();
  }
//
  // var isLoggedin = false;
  // checkUser() async {
  //   auth.authStateChanges().listen((User? user) {
  //     if (user == null && mounted) {
  //       isLoggedin = false;
  //     } else {
  //       isLoggedin = true;
  //     }
  //     setState(() {});
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,
      home: const LoginScreen(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent, elevation: 0.0),
      ),
    );
  }
}
