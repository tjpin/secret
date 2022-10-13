import 'package:fluttertoast/fluttertoast.dart';
import 'package:password_manager/imports.dart';
import 'package:password_manager/screens/auth_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = 'profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController unameController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  bool isUserAvailable = false;
  String user = '';
  int pincode = 0;

  getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user');
    final code = prefs.getInt('passcode');
    if (name == null) {
      isUserAvailable = false;
      return;
    }
    setState(() {
      isUserAvailable = true;
      user = name;
    });
    if (code == null) {
      return;
    }
    setState(() {
      pincode = code;
    });
  }

  setUsername(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', name);
    Fluttertoast.showToast(msg: 'User saved ✔');
  }

  setCode(int pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('passcode', pin);
    Fluttertoast.showToast(msg: 'Pin saved ✔');
  }

  int intLenght(int value) {
    int len = 0;
    for (int i = 0; i < value; i++) {
      len += i;
    }
    return len;
  }

  @override
  void dispose() {
    unameController.dispose();
    pinController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getUser();
    unameController.text = user;
    pinController.text = pincode == 0 ? "" : '*' * intLenght(pincode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ctx = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update profile"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Chip(
                  label: Text(
                      isUserAvailable ? "Change username" : "Set Username")),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    child: InputField(
                        ctx: ctx,
                        hint: "username",
                        controller: unameController),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        unameController.text.isEmpty
                            ? Fluttertoast.showToast(
                                msg: 'Name is required',
                                backgroundColor: Colors.red)
                            : setUsername(unameController.text);
                        Future.delayed(Duration(seconds: 1),
                            () => unameController.clear());
                        setState(() {});
                      },
                      child: const Text("Save"))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Chip(label: Text(pincode != 0 ? "Change Pin" : "Set Pin")),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    child: InputField(
                      ctx: ctx,
                      hint: "Pin",
                      controller: pinController,
                      isPassword: true,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        pinController.text.isEmpty
                            ? Fluttertoast.showToast(
                                msg: 'Pin required',
                                backgroundColor: Colors.red)
                            : setCode(int.parse(pinController.text));
                        Future.delayed(const Duration(seconds: 1),
                            () => pinController.clear());
                      },
                      child: const Text("Save"))
                ],
              ),
              const SizedBox(
                height: 200,
              ),
              Center(
                child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const AuthScreen()),
                          (route) => false);
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Signout")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
