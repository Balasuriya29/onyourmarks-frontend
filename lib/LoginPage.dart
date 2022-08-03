import 'package:flutter/material.dart';
import 'package:onyourmarks/Utilities/functions.dart';
import 'Utilities/components.dart';
import 'Models/Student Models/UserModel.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("OnYourMarks"),
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
                        controller: username,

                        decoration: InputDecoration(
                          errorText: (invalidUsername)?"Invalid":null,
                          border: UnderlineInputBorder(),
                          labelText: "Username",
                        ),
                        onChanged: (s){
                          invalidUsername = false;
                          setState(() {
                            
                          });
                        },
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TextField(
                        controller: password,
                        obscureText: passwordInVisibility,
                        decoration: InputDecoration(
                          errorText: (invalidPassword)?"Invalid":null,
                          border: UnderlineInputBorder(),
                          labelText: "Password",
                          suffixIcon:
                            passwordInVisibility
                                ?IconButton(
                                  color: Colors.grey,
                                  onPressed: () {
                                    passwordInVisibility = !passwordInVisibility;
                                    setState(() {

                                    });
                                  },
                                  icon: Icon(Icons.remove_red_eye),
                                )
                                :IconButton(
                                  onPressed: (){
                                    passwordInVisibility = !passwordInVisibility;
                                    setState(() {

                                    });
                                  },
                                  icon: Icon(Icons.remove_red_eye)
                                ),
                        ),
                        onChanged: (s){
                          invalidPassword = false;
                          setState(() {

                          });
                        },
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      ElevatedButton(onPressed: () async{
                        setState(() {
                          isChecking = true;
                        });
                        var check = true;
                        if(username.text == ""){
                          invalidUsername = true;
                          check = false;
                          isChecking = false;
                        }

                        if(password.text == ""){
                          invalidPassword = true;
                          check = false;
                          isChecking = false;
                        }

                        setState(() {

                        });

                        if(check){
                          user = await checkMe(username.text, password.text);
                          isChecking = false;
                          if(!(user.isRegistered ?? false)){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordChangePage(user)));
                          }
                          else
                            goToRespectiveHomeScreen(context);

                        }

                      }, child: Text("Login")),
                      (isChecking)
                      ?Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Loading Data")
                        ],
                      ))
                      :Text(""),
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
      body: Column(
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
                        errorText: (invalidPassword1)?"Invalid":null,
                        border: UnderlineInputBorder(),
                        labelText: "New Password",
                        suffixIcon:
                        password1InVisibility
                            ?IconButton(
                          color: Colors.grey,
                          onPressed: () {
                            password1InVisibility = !password1InVisibility;
                            setState(() {

                            });
                          },
                          icon: Icon(Icons.remove_red_eye),
                        )
                            :IconButton(
                          color: Colors.blue,
                            onPressed: (){
                              password1InVisibility = !password1InVisibility;
                              setState(() {

                              });
                            },
                            icon: Icon(Icons.remove_red_eye)
                        ),
                      ),
                      onChanged: (s){
                        invalidPassword1 = false;
                        setState(() {

                        });
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    TextField(
                      controller: confirmPassword,
                      obscureText: password2InVisibility,
                      decoration: InputDecoration(
                        errorText: (invalidPassword2)?"Invalid":null,
                        border: UnderlineInputBorder(),
                        labelText: "Confirm Password",
                        suffixIcon:
                        password2InVisibility
                            ?IconButton(
                          color: Colors.grey,
                          onPressed: () {
                            password2InVisibility = !password2InVisibility;
                            setState(() {

                            });
                          },
                          icon: Icon(Icons.remove_red_eye),
                        )
                            :IconButton(
                            onPressed: (){
                              password2InVisibility = !password2InVisibility;
                              setState(() {

                              });
                            },
                            icon: Icon(Icons.remove_red_eye)
                        ),
                      ),
                      onChanged: (s){
                        invalidPassword2 = false;
                        setState(() {

                        });
                      },
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    ElevatedButton(onPressed: () async{
                      setState(() {
                        isChecking = true;
                      });
                      var check = true;
                      if(newPassword.text == ""){
                        invalidPassword1 = true;
                        check = false;
                        isChecking = false;
                      }
                      if(confirmPassword.text == ""){
                        invalidPassword2 = true;
                        check = false;
                        isChecking = false;
                      }
                      if(confirmPassword.text != newPassword.text){
                        invalidPassword2 = true;
                        invalidPassword1 = true;
                        check = false;
                        isChecking = false;
                      }
                      if(check){
                        var isRegistered = await changePassword(widget.user.username ?? '', confirmPassword.text);
                        isChecking = false;
                        if(isRegistered){
                          goToRespectiveHomeScreen(context);
                        }
                      }
                      setState(() {

                      });
                    }, child: Text("Change")),
                    (isChecking)
                        ?Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Loading Data")
                      ],
                    ))
                        :Text(""),
                  ],
                ),
              ),
              Expanded(child: Text("")),
            ],
          ),
        ],
      ),
    );
  }
}

