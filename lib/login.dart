import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'mainpage.dart';
import 'verifyemail.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool verified = false;
  bool passwordVisible = false;
  bool isLoading = false;
  String? errorMessage;
  String? errorTitle;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        checkVerified();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'invalid-email') {
          errorTitle = "Incorrect Email";
          errorMessage = "Incorrect email. Please enter a valid email address.";
        } else if (e.code == 'wrong-password') {
          errorTitle = "Incorrect Password";
          errorMessage = "Incorrect password. Please enter the correct password.";
        } else {
          errorTitle = "Error";
          errorMessage = "An error occurred. Please try again.";
        }
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(errorTitle!),
              content: Text(errorMessage!),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> resetPassword() async {
    if (emailController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("No Email"),
            content: Text("Please enter your email address."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Email Sent"),
            content: Text("Password reset email has been sent. Check your inbox."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          if (e.code == 'user-not-found') {
            errorTitle = "Incorrect Credentials";
            errorMessage = "Incorrect credentials. Please enter a valid credentials.";
          } else if (e.code == 'invalid-email') {
            errorTitle = "Incorrect Email";
            errorMessage = "Incorrect Email. Please enter a valid email.";
          } else if (e.code == 'invalid-password') {
            errorTitle = "Incorrect password";
            errorMessage = "Incorrect password. Please enter a valid password.";
          } else {
            errorTitle = "Error";
            errorMessage = "An error occurred. Please try again.";
          }
          return AlertDialog(
            title: Text(errorTitle!),
            content: Text(errorMessage!),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> checkVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      verified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (verified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ZodiacPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => verifyEmail()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(                         //Login Title
          'Login',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Container(                      //Background image
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 200),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(                //Email Field
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
                  validator: (email) => email != null && !EmailValidator.validate(email)
                      ? 'Enter a valid email'
                      : null,
                ),
                SizedBox(height: 30),
                TextFormField(           //Password Field
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
                        passwordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
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
                GestureDetector(                 //Forgot Password
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                    ),
                  ),
                  onTap: resetPassword,
                ),
                SizedBox(height: 75),
                Container(                   //Login Button
                  width: 150,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : () async {
                      await signIn();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                        'Login',
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
      ),
    );
  }
}
