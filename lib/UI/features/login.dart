import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:next_flutter_recipe/UI/shared/widgets/default_button.dart';
import 'package:next_flutter_recipe/models/user_model.dart';
import 'package:next_flutter_recipe/utils/button_states.dart';
import 'package:next_flutter_recipe/utils/colors.dart';
import 'package:next_flutter_recipe/utils/images.dart';

import '../../navigation/routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isObscured = true;
  bool isProcessing = false;
  String? _email;
  String? _pseudo;
  String? _password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 500,
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    children: [
                      Image.asset(AppImages.logo, width: 100, height: 100),
                      Text(
                        "MyRecipes",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, color: AppColors.primaryColor),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        enabled: !isProcessing,
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            label: Text("Email"),
                            hintText: "test@example.com",
                            filled: true,
                            fillColor: AppColors.tertiaryColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: AppColors.primaryColor,
                                width: 1,
                              ),
                            ),

                            prefixIcon: Icon(Icons.email)
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
                            fillColor: AppColors.tertiaryColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: AppColors.primaryColor,
                                width: 2,
                              ),
                            ),
                            prefixIcon: Icon(Icons.person)
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
                          fillColor: AppColors.tertiaryColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              width: 2,
                            ),
                          ),
                          prefixIcon: Icon(Icons.lock),
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
                      SizedBox(height: 50),
                      DefaultButton(
                        label: "Log in",
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
                              context.pushNamed(AppRoutes.recipes);
                            });
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Demo login — any credentials work",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: AppColors.primaryColor.withAlpha(150)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
