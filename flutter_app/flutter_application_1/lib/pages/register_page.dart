import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/storage_service_supa.dart';
import 'package:flutter_application_1/utils/utils.dart';
import 'package:flutter_application_1/widgets/text_field.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final usernameController = TextEditingController();
  final countryController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    usernameController.dispose();
    countryController.dispose();
    super.dispose();
  }

  void showErrorMessage(String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              msg,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Future addUserDetails(
    String username,
    String uid,
    String email,
    String? photoUrl,
    String country,
  ) async {
    User newUser = User(
      username: username,
      uid: uid,
      email: email,
      photoUrl: photoUrl,
      country: country,
      followers: [],
      following: [],
      coins: 0,
    );
    await FirebaseFirestore.instance.collection('users').doc(uid).set(newUser.toMap());
  }

  Future<void> selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  Future<void> signUserUp(BuildContext context) async {
  if (!context.mounted) return; // Prevent running if widget is deactivated

  setState(() {
    _isLoading = true;
  });

  final email = emailController.text.trim();
  final password = passwordController.text.trim();
  final confirmPassword = confirmpasswordController.text.trim();
  final username = usernameController.text.trim();
  final country = countryController.text.trim();

  if (password != confirmPassword) {
    if (context.mounted) showErrorMessage("Passwords do not match!");
    setState(() => _isLoading = false);
    return;
  }

  if (_image == null) {
    if (context.mounted) showErrorMessage("Please select a profile image.");
    setState(() => _isLoading = false);
    return;
  }

  try {
    Auth.UserCredential userCredential =
        await Auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    String uid = userCredential.user!.uid;
    String? photoUrl = await StorageMethods().uploadImage(context, 'profilePics', _image!);

    if (photoUrl == null) {
      if (context.mounted) showErrorMessage("Image upload failed. Try again.");
      setState(() => _isLoading = false);
      return;
    }

    await addUserDetails(username, uid, email, photoUrl, country);

    if (context.mounted) Navigator.pop(context); // Navigate back on success
    } on Auth.FirebaseAuthException catch (e) {
      if (context.mounted) showErrorMessage(e.message.toString());
    } finally {
      if (context.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.1),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20.0),

                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 64,
                          backgroundImage: _image != null
                              ? MemoryImage(_image!)
                              :  const NetworkImage(
                                  'https://i.stack.imgur.com/l60Hf.png') as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(Icons.add_a_photo, color: Colors.deepPurple),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10.0),

                    const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    buildInputField(
                      controller: emailController,
                      label: 'Email',
                      icon: Icons.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),

                    buildInputField(
                      controller: usernameController,
                      label: 'User Name',
                      icon: Icons.person,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'User name required' : null,
                    ),

                    buildInputField(
                      controller: countryController,
                      label: 'Country',
                      icon: Icons.flag,
                    ),

                    buildPasswordField(
                      controller: passwordController,
                      label: 'Password',
                      isVisible: _isPasswordVisible,
                      toggleVisibility: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),

                    buildPasswordField(
                      controller: confirmpasswordController,
                      label: 'Confirm Password',
                      isVisible: _isConfirmPasswordVisible,
                      toggleVisibility: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),

                    const SizedBox(height: 20.0),

                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () => signUserUp(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple[100],
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text('Sign Up'),
                          ),

                    const SizedBox(height: 20.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            ' Login now',
                            style: TextStyle(color: Colors.deepPurpleAccent),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
