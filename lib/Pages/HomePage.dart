import 'dart:convert';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:onyourmarks/Pages/rssScreen.dart';
import 'package:onyourmarks/Utilities/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utilities/Components/functional.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.role,
  }) : super(key: key);
  final role;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> imgLists = [
    'Images/Image-HomePage-1.png',
    'Images/Image-HomePage-2.png',
    'Images/Image-HomePage-3.png'
  ];
  var name;
  var isFetching = true;
  getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(widget.role == "Student") {
      var me = jsonDecode(
          preferences.getString("student-personalDetails").toString());
      name = me["first_name"] + " " + me["last_name"];
    }
    else{
      var me = jsonDecode(
          preferences.getString("teacher-personalDetails").toString());
      name = me["name"];
    }
    // print(name);
      setState(() {
        isFetching = false;
      });
  }

  @override
  void initState() {
    getName();
  }

  getImageSliderForStudent(){
    return getImageSlider(imgLists);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        placeASizedBoxHere(30),
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 2.0,
            enlargeCenterPage: true,
          ),
          items: getImageSliderForStudent(),
        ),
        placeASizedBoxHere(30),
        Padding(
          padding: const EdgeInsets.only(left: 35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(texts[6]+name.toString()+"!", style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),),
              Text(texts[7], style: TextStyle(
                fontWeight: FontWeight.w500,
              ),),
            ],
          )
        ),
        // placeASizedBoxHere(0),
        rssScreen(),
      ],
    );
  }
}
