// ignore_for_file: camel_case_types

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_snap/models/user.dart' as model;
import 'package:tech_snap/providers/user_provider.dart';
import 'package:tech_snap/utils/colors.dart';
import 'package:tech_snap/utils/globals.dart';

class mobileScreenLayout extends StatefulWidget {
  const mobileScreenLayout({super.key});

  @override
  State<mobileScreenLayout> createState() => _mobileScreenLayoutState();
}

class _mobileScreenLayoutState extends State<mobileScreenLayout> {
  String username="";
  int _page=0;
  late PageController pageController;
  @override
  void initState()
  {
    super.initState();
    pageController=PageController();
  }
  @override
  void dispose() {
   super.dispose();
   pageController.dispose();
  }
  void onPageChanged(int page)
{
  setState(() {
    _page=page;
  });
}
void navigationTapped(int page)
{
pageController.jumpToPage(page);
}
  @override
  Widget build(BuildContext context) {
    model.User user=Provider.of<Userprovider>(context).getUser;
    return  Scaffold(
      
      backgroundColor: mobileBackgroundColor,
      
      body:PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children:homeScreenItems,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: SafeArea(
        
        child:CurvedNavigationBar(
          backgroundColor: mobileBackgroundColor,
          buttonBackgroundColor: const Color.fromARGB(255, 255, 240, 219),
          color: const Color.fromARGB(255, 255, 240, 219),
          height: 65,
          items: const <Widget>[
            Icon(
              Icons.home,
              size: 35,
              color:mobileBackgroundColor,
            ),
            Icon(
              Icons.search,
              size: 35,
              color: mobileBackgroundColor,
            ),
            Icon(
              Icons.add,
              size: 35,
              color: mobileBackgroundColor,
            ),
             
             Icon(
              Icons.lightbulb,
              size: 35,
              color: mobileBackgroundColor,
            ),
            Icon(
              Icons.person,
              size: 35,
              color: mobileBackgroundColor,
            ),
           
          ],
          onTap:navigationTapped,
          
          
        ),
      ),
      
    );
  }
}
//reduce calls to db so we r gonna use provider pkg