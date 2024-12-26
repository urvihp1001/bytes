
// ignore_for_file: prefer_final_fields, use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tech_snap/resources/auth_methods.dart';
import 'package:tech_snap/responsive/mobile_screen_layout.dart';
import 'package:tech_snap/responsive/responsive_layout_screen.dart';
import 'package:tech_snap/responsive/web_screen_layout.dart';
import 'package:tech_snap/screens/signup_screen.dart';
import 'package:tech_snap/utils/colors.dart';
import 'package:tech_snap/widgets/glass_morph.dart';
import 'package:tech_snap/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  bool _isLoading=false;
 @override
 void dispose()
 {
  super.dispose();
  emailController.dispose();
  passwordController.dispose();
 }
 void loginUser() async
 {
  setState(() {
    _isLoading=true;
  });
  String res= await AuthMethods().loginUser(email: emailController.text, password: passwordController.text);
  if(res=="success"){

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const ResponsiveLayout(webScreenLayout: webScreenLayout(), mobileScreenLayout: mobileScreenLayout())
      )
      );
  
  }

 }
 void navigateToSignup(){
  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignupScreen()));
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      SafeArea(child:
      Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/city.jpg'),
            fit: BoxFit.cover
            )
          ),
        //padding so that textfield doesnt take up full width
        padding: EdgeInsets.symmetric(horizontal: 32),
        width:double.infinity,//full width of the device
      
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,//center in row format
          //mainaxis is for column format
          
          children: [
            Spacer(flex: 2,),
           GlassmorphicContainer(
            
            child: Padding(padding: 
           EdgeInsets.all(16),
           child:Column(
             crossAxisAlignment: CrossAxisAlignment.center,//center in row format
          //mainaxis is for column format
          
          children: [
 SvgPicture.asset("assets/bytes.svg",
            color: Colors.blueGrey[50],
            height:64),
            //txt field for email
            const SizedBox(height:48),
            TextFieldInput(textEditingController: emailController, hintText: 'Enter your email', textInputType:TextInputType.emailAddress,),
            const SizedBox(height:24),
            TextFieldInput(textEditingController: passwordController, hintText: 'Enter your password', textInputType:TextInputType.text, isPass: true,),
              const SizedBox(height:24),

            //txt field for password
            InkWell(
              onTap: loginUser,
              child:Container(
             width:double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical:12),
              decoration: ShapeDecoration(shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))
                ),
                color:blueColor,
                ),
             child:_isLoading?Center(child:const CircularProgressIndicator(color: primaryColor,)): Text("Sign In"),
            ),
            ),
            const SizedBox(height:12),
          ],
           ),
           ),
           ),
            //login button
            Flexible(flex:2, child: Container()),//for space
            //row for side by side-> sign up/ login 
            Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text("Don't have an account? ")
            ),
            GestureDetector(
              onTap: navigateToSignup,
              child:Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text("Sign up.", style:TextStyle(fontWeight: FontWeight.bold))
            ),
            )
            ],
           
           )
           
          ],
           ),
            //svg image
            )
            //transitioning to sign out- forgot password type thing
        ),
        
      
    );
  }
} 