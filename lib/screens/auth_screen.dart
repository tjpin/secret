import 'package:fluttertoast/fluttertoast.dart';
import 'package:password_manager/screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:password_manager/imports.dart';
import 'package:password_manager/utils/auth.dart';

import '../widgets/authpin_input.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = 'authscreen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController cnt = TextEditingController();
  int? pincode;

  void getPinCode() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getInt('passcode');
    if (code == null) {
      return;
    }
    setState(() => pincode = code);
  }

  setCode(int code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('passcode', code);
    setState(() {});
  }

  @override
  void initState() {
    getPinCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ctx = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(pincode == null ? "Welcome" : "Welcome back"),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height / 4,
                ),
                Text(pincode == null ? 'Setup pin' : 'Enter pin'),
                const SizedBox(
                  height: 20,
                ),
                AuthPinInput(cnt: cnt, ctx: ctx),
                const SizedBox(
                  width: 10,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                        onPressed: () async {
                          await AuthHelper.authenticate()
                              ? Navigator.of(context)
                                  .pushReplacementNamed(Dashboard.routeName)
                              : null;
                        },
                        icon: const Icon(Icons.fingerprint),
                        label: const Text("User fingerprint")),
                    TextButton.icon(
                        onPressed: () {
                          if (cnt.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 2),
                                content: Text(
                                  "Pin is Required",
                                  style: ctx.textTheme.bodySmall,
                                )));
                            return;
                          }
                          if (pincode == null) {
                            setCode(int.parse(cnt.text));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 2),
                                content: Text(
                                  "Pin added successifully",
                                  style: ctx.textTheme.bodySmall,
                                )));
                            setState(() {});
                          }
                          if (pincode == int.parse(cnt.text)) {
                            Navigator.of(context)
                                .pushReplacementNamed(Dashboard.routeName);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 2),
                                content: Text(
                                  "Wrong pin",
                                  style: ctx.textTheme.bodySmall,
                                )));
                          }
                        },
                        icon: const Icon(Icons.login),
                        label: const Text("Login")),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

Center authButton(BuildContext context) {
  return Center(
      child: TextButton.icon(
          onPressed: () async {
            Navigator.of(context).pushReplacementNamed(Dashboard.routeName);
          },
          icon: const Icon(Icons.fingerprint),
          label: const Text('Authorize')));
}
