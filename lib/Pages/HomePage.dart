import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:onyourmarks/Pages/rssScreen.dart';

import '../Utilities/components.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> imgLists = [
    'https://image2.commarts.com/images1/3/8/8/0/1/1088327_102_600_LTE4NDY1MTQ3OTMtOTkyODgyMzc0.jpg',
    'https://www.infodesigners.eu/immagine_coppia/Art-On-Climate-2022-International-Illustration-Competition.png',
    'https://img.freepik.com/free-vector/teams-competing-prize-people-playing-tug-war-pulling-rope-with-golden-cup-flat-vector-illustration-competition-contest-concept_74855-10163.jpg?w=2000',
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
        placeASizedBoxHere(50)
      ],
    );
  }
}
