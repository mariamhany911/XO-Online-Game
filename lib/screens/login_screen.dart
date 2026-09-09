import 'package:final_project/constants/colors.dart';
import 'package:final_project/routes/route_name.dart';
import 'package:final_project/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {

  final AuthService _authservice = AuthService();
  bool hiddenContent= true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SingleChildScrollView(
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
                    key:_formKey,
                    child: 
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Welcome back! Let's continue",
                          style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height:20),
                          
                          TextFormField(
                            controller: _emailController,
                            validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }

                        if (!value.contains("@") || !value.contains(".")) {
                          return "Invalid email";
                        }
                        return null;
                      },
                            decoration: InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder()
                            ),
                            
                          ),  
                          SizedBox(height:20),
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
                        return null;

                      },
                            decoration: InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(onPressed: (){
                                setState(() {
                                  hiddenContent = !hiddenContent;
                                });
                              }, 
                              icon: Icon(hiddenContent ? Icons.visibility_outlined : Icons.visibility_off_outlined))
                            ),
                          ) , 
                          SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: ()async {
                        if (_formKey.currentState!.validate()) {
                          final result = await _authservice.login(
                            email: _emailController.text.trim(),
                            password: _passController.text,
                          );

                          if(result != null){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Logged in , Welcome back!"),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          Navigator.pushReplacementNamed(
                          context,
                          RouteName.homeRouteName,
                        );}
                        }
                        
                      },
                           child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Center(child: Text("Login",style: TextStyle(fontWeight: FontWeight.bold),)),
                           ) 
                           ),
                          SizedBox(height:20),
                              
                           Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text("Don't have an account?"),
                               TextButton(onPressed: (){
                                Navigator.pushNamed(context, RouteName.registerRouteName);
                      
                               },child: Text(
                                  "Register",
                               style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: myYellow,
                                  color: myYellow
                               ),
                               )),
                             ],
                           ),
                        ],
                      ),
                    
                  ),
                )
              
            ]),
      ),
        );
  }
}