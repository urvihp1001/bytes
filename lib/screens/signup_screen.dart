// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, sized_box_for_whitespace

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tech_snap/resources/auth_methods.dart';
import 'package:tech_snap/responsive/mobile_screen_layout.dart';
import 'package:tech_snap/responsive/responsive_layout_screen.dart';
import 'package:tech_snap/responsive/web_screen_layout.dart';
import 'package:tech_snap/screens/login_screen.dart';
import 'package:tech_snap/utils/colors.dart';
import 'package:tech_snap/utils/utils.dart';
import 'package:tech_snap/widgets/glass_morph.dart';
import 'package:tech_snap/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController bioController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    super.dispose();
    bioController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    _pageController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: emailController.text,
        password: passwordController.text,
        username: usernameController.text,
        bio: bioController.text,
        file: _image!);
    setState(() {
      _isLoading = false;
    });

    if (res != "success") {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              webScreenLayout: webScreenLayout(),
              mobileScreenLayout: mobileScreenLayout())));
    }
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/city.jpg'), fit: BoxFit.cover)),
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(flex: 2), //up balance padding center
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.7,
                child: GlassmorphicContainer(
                  
                  child: PageView(
                    controller: _pageController,
                    children: [
                      buildFirstPage(),
                      buildSecondPage(),
                    ],
                  ),
                ),
              ),
              Spacer(flex: 2),//down balance padding center
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text("Already have an account? "),
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Log in.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFirstPage() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            "assets/bytes.svg",
            color: Colors.blueGrey[50],
            height: 64,
          ),
          SizedBox(height: 48),
          TextFieldInput(
            textEditingController: emailController,
            hintText: 'Enter your email',
            textInputType: TextInputType.emailAddress,
          ),
          SizedBox(height: 24),
          TextFieldInput(
            textEditingController: passwordController,
            hintText: 'Enter your password',
            textInputType: TextInputType.text,
            isPass: true,
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                },
                child: Text("Next"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSecondPage() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              _image != null
                  ? CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_image!),
                    )
                  : CircleAvatar(
                      radius: 64,
                      backgroundColor: Colors.grey[200],
                      child: Icon(
                        Icons.person,
                        size: 64,
                        color: Colors.grey[800],
                      ),
                    ),
              Positioned(
                bottom: -10,
                left: 80,
                child: IconButton(
                  icon: Icon(Icons.add_a_photo),
                  onPressed: selectImage,
                ),
              )
            ],
          ),
          SizedBox(height: 24),
          TextFieldInput(
            textEditingController: usernameController,
            hintText: 'Enter your username',
            textInputType: TextInputType.text,
          ),
          SizedBox(height: 24),
          TextFieldInput(
            textEditingController: bioController,
            hintText: 'Enter your bio',
            textInputType: TextInputType.text,
          ),
          SizedBox(height: 24),
          InkWell(
            onTap: signUpUser,
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                color: blueColor,
              ),
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      color: primaryColor,
                    ))
                  : Text("Sign Up"),
            ),
          ),
        ],
      ),
    );
  }
}
