// ignore_for_file: use_build_context_synchronously, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_water/home_screen.dart';

import '../../widgets/pop_up_loader.dart';
import '../bloc/auth_bloc.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "login";

  const LoginScreen({super.key});
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool obsCheck = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoggedInState) {
          PopupLoader.hide();
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomePage(),),(route) => false,);
          }
          if (state is AuthErrorState) {
            PopupLoader.hide();
          }
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                
                Container(
                  height: size.height*0.9,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Text(
                            "Log in",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Welcome Back",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 44,
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                            width: 1.0, color: Colors.black),
                                      ),
                                    ),
                                    child: const Icon(Icons.email_outlined)),
                              ),
                              labelText: 'Email Address',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email';
                              } else if (!value.contains("@")) {
                                return "Please enter valid email";
                              }
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                              width: 1.0, color: Colors.black),
                                        ),
                                      ),
                                      child: const Icon(Icons.lock_open_rounded)),
                                ),
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        obsCheck = !obsCheck;
                                      });
                                    },
                                    icon: Icon(obsCheck
                                        ? Icons.visibility
                                        : Icons.visibility_off))),
                            obscureText: !obsCheck,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          // Row(
                          //   children: [
                          //     TextButton(onPressed: (){}, child: child)
                          //   ],
                          // )
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              if (state is AuthErrorState) {
                                return Text(state.error,
                                    style: const TextStyle(color: Colors.red));
                              }
                              return const SizedBox();
                            },
                          ),
                          const SizedBox(height: 20,),
                          ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                                      PopupLoader.show();
                                      BlocProvider.of<AuthBloc>(context)
                                          .add(LoginEvent(
                                        _emailController.text,
                                        _passwordController.text,
                                      ));
                                    }
                          },
                          child: const Text("Log In")),
                         
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          //   child: ElevatedButton(
                          //       onPressed: () async {
                          //         if (isLoading) {
                          //         } else {
                          //           if (_formKey.currentState!.validate()) {
                          //             setState(() {
                          //               isLoading = true;
                          //             });
                          //             BlocProvider.of<AuthBloc>(context)
                          //                 .add(LoginEvent(
                          //               _emailController.text,
                          //               _passwordController.text,
                          //             ));
                          //           }
                          //         }
                          //       },
                          //       style: ElevatedButton.styleFrom(
                          //         padding: EdgeInsets.fromLTRB(
                          //             size.width / 4,
                          //             size.height / 40,
                          //             size.width / 4,
                          //             size.height / 40),
                          //         shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(50)),
                          //       ),
                          //       child: isLoading
                          //           ? const CircularProgressIndicator(
                          //               color: Colors.white)
                          //           : const Text('Sign In')
                          //       //  BlocBuilder<AuthBloc, AuthState>(
                          //       //   builder: (context, state) {
                          //       //     if (state is AuthLoadingState) {
                          //       //       return const CircularProgressIndicator(color: Colors.amber,);
                          //       //     }
                          //       //     return const Text('Sign In');
                          //       //   },
                          //       // ),
                          //       ),
                          // ),
                         
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, SignupScreen.routeName);
                              },
                              child: const Text("Don't have an account? Sign up")),
                          const SizedBox(height: 16.0)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
