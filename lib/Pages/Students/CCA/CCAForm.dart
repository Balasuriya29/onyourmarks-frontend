import 'package:flutter/material.dart';
import 'package:onyourmarks/Pages/Students/StudentHome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:intl/intl.dart';
import '../../../ApiHandler/Student/CCAAPIs.dart';
import '../../../Utilities/components.dart';

class StudentCCAForm extends StatefulWidget {
  const StudentCCAForm({Key? key}) : super(key: key);

  @override
  State<StudentCCAForm> createState() => _StudentCCAFormState();
}

class _StudentCCAFormState extends State<StudentCCAForm> {
  TextEditingController actNameController = TextEditingController();
  var actTypeController = "Choose...";
  var actStatusController = "Choose...";
  TextEditingController actStartController = TextEditingController();
  TextEditingController actEndController = TextEditingController();

  var actNameValidator = false;
  var actStartValidator = false;
  var actEndValidator = false;
  var actTypeValidator = false;
  var actStatusValidator = false;

  List dropdownItemListForTypeOfActivity = [
    {'label': 'Choose...', 'value': 'Choose...'},
    {'label': 'Technical', 'value': 'Technical'},
    {'label': 'Non-Technical', 'value': 'Non-Technical'},
    {'label': 'Sports', 'value': 'Sports'},
  ];

  List dropdownItemListForTypeOfStatus = [
    {'label': 'Choose...', 'value': 'Choose...'},
    {'label': 'Participation', 'value': 'Participation'},
    {'label': 'Winner', 'value': 'Winner'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Co-Curricular Activity Form"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  color: Colors.blueGrey.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Activity Name", style: TextStyle(fontSize: 15),),
                        TextField(
                          decoration: InputDecoration(
                            errorText: (actNameValidator)?"Invalid":null,
                            hintText: "Enter"
                          ),
                          controller: actNameController,
                          onChanged: (s){
                            actNameValidator = false;
                            setState(() {

                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 160,
                        color: Colors.blueGrey.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Activity Type", style: TextStyle(fontSize: 15),),
                              SizedBox(
                                height: 10,
                              ),
                              CoolDropdown(
                                dropdownWidth: 150,
                                dropdownHeight: 200,
                                dropdownList: dropdownItemListForTypeOfActivity,
                                onChange: (_) {
                                  actTypeValidator = false;
                                  actTypeController = _["value"];
                                  setState(() {

                                  });
                                },
                                defaultValue: dropdownItemListForTypeOfActivity[0],
                                // placeholder: 'insert...',
                              ),
                              (actTypeValidator)?Text("Invalid", style: TextStyle(color: Colors.red),):Text("")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 160,
                        color: Colors.blueGrey.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Status", style: TextStyle(fontSize: 15),),
                              SizedBox(
                                height: 10,
                              ),
                              CoolDropdown(
                                resultWidth: 150,
                                dropdownHeight: 200,
                                dropdownList: dropdownItemListForTypeOfStatus,
                                onChange: (_) {
                                  actStatusValidator = false;
                                  actStatusController = _["value"];
                                  setState(() {

                                  });
                                },
                                defaultValue: dropdownItemListForTypeOfStatus[0],
                                // placeholder: 'insert...',
                              ),
                              (actStatusValidator)?Text("Invalid", style: TextStyle(color: Colors.red),):Text("")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 150,
                        color: Colors.blueGrey.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Start Date", style: TextStyle(fontSize: 15),),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                onChanged: (s){
                                  actStartValidator = false;
                                  setState(() {

                                  });
                                },
                                controller: actStartController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(8),
                                  hintText: 'Select',
                                  errorText: (actStartValidator)?"Invalid":null
                                ),
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1500),
                                      lastDate: DateTime(2101));

                                  if (pickedDate != null) {
                                    String formattedDate =
                                    DateFormat('yyyy-MM-dd')
                                        .format(pickedDate);


                                    setState(() {
                                      actStartController.text =
                                          formattedDate;
                                      actStartValidator = false;
                                    });
                                  }

                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 150,
                        color: Colors.blueGrey.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("End Date", style: TextStyle(fontSize: 15),),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: actEndController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(8),
                                  hintText: 'Select',
                                  errorText: (actEndValidator)?"Invalid":null
                                ),
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1500),
                                      lastDate: DateTime(2101));

                                  if (pickedDate != null) {
                                    // print(pickedDate);
                                    String formattedDate =
                                    DateFormat('yyyy-MM-dd')
                                        .format(pickedDate);
                                    // print(formattedDate);

                                    setState(() {
                                      actEndController.text =
                                          formattedDate;
                                      // print(actEndValidator);
                                      actEndValidator = false;
                                      // print(actEndValidator);
                                    });
                                  }
                                  else {
                                    // print("Date is not selected");
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onFocusChange: (value) {

                  },
                  onPressed: () async {
                    var check = true;
                    if(actNameController.text == "") {
                      actNameValidator = true;
                      check = false;
                    }
                    if(actStartController.text == "") {
                      actStartValidator = true;
                      check = false;
                    }
                    if(actEndController.text == "") {
                      actEndValidator = true;
                      check = false;
                    }
                    if(actStatusController == "Choose...") {
                      actStatusValidator = true;
                      check = false;
                    }
                    if(actTypeController == "Choose...") {
                      actTypeValidator = true;
                      check = false;
                    }

                    if(check){
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                      await postActivity(preferences.get("id").toString(),actNameController.text,actTypeController,actStatusController,actStartController.text.substring(0,10),actEndController.text.substring(0,10)).then((v)  {
                        setState(() {

                        });
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentHome(3)));
                      });
                    }

                  },
                  child: Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }
}
