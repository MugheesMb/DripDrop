import 'package:flutter/material.dart';
import 'package:map_water/auth/ui/login_screen.dart';

import 'register_screen.dart';

class LoginSignupScreen extends StatelessWidget {
  static const routeName = "login-signup-screen";
  const LoginSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/water.jpg"), fit: BoxFit.cover)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(image: AssetImage("assets/dd.png"))
              ),),
            const SizedBox(height: 200,),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  color: Theme.of(context).primaryColor ),
              height: 200,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupScreen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white)
                            ),
                        width: 200,
                        height: 50,
                        child: const Center(
                            child: Text(
                          'Register',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        )),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white)
                          ),
                      width: 200,
                      height: 50,
                      child: const Center(
                          child: Text(
                        'Login',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      )),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
