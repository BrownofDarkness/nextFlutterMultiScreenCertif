import 'package:flutter/material.dart';
import 'package:next_flutter_recipe/UI/shared/widgets/default_button.dart';
import 'package:next_flutter_recipe/models/user_model.dart';
import 'package:next_flutter_recipe/utils/button_states.dart';
import 'package:next_flutter_recipe/utils/colors.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isObscured = true;
  bool isProcessing = false;
  String? _email;
  String? _pseudo;
  String? _password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLightColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome back", style: TextStyle(fontSize: 24, color: Colors.white)),
                  SizedBox(height: 10),
                  Text("Please enter your credentials to login", style: TextStyle(fontSize: 16, color: Colors.white)),
                  SizedBox(height: 30),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      SizedBox(height: 10),
                      TextFormField(
                        enabled: !isProcessing,
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          label: Text("Email"),
                          hintText: "test@example.com",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'L\'email est requis';
                          }
                          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Entrez un email valide';
                          }

                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        enabled: !isProcessing,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          label: Text("Pseudo"),
                          hintText: "@wilbrown",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _pseudo = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Le pseudo est requis';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        enabled: !isProcessing,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscureText: isObscured,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          label: Text("Mot de passe"),
                          hintText: "*********",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(isObscured?Icons.visibility_off:Icons.visibility),
                            onPressed: () {
                              setState(() {
                                isObscured = !isObscured;
                              });
                            },
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Le mot de passe est requis';
                          }
                          if (value.length < 6) {
                            return 'Doit contenir au moins 6 caractères';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 70),
                      DefaultButton(
                        label: "Login",
                        buttonState: isProcessing?ButtonState.loading:ButtonState.enabled,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isProcessing = !isProcessing;
                            });
                            Future.delayed(Duration(seconds: 2), () {
                              UserModel user = UserModel.fromMap(
                                {
                                  "pseudo": _pseudo,
                                  "email": _email,
                                  "password": _password
                                }
                              );
                              setState(() {
                                isProcessing = !isProcessing;
                              });
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
