import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../../main.dart';
import '../../../utils/auth_helper.dart';
import '../../Signup/signup_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }
  String mToken = "";

  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User declined or has not accepted permission");
    }
  }

  Future<void> getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mToken = token!;
        print("My token is: $mToken");
      });
      saveToken(mToken);
    });
  }

  void saveToken(String token) async {
    final userRef =
    FirebaseFirestore.instance.collection("users").doc(AuthHelper.getId());
    if ((await userRef.get()).exists) {
      await userRef.update({
        "token": token,
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  cursorColor: kPrimaryColor,
                  decoration: const InputDecoration(
                    hintText: email,
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Icon(Icons.person),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: TextFormField(
                    controller: _passwordController,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    cursorColor: kPrimaryColor,
                    decoration: const InputDecoration(
                      hintText: password,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Icon(Icons.lock),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: defaultPadding),
                Hero(
                  tag: "login_btn",
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_emailController!.text.isEmpty ||
                          _passwordController!.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: kPrimaryColor,
                          content: Text("Email và mật khẩu không được để trống!"),
                        ));
                        return;
                      }
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        final user = await AuthHelper.signInWithEmail(
                            email: _emailController!.text,
                            password: _passwordController!.text);
                        if (user != null) {
                          setState(() {
                            isLoading = false;
                          });
                          await requestPermission();
                          await getToken();
                          _openMyPage();
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            backgroundColor: kPrimaryColor,
                            content: Text("Email hoặc mật khẩu không chính xác!"),
                          ));
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      signIn.toUpperCase(),
                    ),
                  ),
                ),
                const SizedBox(height: defaultPadding),
                AlreadyHaveAnAccountCheck(
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const SignUpScreen();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        : const Material(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _openMyPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const MyApp(),
      ),
    );
  }
}
