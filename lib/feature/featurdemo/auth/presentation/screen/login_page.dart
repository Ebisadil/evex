import 'package:flutter/material.dart';
import 'package:mainproject/feature/featurdemo/auth/presentation/screen/forgot_password.dart';
import 'package:mainproject/feature/featurdemo/auth/presentation/screen/singup_page.dart';
import 'package:mainproject/feature/featurdemo/home/presentation/screen/widget/tab.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _loginscreenState();
}

class _loginscreenState extends State<LoginPage> {
  final username = TextEditingController();
  final password = TextEditingController();

  bool isvisible = false;
  final fromkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: fromkey,
              child: Column(
                children: [
                  Image.asset(
                    "assets/evex.png",
                    width: 100,
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  Image.asset(
                    "assets/login.png",
                    width: 210,
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  //username field
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFF2D27A).withOpacity(.2)),
                    child: TextFormField(
                      controller: username,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please enter username";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: ("username"),
                      ),
                    ),
                  ),

                  //password field
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFF2D27A).withOpacity(.2)),
                    child: TextFormField(
                      controller: password,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please enter password";
                        }
                        return null;
                      },
                      obscureText: !isvisible,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        border: InputBorder.none,
                        hintText: ("password"),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isvisible = !isvisible;
                              });
                            },
                            icon: Icon(isvisible
                                ? Icons.visibility
                                : Icons.visibility_off)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  //login button
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFF2D27A),
                          Color(0xFFE1BC4E),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (fromkey.currentState!.validate()) {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 700),
                              pageBuilder: (_, animation, __) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(
                                          0, 0.1), // slightly from bottom
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: MainBottomNav(),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

// ---- OR Divider ----
                  Row(
                    children: [
                      Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text("OR"),
                      ),
                      Expanded(child: Divider(thickness: 1)),
                    ],
                  ),

                  SizedBox(height: 20),

// ---- Google Login Button ----
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        // TODO: Google login logic
                      },
                      icon: Image.asset(
                        "assets/google.png",
                        width: 18,
                        height: 18,
                      ),
                      label: Text(
                        "Continue with Google",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

// ---- Facebook Login Button ----
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFF1877F2),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        // TODO: Facebook login logic
                      },
                      icon: Icon(Icons.facebook, color: Colors.white),
                      label: Text(
                        "Continue with Facebook",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  //sigup button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SingupPage()));
                          },
                          child: Text("Sing up")),
                    ],
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPassword()));
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.red),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
