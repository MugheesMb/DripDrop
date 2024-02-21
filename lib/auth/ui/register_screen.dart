// ignore_for_file: use_build_context_synchronously, body_might_complete_normally_nullable


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
import '../../CO2 Emission Calulator/quiz_screen.dart';
import '../bloc/auth_bloc.dart';
import '../models/user_model.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = "sign-up";

  const SignupScreen({super.key});
  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  //final _confirmPasswordController = TextEditingController();
  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();
  //final _occupationController = TextEditingController();
  bool obsCheck1 = true;
  // bool obsCheck2 = false;
  bool isLoading = false;
  String errMsg = "";

  @override
  void dispose() {
    _emailController.dispose();
    //_passwordController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoggedInState) {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const logQuiz()), (route) => false,);
          }
          if (state is AuthErrorState) {
            setState(() {
              isLoading = false;
            });
          }
          if (state is AuthAlreadyReqState) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Already Requested'),
                  content: const Text(
                      'Your registration request is already requested. Please wait for the admin to approve you'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
          if (state is AuthRequestedState) {
            showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Registration Request'),
        content: const Text('Your registration request has been sent. The admin will send you account details soon.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Text(
                            "Sign up",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Create an account here",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 44,
                          ),
                          TextFormField(
                            controller: _fNameController,
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
                                    child: const Icon(Icons.person_outline)),
                              ),
                              labelText: 'First Name',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _lNameController,
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
                                    child: const Icon(Icons.person_outline)),
                              ),
                              labelText: 'Last Name',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
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
                                return "enter a valid email";
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _passController,
                            obscureText: obsCheck1,
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
                                    child: const Icon(Icons.password)),
                              ),
                              labelText: 'Password',
                              suffixIcon: IconButton(onPressed: (){
                                setState(() {
                                  obsCheck1 = !obsCheck1;
                                });
                              }, icon: Icon( obsCheck1? Icons.visibility_off : Icons.visibility))
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your password';
                              } 
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          //selectLawyerType(),
                          const SizedBox(
                            height: 10,
                          ),
                          // TextFormField(
                          //   controller: _passwordController,
                          //   decoration: InputDecoration(
                          //       prefixIcon: Padding(
                          //         padding: const EdgeInsets.only(right: 5),
                          //         child: Container(
                          //             decoration: const BoxDecoration(
                          //               border: Border(
                          //                 right: BorderSide(
                          //                     width: 1.0, color: Colors.black),
                          //               ),
                          //             ),
                          //             child: const Icon(Icons.lock_open_rounded)),
                          //       ),
                          //       labelText: 'Password',
                          //       suffixIcon: IconButton(
                          //           onPressed: () {
                          //             setState(() {
                          //               obsCheck1 = !obsCheck1;
                          //             });
                          //           },
                          //           icon: Icon(obsCheck1
                          //               ? Icons.visibility
                          //               : Icons.visibility_off))),
                          //   obscureText: !obsCheck1,
                          //   validator: (value) {
                          //     if (value!.isEmpty) {
                          //       return 'Please enter a password';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // TextFormField(
                          //   controller: _confirmPasswordController,
                          //   decoration: InputDecoration(
                          //       prefixIcon: Padding(
                          //         padding: const EdgeInsets.only(right: 5),
                          //         child: Container(
                          //             decoration: const BoxDecoration(
                          //               border: Border(
                          //                 right: BorderSide(
                          //                     width: 1.0, color: Colors.black),
                          //               ),
                          //             ),
                          //             child: const Icon(Icons.lock_outline)),
                          //       ),
                          //       labelText: 'Confirm Password',
                          //       suffixIcon: IconButton(
                          //           onPressed: () {
                          //             setState(() {
                          //               obsCheck2 = !obsCheck2;
                          //             });
                          //           },
                          //           icon: Icon(obsCheck2
                          //               ? Icons.visibility
                          //               : Icons.visibility_off))),
                          //   obscureText: !obsCheck2,
                          //   validator: (value) {
                          //     if (value!.isEmpty) {
                          //       return 'Please confirm your password';
                          //     }
                          //     if (value != _passwordController.text) {
                          //       return 'Passwords do not match';
                          //     }
                          //     return null;
                          //   },
                          // ),
          
                          const SizedBox(
                            height: 10,
                          ),
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              if (state is AuthErrorState) {
                                return Text(state.error,
                                    style: const TextStyle(color: Colors.red));
                              }
                              return const SizedBox();
                            },
                          ),
                          const SizedBox(height: 10.0),
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          //   child: ElevatedButton(
                          //     onPressed: () async {
                          //       if (_formKey.currentState!.validate()) {
                          //         setState(() {
                          //           errMsg = "";
                          //           isLoading = true;
                          //         });
          
                          //         BlocProvider.of<AuthBloc>(context)
                          //             .add(SignUpEvent(AppUser(
                          //           email: _emailController.text,
                          //           firstName: _fNameController.text,
                          //           lastName: _lNameController.text,
                          //           password: _passwordController.text,
                          //           role: selectedRole,
                          //           company: selectedCom,
                          //           createdAt: DateTime.timestamp(),
                          //         )));
                          //       } else if (selectedRole == "") {
                          //         setState(() {
                          //           errMsg = "Please select type of lawyer";
                          //         });
                          //       }
                          //     },
                          //     style: ElevatedButton.styleFrom(
                          //       padding: EdgeInsets.fromLTRB(
                          //           size.width / 4,
                          //           size.height / 40,
                          //           size.width / 4,
                          //           size.height / 40),
                          //       shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(50)),
                          //     ),
                          //     child: isLoading
                          //         ? const CircularProgressIndicator(
                          //             color: Colors.white,
                          //           )
                          //         : const Text('Sign Up'),
                          //   ),
                          // ),
                          isLoading
                                  ? const SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircularProgressIndicator(
                                      ),
                                  ):
                          ElevatedButton(
                            onPressed: () {
                              if(_formKey.currentState!.validate()){
                                setState(() {
                                  isLoading = true;
                                });
                                AppUser user = AppUser(email: _emailController.text, 
                                firstName: _fNameController.text, lastName: _lNameController.text, 
                                password:  _passController.text, createdAt: DateTime.now());
                                BlocProvider.of<AuthBloc>(context).add(SignUpEvent(user));
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            child:const Text("Register")),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            },
                            child: const Text('Already have an account? Sign in'),
                          ),
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
