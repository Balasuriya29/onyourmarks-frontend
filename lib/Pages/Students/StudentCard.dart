
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onyourmarks/staticNames.dart';

import '../../Utilities/components.dart';

class StudentCard extends StatefulWidget {
  const StudentCard({Key? key}) : super(key: key);

  @override
  State<StudentCard> createState() => _StudentCardState();
}

class _StudentCardState extends State<StudentCard> {
  Row displayTextAsRow(String field, String value){
    return Row(
      children: [
        Text(field),
        Text(" : "),
        Text(value),
      ],
    );
  }

  var _size1 = 0.0;
  var _size2 = 0.0;
  var _ratio = 0.0;
  var _height = 0.0;
  var _color_profile = Colors.transparent;
  var _flag = true;

  shrinkUp() async {
    await Future.delayed(Duration(milliseconds: 50), () {}
    ).then((value) async  {
      setState(() {
        _ratio = 0.15;
      });
      await Future.delayed(Duration(milliseconds: 1000), () {}
      ).then((value) async {
        setState(() {
          _height = 400;
          _size1 = 40.0;
          _size2 = 25.0;
        });
        await Future.delayed(Duration(milliseconds: 1000), () {

        }).then((value) => {
          setState(() {
            _color_profile = Colors.white;
          })
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    shrinkUp();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(APP_NAME),
      body: Center(
        child: Container(
          width: 300,
          height:1000,
          child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: <Widget>[
                Positioned(
                  top: MediaQuery.of(context).size.height * _ratio,
                  child: AnimatedSize(
                    curve: Curves.fastOutSlowIn,
                    duration: Duration(milliseconds: 1000),
                    child: Container(
                     width: 275,
                      child: Column(
                        children: [
                          Container(
                              height:_height,
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(20),
                                  border:Border.all(
                                    color: Colors.deepPurpleAccent,
                                  )
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: displayTextAsRow("Name", "Arun Kathick M"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: displayTextAsRow("Degree", "B E CSE"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: displayTextAsRow("Roll No", "201CS130"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: displayTextAsRow("DOB", "07.08.2002"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: displayTextAsRow("Gender", "Male"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: displayTextAsRow("Blood", "B+ve"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: displayTextAsRow("Email", "ark@gmail.com"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 8.0),
                                      child: displayTextAsRow("Phone", "8610505678"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Hidden data"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Hidden data"),
                                    ),
                                    Center(
                                      child: IconButton(
                                          onPressed: (){
                                            setState(() {
                                              if(_flag)  _height += 200;
                                              else  _height -= 200;
                                              _flag = !_flag;
                                            });
                                          }, icon: Icon(
                                          Icons.keyboard_arrow_down_sharp)

                                      ),
                                    )
                                  ],
                                ),
                              )
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 30,
                  top: MediaQuery.of(context).size.height * 0.1,
                  child: AnimatedSize(
                    curve: Curves.bounceInOut,
                    duration: Duration(seconds: 2),
                    child: CircleAvatar(
                      child: Icon(
                        CupertinoIcons.person_circle_fill,
                        size: 80.0,
                        color: _color_profile,
                      ),
                      radius: _size1,
                    ),
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}
