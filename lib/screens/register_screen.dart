import 'package:final_project/routes/route_name.dart';
import 'package:final_project/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authservice = AuthService();

  bool hiddenContent = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  // final TextEditingController _userController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(60),
              child: SvgPicture.asset(
                'lib/assets/logo.svg',
                width: 300,
                height: 300,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome! Let's get you started",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),

                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }

                        if (!value.contains("@") || !value.contains(".")) {
                          return "Invalid email";
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    // SizedBox(height:20),
                    // TextFormField(
                    //   controller: _userController,
                    //   decoration: InputDecoration(
                    //     labelText: "Username",
                    //     border: OutlineInputBorder()
                    //   ),

                    // ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passController,
                      obscureText: hiddenContent,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }

                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hiddenContent = !hiddenContent;
                            });
                          },
                          icon: Icon(
                            hiddenContent
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final result = await _authservice.register(
                            email: _emailController.text.trim(),
                            password: _passController.text,
                          );

                          if(result != null){
                          Navigator.pushReplacementNamed(
                          context,
                          RouteName.homeRouteName,
                        );}
                        }
                        
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Color.fromARGB(255, 255, 215, 0),
                        ),
                      ),
                      child: SizedBox(
                        width: 60,
                        height: 50,
                        child: Center(
                          child: Text(
                            "Register",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RouteName.loginRouteName,
                            );
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: Color.fromARGB(255, 255, 215, 0),
                              color: Color.fromARGB(255, 255, 215, 0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
