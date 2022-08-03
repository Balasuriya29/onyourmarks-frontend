import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Utilities/components.dart';
import 'MyDetails.dart';
import 'MyTeachers.dart';

class ProfileStudent extends StatefulWidget {
  const ProfileStudent({Key? key}) : super(key: key);

  @override
  State<ProfileStudent> createState() => _ProfileStudentState();
}

class _ProfileStudentState extends State<ProfileStudent> {

  List<Text> optionsName = [
    Text(
        "My Details",
      style: TextStyle(
        fontSize: 17
      ),
    ),
    Text(
        "My Teachers",
      style: TextStyle(
          fontSize: 17
      ),
    ),
    Text(
        "Settings",
      style: TextStyle(
          fontSize: 17
      ),
    ),
    Text(
        "Log Out",
      style: TextStyle(
          fontSize: 17
      ),
    )
  ];
  List<Icon> optionsIcons = [
    Icon(
        CupertinoIcons.profile_circled,
        size: 40,
      color: Colors.deepPurple,
    ),
    Icon(
        CupertinoIcons.person_crop_rectangle_fill,
      size: 30,
      color: Colors.deepPurple,
    ),
    Icon(
        Icons.settings,
      color: Colors.deepPurple,
      size: 30,
    ),
    Icon(
        Icons.logout,
      color: Colors.deepPurple,
      size: 30,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar( "Profile"),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: "ProfilePic",
                child: CircleAvatar(
                  radius: 60,
                  child:  Icon(
                      CupertinoIcons.profile_circled,
                    size: 100,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.separated(itemBuilder: (BuildContext context,int index){
              return GestureDetector(
                  onTap: (){
                    (optionsName.elementAt(index).data == "My Details")
                        ?Navigator.push(context, MaterialPageRoute(builder: (context) => MyDetails()))
                        :(optionsName.elementAt(index).data == "My Teachers")
                            ?Navigator.push(context, MaterialPageRoute(builder: (context) => MyTeachers()))
                            :null;
                  },
                  child: Padding(
                  padding: const EdgeInsets.only(top: 28.0,left: 28.0,right: 28.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.blueGrey.shade50,
                      height: 80,
                      child: Row(
                        children: [

                          getExpanded(3, optionsIcons.elementAt(index)),
                          getExpanded(5, optionsName.elementAt(index)),
                          getExpanded(1, Text("")),
                          getExpanded(2, Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.grey,
                            )
                          ),

                        ],
                      ),
                    ),
                  ),
                )
              );
            }, separatorBuilder: (BuildContext context,int index){
              return SizedBox(
                height: 10,
              );
            }, itemCount: optionsName.length),
          )
        ],
      ),
    );
  }
}
