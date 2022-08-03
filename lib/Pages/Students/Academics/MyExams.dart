import 'package:flutter/material.dart';
import '../../../ApiHandler/Student/StudentsAPIs.dart';
import '../../../Utilities/components.dart';
import '../../../Models/Student Models/ExamModel.dart';
import 'SubjectsScreen.dart';

class MyExams extends StatefulWidget {
  const MyExams({Key? key}) : super(key: key);

  @override
  State<MyExams> createState() => _MyExamsState();
}

class _MyExamsState extends State<MyExams> with TickerProviderStateMixin{
  late TabController _tabController = TabController(length: 3, vsync: this);
  List<ExamModel> exams = [];
  List<ExamModel> upcoming = [];
  List<ExamModel> inProgress = [];
  List<ExamModel> finished = [];
  bool isFetching = true;
  getExamsFunc() async {
    exams = await getMyExams();
    for(var i in exams){
      (i.status == 'upcoming')
          ?upcoming.add(i)
          :(i.status == 'in progress')
          ?inProgress.add(i)
          :finished.add(i);
    }
    setState(() {
      isFetching = false;
      // print("Upcoming"+upcoming.toString());
      // print("in p"+inProgress.toString());
      // print("finished"+finished.toString());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("My Exams"),
      body: (isFetching)
        ?loadingPage()
        :Column(
        children: [
          DefaultTabController(length: 3, child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.black54,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                text: 'Upcoming',
              ),
              Tab(
                text: 'In Progress',
              ),
              Tab(
                text: 'Finished',
              )
            ],
          )),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: TabBarView(
              controller: _tabController,
              children: [
                (upcoming.isEmpty)?getCenterText("No Upcoming Exams"):ListView.builder(
                    itemBuilder: (BuildContext context,int index){
                  return GestureDetector(
                    child: Card(
                      child: Container(
                        height: 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(upcoming.elementAt(index).examName.toString(),style: TextStyle(fontSize: 20),),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SubjectsScreen(upcoming.elementAt(index).subjects),));
                    },
                  );
                },
                itemCount: upcoming.length,
                ),
                (inProgress.isEmpty)?getCenterText("No exams in progress"):ListView.builder(
                  itemBuilder: (BuildContext context,int index){
                    return GestureDetector(
                      child: Card(
                        child: Container(
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(inProgress.elementAt(index).examName.toString(),style: TextStyle(fontSize: 20),),
                                ),
                              ],
                            ),
                        ),
                      ),
                      onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SubjectsScreen(inProgress.elementAt(index).subjects)));
                      },
                    );
                  },
                  itemCount: inProgress.length,
                ),
                (finished.isEmpty)?getCenterText("No exams to show"):ListView.builder(
                  itemBuilder: (BuildContext context,int index){
                    return GestureDetector(
                      child: Card(
                        child: Container(
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(finished.elementAt(index).examName.toString(),style: TextStyle(fontSize: 20),),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SubjectsScreen(finished.elementAt(index).subjects)));
                      },
                    );
                  },
                  itemCount: finished.length,
                ),
              ],
            ),
          ))
        ],
      )
    );
  }
  Widget getCenterText(String text){
    return Center(
      child: Text(text),
    );
  }
  @override
  void initState() {
    getExamsFunc();
  }
}
