import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nerding_admin_web/screen/home_screen/home_screen.dart';
import 'package:nerding_admin_web/utils/backgroundPainter.dart';
import 'package:nerding_admin_web/utils/errorDialog.dart';
import 'package:nerding_admin_web/utils/loadingDialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = "";
  String password = "";
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final double _screenHeight = MediaQuery.of(context).size.height;
    final double _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.lerp(
            Alignment.lerp(Alignment.centerRight, Alignment.center, 0.3),
            Alignment.topCenter,
            0.15,
          )!,
          children: [
            CustomPaint(
              painter: BackgroundPainter(),
              child: Container(
                height: _screenHeight,
              ),
            ),
            Center(
              child: Container(
                width: _screenWidth * 0.5,
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Image.asset(
                          'assets/images/admin.png',
                          width: 300,
                          height: 300,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                      ),
                      child: _returnEmailField(Icons.person, false),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                      ),
                      child: _returnPasswordField(Icons.password, true),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: _screenHeight * 0.08,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                          ),
                          child: _returnLoginButton(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _login() async {
    showDialog(
      context: context,
      builder: (context) {
        return LoadingAlertDialog(
          message: 'Please wait ...',
        );
      },
    );

    User? currentUser;
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((mAuth) {
      currentUser = mAuth.user!;
    }).catchError((onError) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) {
          return ErrorAlertDialog(
            message: onError.toString(),
          );
        },
      );
    });

    if (currentUser != null) {
      //homePage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else {
      //loginPage
    }
  }

  _returnEmailField(IconData iconData, bool isObscure) {
    return TextFormField(
      onChanged: (value) => email = value,
      obscureText: isObscure,
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
          ),
        ),
        hintText: 'Email',
        hintStyle: TextStyle(color: Colors.white54),
        icon: Icon(
          iconData,
          color: Colors.green,
        ),
      ),
    );
  }

  _returnPasswordField(IconData iconData, bool isObscure) {
    return TextFormField(
      onChanged: (value) => password = value,
      obscureText: isObscure,
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
          ),
        ),
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.white60),
        icon: Icon(
          iconData,
          color: Colors.green,
        ),
      ),
    );
  }

  _returnLoginButton() {
    return ElevatedButton(
      onPressed: () {
        if (email.isNotEmpty && password.isNotEmpty) {
          _login();
        } else {
          Fluttertoast.showToast(
            msg: "Preencha todos os campos para acessar!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            webShowClose: true,
            webPosition: 'center',
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
      child: Text(
        'Login',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
