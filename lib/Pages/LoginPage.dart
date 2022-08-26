import 'package:flutter/material.dart';
import 'package:onyourmarks/Pages/Students/Academics/GetStudentInterest.dart';
import 'package:onyourmarks/Utilities/functions.dart';
import 'package:onyourmarks/Utilities/staticNames.dart';
import 'package:rive/rive.dart';
import 'package:translator/translator.dart';
import '../Models/Student Models/UserModel.dart';
import '../Utilities/Components/functional.dart';
import 'package:flutter_translate/flutter_translate.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var username = TextEditingController();
  var password = TextEditingController();
  var invalidUsername = false;
  var invalidPassword = false;
  var passwordInVisibility = true;
  late UserModel user;
  var isChecking = false;
  GoogleTranslator translator = GoogleTranslator();
  var flag = true;
  getAppName() async {
    return await translator
        .translate(APP_NAME, from: 'en', to: 'mr')
        .then(print);
  }

  @override
  void initState() {
    // getAppName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(texts[0]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            placeASizedBoxHere(100),
            Row(
              children: [
                placeAExpandedHere(1),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      TextField(
                        controller: username,
                        decoration: InputDecoration(
                          errorText: (invalidUsername) ? "Invalid" : null,
                          border: UnderlineInputBorder(),
                          labelText: texts[1],
                        ),
                        onChanged: (s) {
                          invalidUsername = false;
                          (mounted) ? setState(() {}) : null;
                        },
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TextField(
                        controller: password,
                        obscureText: passwordInVisibility,
                        decoration: InputDecoration(
                          errorText: (invalidPassword) ? texts[5] : null,
                          border: UnderlineInputBorder(),
                          labelText: texts[2],
                          suffixIcon: passwordInVisibility
                              ? IconButton(
                                  color: Colors.grey,
                                  onPressed: () {
                                    passwordInVisibility =
                                        !passwordInVisibility;
                                    (mounted) ? setState(() {}) : null;
                                  },
                                  icon: Icon(Icons.remove_red_eye),
                                )
                              : IconButton(
                                  onPressed: () {
                                    passwordInVisibility =
                                        !passwordInVisibility;
                                    (mounted) ? setState(() {}) : null;
                                  },
                                  icon: Icon(Icons.remove_red_eye)),
                        ),
                        onChanged: (s) {
                          invalidPassword = false;
                          (mounted) ? setState(() {}) : null;
                        },
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            (mounted)
                                ? setState(() {
                                    isChecking = true;
                                  })
                                : null;
                            var check = true;
                            if (username.text == "") {
                              invalidUsername = true;
                              check = false;
                              isChecking = false;
                            }

                            if (password.text == "") {
                              invalidPassword = true;
                              check = false;
                              isChecking = false;
                            }

                            (mounted) ? setState(() {}) : null;

                            if (check) {
                              user =
                                  await checkMe(username.text, password.text);
                              (mounted) ? setState(() {}) : null;
                              if (user.username != "Error") {
                                isChecking = false;
                                username.text = "";
                                password.text = "";
                                if (!(user.isRegistered ?? false)) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PasswordChangePage(user)));
                                } else
                                  goToRespectiveHomeScreen(context);
                              }
                            }
                          },
                          child: Text(texts[3])),
                      (isChecking)
                          ? Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                placeASizedBoxHere(30),
                                Container(
                                  width: 150,
                                  height: 150,
                                  child: RiveAnimation.network(
                                    'https://cdn.rive.app/animations/vehicles.riv',
                                    animations: const ['idle', 'curves'],
                                  ),
                                )
                              ],
                            ))
                          : Text(""),
                    ],
                  ),
                ),
                placeAExpandedHere(1)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordChangePage extends StatefulWidget {
  final UserModel user;
  const PasswordChangePage(this.user, {Key? key}) : super(key: key);

  @override
  State<PasswordChangePage> createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  var newPassword = TextEditingController();
  var confirmPassword = TextEditingController();
  var password1InVisibility = true;
  var password2InVisibility = true;
  var isChecking = false;
  var invalidPassword2 = false;
  var invalidPassword1 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Change Password"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Row(
              children: [
                Expanded(child: Text("")),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      TextField(
                        controller: newPassword,
                        obscureText: password1InVisibility,
                        decoration: InputDecoration(
                          errorText: (invalidPassword1) ? "Invalid" : null,
                          border: UnderlineInputBorder(),
                          labelText: "New Password",
                          suffixIcon: password1InVisibility
                              ? IconButton(
                                  color: Colors.grey,
                                  onPressed: () {
                                    password1InVisibility =
                                        !password1InVisibility;
                                    (mounted) ? setState(() {}) : null;
                                  },
                                  icon: Icon(Icons.remove_red_eye),
                                )
                              : IconButton(
                                  color: Colors.blue,
                                  onPressed: () {
                                    password1InVisibility =
                                        !password1InVisibility;
                                    (mounted) ? setState(() {}) : null;
                                  },
                                  icon: Icon(Icons.remove_red_eye)),
                        ),
                        onChanged: (s) {
                          invalidPassword1 = false;
                          (mounted) ? setState(() {}) : null;
                        },
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TextField(
                        controller: confirmPassword,
                        obscureText: password2InVisibility,
                        decoration: InputDecoration(
                          errorText: (invalidPassword2) ? "Invalid" : null,
                          border: UnderlineInputBorder(),
                          labelText: "Confirm Password",
                          suffixIcon: password2InVisibility
                              ? IconButton(
                                  color: Colors.grey,
                                  onPressed: () {
                                    password2InVisibility =
                                        !password2InVisibility;
                                    (mounted) ? setState(() {}) : null;
                                  },
                                  icon: Icon(Icons.remove_red_eye),
                                )
                              : IconButton(
                                  onPressed: () {
                                    password2InVisibility =
                                        !password2InVisibility;
                                    (mounted) ? setState(() {}) : null;
                                  },
                                  icon: Icon(Icons.remove_red_eye)),
                        ),
                        onChanged: (s) {
                          invalidPassword2 = false;
                          (mounted) ? setState(() {}) : null;
                        },
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            (mounted)
                                ? setState(() {
                                    isChecking = true;
                                  })
                                : null;
                            var check = true;
                            if (newPassword.text == "") {
                              invalidPassword1 = true;
                              check = false;
                              isChecking = false;
                            }
                            if (confirmPassword.text == "") {
                              invalidPassword2 = true;
                              check = false;
                              isChecking = false;
                            }
                            if (confirmPassword.text != newPassword.text) {
                              invalidPassword2 = true;
                              invalidPassword1 = true;
                              check = false;
                              isChecking = false;
                            }
                            if (check) {
                              var isRegistered = await changePassword(
                                  widget.user.username ?? '',
                                  confirmPassword.text);
                              isChecking = false;
                              newPassword.text = "";
                              confirmPassword.text = "";
                              if (isRegistered) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GetStudentInterest()));
                              }
                            }
                            (mounted) ? setState(() {}) : null;
                          },
                          child: Text("Change")),
                      (isChecking)
                          ? Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("Loading Data")
                              ],
                            ))
                          : Text(""),
                    ],
                  ),
                ),
                Expanded(child: Text("")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
