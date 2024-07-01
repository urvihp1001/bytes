// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_snap/providers/user_provider.dart';
import 'package:tech_snap/responsive/mobile_screen_layout.dart';
import 'package:tech_snap/responsive/responsive_layout_screen.dart';
import 'package:tech_snap/responsive/web_screen_layout.dart';
import 'package:tech_snap/screens/login_screen.dart';
import 'package:tech_snap/screens/signup_screen.dart';
//import 'package:flutter/widgets.dart';
import 'package:tech_snap/utils/colors.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb)
  {
    await Firebase.initializeApp(
    options:const FirebaseOptions(
    apiKey: "AIzaSyCrHgWS96sn4fRRJ-Q1Vowku10htFo9-9w", 
    appId: "1:831630626654:web:0f4a350f42ba19a17e09cf",
    messagingSenderId: "831630626654",
   
    projectId: "infortech-15683",
    storageBucket: "infortech-15683.appspot.com",
   
    ),
    );
  }else{
await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers:[
      ChangeNotifierProvider(create: (_)=>Userprovider())
    ],//bigger app more providers
    child: MaterialApp(
      title: 'tech_snap',
      theme: ThemeData.dark().copyWith(
       
      ),
      debugShowCheckedModeBanner: false,
      /*home: */
        //persisting user auth
        //home:StreamBuilder(stream: FirebaseAuth.instance.idTokenChanges(), //we dont want to go back to auth
        home:StreamBuilder(stream:FirebaseAuth.instance.authStateChanges() ,builder:(context, snapshot) {
          if(snapshot.connectionState==ConnectionState.active){
            if(snapshot.hasData){
      ResponsiveLayout(
        mobileScreenLayout:mobileScreenLayout(),
        webScreenLayout:webScreenLayout() ,);
            }else if(snapshot.hasError){
              return Center(child:Text('${snapshot.error}'));
            }
          }
          if(snapshot.connectionState==ConnectionState.waiting)
          {
 return Center(child:CircularProgressIndicator(
  color: primaryColor,
 ));
          }
          return LoginScreen();
        },),
    ),  
    );
      //userchanges - forget password functionality
      
  }

}


