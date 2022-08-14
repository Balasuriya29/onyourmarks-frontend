import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:onyourmarks/Pages/rssScreen.dart';

import '../Utilities/Components/functional.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> imgLists = [
    'Images/Image-HomePage-1.png',
    'Images/Image-HomePage-2.png',
    'Images/Image-HomePage-3.png'
  ];

  getImageSliderForStudent(){
    return getImageSlider(imgLists);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        rssScreen(),
      ],
    );
  }
}
