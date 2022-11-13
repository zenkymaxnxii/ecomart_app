import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../../main.dart';
import '../../../utils/auth_helper.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  TextEditingController? _confirmPasswordController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _confirmPasswordController = TextEditingController(text: "");
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
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  cursorColor: kPrimaryColor,
                  onSaved: (email) {},
                  decoration: const InputDecoration(
                    hintText: email,
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Icon(Icons.person),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: defaultPadding),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    cursorColor: kPrimaryColor,
                    decoration: const InputDecoration(
                      hintText: confirmPassword,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Icon(Icons.lock),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: defaultPadding / 2),
                ElevatedButton(
                  onPressed: () async {
                    if (_emailController!.text.isEmpty ||
                        _passwordController!.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: kPrimaryColor,
                        content: Text("Email và mật khẩu không được để trống!"),
                      ));
                      return;
                    }
                    if (_confirmPasswordController!.text.isEmpty ||
                        _passwordController!.text !=
                            _confirmPasswordController!.text) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: kPrimaryColor,
                        content: Text("Mật khẩu không trùng lặp!"),
                      ));
                      return;
                    }
                    if (!EmailValidator.validate(_emailController!.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: kPrimaryColor,
                        content: Text("Email không đúng định dạng!"),
                      ));
                      return;
                    }
                    try {
                      setState(() {
                        isLoading = true;
                      });
                      final user = await AuthHelper.signupWithEmail(
                          email: _emailController!.text,
                          password: _passwordController!.text);
                      if (user != null) {
                        setState(() {
                          isLoading = false;
                        });
                        await UserHelper.saveUser(user);
                        await requestPermission();
                        await getToken();
                        print("signup successful");
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const MyApp()));
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text(signUp.toUpperCase()),
                ),
                const SizedBox(height: defaultPadding),
                AlreadyHaveAnAccountCheck(
                  login: false,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const LoginScreen();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
