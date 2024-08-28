import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'verifyemail.dart';

class SignupPage extends StatefulWidget {
  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  bool passwordVisible = false;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    if (formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => verifyEmail()),
        );
      } on FirebaseAuthException {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Signup',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Container(          //Background
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.only(top: 150, left: 50, right: 50),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(                    //Email Field
                controller: emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.white),
                  suffixIcon: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                email != null && !EmailValidator.validate(email)
                    ? 'Enter a valid email'
                    : null,
              ),
              SizedBox(height: 30),
              TextFormField(                             //Password Field
                controller: passwordController,
                style: TextStyle(color: Colors.white),
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                        color: Colors.white,
                        passwordVisible ? Icons.visibility : Icons.visibility_off
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? 'Password should be longer than 6 characters'
                    : null,
              ),
              SizedBox(height: 30),
              TextFormField(                              //Confirm Password Field
                style: TextStyle(color: Colors.white),
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  hintText: 'Re-Enter Password',
                  hintStyle: TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                        color: Colors.white,
                        passwordVisible ? Icons.visibility : Icons.visibility_off
                    ),
                    onPressed: () {
                      setState(
                            () {
                          passwordVisible = !passwordVisible;
                        },
                      );
                    },
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != passwordController.text
                    ? 'The password does not match the entered one.'
                    : null,
              ),
              SizedBox(height: 75),
              Container(                      //Signup Button
                width: 150,
                child: ElevatedButton(
                  onPressed: () async {
                    await signUp();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'SignUp',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
