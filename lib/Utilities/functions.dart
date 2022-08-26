import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onyourmarks/Utilities/staticNames.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import 'dart:convert';

import '../Pages/Students/StudentHome.dart';
import '../Pages/Teachers/TeacherHome.dart';
import '../../Models/Student Models/UserModel.dart';
import 'staticNames.dart';

List<String> texts = [
  APP_NAME,
  "Username",
  "Password",
  "Login",
  'Home',
  "Invalid",
  "Hey ",
  "You gotta check this 😉",
  "NAME",
  "ROLL NO",
  "STANDARD",
  "GENDER",
  "FATHER NAME",
  "ADDRESS",
  "PHONE NO",
  "DASHBOARD",
  "INDIVIDUAL STUDENT ANALYSIS",
  'Attendance Percentage',
  "CURRENT EXAM STATUS",
  "NAME        : ",
  "ROLL NO : ",
  "PERFORMANCE",
  "Teachers",
  "STANDARD : ",
  "EXAMS",
  "FIND YOUR EXAMS HERE!!!",
  "Upcoming Exam for you is: ",
  "Results",
  "HERE'S YOUR MARKS",
  "No Results to Show",
  "From : ",
  "To      : ",
  "Co-Curricular Activity",
  "POST YOUR TALENT",
  "Pending",
  "Accepted",
  "Rejected",
  "Actitities Yet To Be Submitted😅",
  "Actitities Yet To Be Accepted😕",
  "No Activities are Rejected😉",
  "Weekly TimeTable",
  "SEE THE SCHEDULE COMING!",
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Maths",
  "Physics",
  "English",
  "Tamil",
  "Chemistry",
  "Biology",
  "Physical Education",
  "Please Rotate your Device",
  "Tasks",
  "Love to study",
  "Please Select A Date!",
  "Select A Date",
  "No Tasks Assigned",
  "Attendance",
  "STUDENT ATTENDANCE CALENDAR",
  "Attendance Updates At 10:00AM",
  "Present",
  "Absent",
  "Holiday",
  "Profile",
  "YOUR DETAILS",
  "ProfilePic",
  "Roll No",
  "Name",
  'Student DashBoard',
  'My Class Teachers',
  'My Exams',
  'My Marks',
  'My CCA',
  'TimeTable',
  'Homework',
  'Attendance',
  "No Chat History... Add New!",
  "Search",
  "New Chats",
  "FIND YOUR TEACHERS",
  "My Chats", //84
  "Settings",
  "CHANGE THE LOOKS",
  "Personal Identification",
  "Date Of Birth : ",
  "Gender: ",
  "Blood Group: ",
  "Mother Tongue: ", //91
  "Personal Details",
  "Father's Name: ",
  "Mother's Name: ",
  "Occupation: ",
  "Income: ",
  "Other Details", //97
  "Permanent Address : ",
  "Current Address : ",
  "Phone No: ",
  "Email: ",
  'Settings',
  "Do you want to log out?",
  "YES",
  "NO",
  'Log Out',
  "Participated",
  "Winner",
  "Language"
];

var lang = {
  "English": [
    APP_NAME,
    "Username",
    "Password",
    "Login",
    'Home',
    "Invalid",
    "Hey ",
    "You gotta check this 😉",
    "NAME",
    "ROLL NO",
    "STANDARD",
    "GENDER",
    "FATHER NAME",
    "ADDRESS",
    "PHONE NO",
    "DASHBOARD",
    "INDIVIDUAL STUDENT ANALYSIS",
    'Attendance Percentage',
    "CURRENT EXAM STATUS",
    "NAME        : ",
    "ROLL NO : ",
    "PERFORMANCE",
    "Teachers",
    "STANDARD : ",
    "EXAMS",
    "FIND YOUR EXAMS HERE!!!",
    "Upcoming Exam for you is: ",
    "Results",
    "HERE'S YOUR MARKS",
    "No Results to Show",
    "From : ",
    "To      : ",
    "Co-Curricular Activity",
    "POST YOUR TALENT",
    "Pending",
    "Accepted",
    "Rejected",
    "Actitities Yet To Be Submitted😅",
    "Actitities Yet To Be Accepted😕",
    "No Activities are Rejected😉",
    "Weekly TimeTable",
    "SEE THE SCHEDULE COMING!",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Maths",
    "Physics",
    "English",
    "Tamil",
    "Chemistry",
    "Biology",
    "Physical Education",
    "Please Rotate your Device",
    "Tasks",
    "Love to study",
    "Please Select A Date!",
    "Select A Date",
    "No Tasks Assigned",
    "Attendance",
    "STUDENT ATTENDANCE CALENDAR",
    "Attendance Updates At 10:00AM",
    "Present",
    "Absent",
    "Holiday",
    "Profile",
    "YOUR DETAILS",
    "ProfilePic",
    "Roll No",
    "Name",
    'Student DashBoard',
    'My Class Teachers',
    'My Exams',
    'My Marks',
    'My CCA',
    'TimeTable',
    'Homework',
    'Attendance',
    "No Chat History... Add New!",
    "Search",
    "New Chats",
    "FIND YOUR TEACHERS",
    "My Chats", //84
    "Settings",
    "CHANGE THE LOOKS", //86
    "Personal Identification",
    "Date Of Birth : ",
    "Gender: ",
    "Blood Group: ",
    "Mother Tongue: ", //91
    "Personal Details",
    "Father's Name: ",
    "Mother's Name: ",
    "Occupation: ",
    "Income: ",
    "Other Details", //97
    "Permanent Address : ",
    "Current Address : ",
    "Phone No: ",
    "Email: ", //101
    'Settings',
    "Do you want to log out?",
    "YES",
    "NO",
    'Log Out',
    "Participated",
    "Winner",
    "Language"
  ],
  "Tamil": [
    "உங்கள் மதிப்பெண்களில்🏃‍♂️✍",
    "பயனர் பெயர்",
    "கடவுச்சொல்",
    "உள்நுழைய",
    'வீடு',
    "தவறானது",
    "ஏய் ",
    "நீங்கள் இதை சரிபார்க்க வேண்டும் 😉",
    "பெயர்",
    "ரோல் எண்",
    "தரநிலை",
    "பாலினம்",
    "தந்தையின் பெயர்",
    "முகவரி",
    "தொலைபேசி எண்",
    "டாஷ்போர்டு",
    "தனி மாணவர் பகுப்பாய்வு",
    'வருகை சதவீதம்',
    "தற்போதைய தேர்வு நிலை",
    "பெயர்:",
    "ரோல் எண்:",
    "செயல்திறன்",
    "ஆசிரியர்கள்",
    "தரநிலை : ",
    "தேர்வுகள்",
    "உங்கள் தேர்வுகளை இங்கே கண்டுபிடி!!!",
    "உங்களுக்கு வரவிருக்கும் தேர்வு:",
    "முடிவுகள்",
    "இதோ உங்கள் மதிப்பெண்கள்",
    "காட்ட முடிவுகள் இல்லை",
    "இருந்து :",
    "இதற்கு:",
    "இணை பாடத்திட்ட செயல்பாடு",
    "உங்கள் திறமையை பதிவிடுங்கள்",
    "நிலுவையில் உள்ளது",
    "ஏற்றுக்கொள்ளப்பட்டது",
    "நிராகரிக்கப்பட்டது",
    "இன்னும் சமர்ப்பிக்க வேண்டிய நடவடிக்கைகள்😅",
    "இன்னும் ஏற்றுக்கொள்ளப்படாத நடவடிக்கைகள்😕",
    "எந்த நடவடிக்கைகளும் நிராகரிக்கப்படவில்லை",
    "வார கால அட்டவணை",
    "வரவிருக்கும் அட்டவணையைப் பார்க்கவும்!",
    "திங்கட்கிழமை",
    "செவ்வாய்",
    "புதன்கிழமை",
    "வியாழன்",
    "வெள்ளி",
    "சனிக்கிழமை",
    "கணிதம்",
    "இயற்பியல்",
    "ஆங்கிலம்",
    "தமிழ்",
    "வேதியியல்",
    "உயிரியல்",
    "உடற்கல்வி",
    "தயவுசெய்து உங்கள் சாதனத்தைச் சுழற்றுங்கள்",
    "பணிகள்",
    "படிக்க விரும்புகிறேன்",
    "தயவுசெய்து ஒரு தேதியைத் தேர்ந்தெடுக்கவும்!",
    "தேதியைத் தேர்ந்தெடு",
    "பணிகள் எதுவும் ஒதுக்கப்படவில்லை",
    "வருகை",
    "மாணவர் வருகை காலண்டர்",
    "காலை 10:00 மணிக்கு வருகை பற்றிய அறிவிப்புகள்",
    "தற்போது",
    "இல்லாதது",
    "விடுமுறை",
    "சுயவிவரம்",
    "உங்கள் விவரங்கள்",
    "முகப்பு படம்",
    "ரோல் எண்",
    "பெயர்",
    'மாணவர் டாஷ்போர்டு',
    'எனது வகுப்பு ஆசிரியர்கள்',
    'எனது தேர்வுகள்',
    'என் மதிப்பெண்கள்',
    'என் சிசிஏ',
    'கால அட்டவணை',
    'வீட்டு பாடம்',
    'வருகை',
    "அரட்டை வரலாறு இல்லை... புதியதைச் சேர்!",
    "தேடல்",
    "புதிய அரட்டைகள்",
    "உங்கள் ஆசிரியர்களைக் கண்டுபிடி",
    "எனது அரட்டைகள்", //84
    "அமைப்புகள்",
    "தோற்றத்தை மாற்றவும்",
    "தனிப்பட்ட அடையாளம்",
    "பிறந்த தேதி : ",
    "பாலினம்: ",
    "இரத்த வகை: ",
    "தாய் மொழி:", //91
    "தனிப்பட்ட விவரங்கள்",
    "தந்தையின் பெயர்: ",
    "அம்மாவின் பெயர்: ",
    "தொழில்:",
    "வருமானம்:",
    "பிற விவரங்கள்", //97
    "நிரந்தர முகவரி : ",
    "தற்போதைய முகவரி : ",
    "தொலைபேசி எண்: ",
    "மின்னஞ்சல்:",
    'அமைப்புகள்',
    "நீங்கள் வெளியேற விரும்புகிறீர்களா?",
    "ஆம்",
    "இல்லை",
    'வெளியேறு',
    "பங்கேற்பு",
    "வெற்றி",
    "மொழி"
  ],
  "Marathi": [
    "तुमच्या गुणांवर🏃‍♂️✍",
    "वापरकर्तानाव",
    "पासवर्ड",
    "लॉग इन",
    'मुख्यपृष्ठ',
    "अवैध",
    "अहो",
    "तुम्हाला हे तपासावे लागेल 😉",
    "नाव",
    "रोल नाही",
    "मानक",
    "GENDER",
    "वडीलांचे नावं",
    "पत्ता",
    "दूरध्वनी क्रमांक",
    "डॅशबोर्ड",
    "वैयक्तिक विद्यार्थी विश्लेषण",
    'उपस्थिती टक्केवारी',
    "वर्तमान परीक्षेची स्थिती",
    "नाव:",
    "रोल क्रमांक :",
    "कार्यप्रदर्शन",
    "शिक्षक",
    "मानक : ",
    "परीक्षा",
    "तुमच्या परीक्षा येथे शोधा!!!",
    "तुमच्यासाठी आगामी परीक्षा आहे: ",
    "परिणाम",
    "हे आहेत तुमचे गुण",
    "दर्शविण्यासाठी कोणतेही परिणाम नाहीत",
    "प्रेषक: ",
    "प्रति:",
    "सह-अभ्यासक्रम क्रियाकलाप",
    "तुमची प्रतिभा पोस्ट करा",
    "प्रलंबित",
    "स्वीकारले",
    "नाकारले",
    "उपक्रम अद्याप सादर करायचे आहेत😅",
    "कार्यक्रम अद्याप स्वीकारायचे आहेत😕",
    "कोणतेही उपक्रम नाकारले जात नाहीत😉",
    "साप्ताहिक वेळापत्रक",
    "येत असलेले वेळापत्रक पहा!",
    "सोमवार",
    "मंगळवार",
    "बुधवार",
    "गुरुवार",
    "शुक्रवार",
    "शनिवार",
    "गणित",
    "भौतिकशास्त्र",
    "इंग्रजी",
    "तमिळ",
    "रसायनशास्त्र",
    "जीवशास्त्र",
    "शारीरिक शिक्षण",
    "कृपया तुमचे डिव्हाइस फिरवा",
    "कार्ये",
    "अभ्यासाची आवड",
    "कृपया एक तारीख निवडा!",
    "तारीख निवडा",
    "कोणतीही कार्ये नियुक्त केलेली नाहीत",
    "उपस्थिती",
    "विद्यार्थी उपस्थिती दिनदर्शिका",
    "सकाळी 10:00 वाजता उपस्थिती अद्यतने",
    "उपस्थित",
    "गैरहजर",
    "सुट्टी",
    "प्रोफाइल",
    "तुमचा तपशील",
    "प्रोफाइल चित्र",
    "रोल क्रमांक",
    "नाव",
    'विद्यार्थी डॅशबोर्ड',
    'माझे वर्ग शिक्षक',
    'माझ्या परीक्षा',
    'माझे मार्क्स',
    'माय सीसीए',
    'वेळापत्रक',
    'गृहपाठ',
    'उपस्थिती',
    "कोणताही चॅट इतिहास नाही... नवीन जोडा!",
    "शोध",
    "नवीन गप्पा",
    "तुमचे शिक्षक शोधा",
    "माझ्या गप्पा", //84
    "सेटिंग्ज",
    "रूप बदला",
    "वैयक्तिक ओळख",
    "जन्मतारीख :",
    "लिंग:",
    "रक्त गट: ",
    "मातृभाषा:", //91
    "वैयक्तिक माहिती",
    "वडिलांचे नाव: ",
    "आईचे नाव: ",
    "व्यवसाय: ",
    "उत्पन्न:",
    "इतर तपशील", //97
    "कायमचा पत्ता : ",
    "सध्याचा पत्ता : ",
    "दूरध्वनी क्रमांक: ",
    "ईमेल:",
    'सेटिंग्ज',
    "तुम्हाला लॉग आउट करायचे आहे का?",
    "हो",
    "नाही",
    'बाहेर पडणे',
    "भाग घेतला",
    "विजेता",
    "इंग्रजी"
  ]
};

Future<String> getToken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.get("token").toString();
}

Future<String> getRole() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var token = preferences.getString("token");
  if (token == null || token == "null") {
    token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MmVhOTY1ZDY2YmY0ODZiNWQxNDZlYmIiLCJyb2xlIjoiVGVhY2hlciIsImlhdCI6MTY1ODcyMDE0Mn0.YeCwS_gu-rPREQgxU6tuRbZAp3bbUOKx5R53uuXbal4";
  }
  print("token:" + token.toString());

  var req = await http.get(Uri.parse(API_LINK + "api/admin/role"),
      headers: {"x-auth-token": token});
  return req.body.toString();
}

void goToRespectiveHomeScreen(BuildContext context) async {
  var role = await getRole();
  if (role == "Student")
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => StudentHome(0)));

  if (role == "Teacher")
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => TeacherHome(0)));
}

Future<UserModel> checkMe(String username, String password) async {
  var um = UserModel.empty("Error", true);
  var body = jsonEncode({"username": username, "password": password});
  var req = await http.post(Uri.parse("${API_LINK}api/user/check"),
      headers: {"content-type": "application/json"}, body: body);

  if (req.body.toString() == "Invalid UserName" ||
      req.body.toString() == "Invalid Password") {
    toast(req.body.toString());
    return um;
  }

  var res = jsonDecode(req.body);
  um = UserModel(
      res["username"], res["user_id"], res["isAdmin"], res["isRegistered"]);

  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString("token", req.headers['x-auth-token'].toString());

  return um;
}

Future<bool> changePassword(String username, String newPassword) async {
  var body = jsonEncode({"newPassword": newPassword});

  var req = await http.put(
      Uri.parse("${API_LINK}api/user/password/${username}"),
      headers: {"content-type": "application/json"},
      body: body);

  var res = jsonDecode(req.body);

  return res["isRegistered"];
}

void toast(message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

void popPagesNtimes(BuildContext context, int times) {
  var count = 0;
  Navigator.popUntil(context, (route) {
    return count++ == times;
  });
}

Future<void> changeLanguage(String language) async {
  // GoogleTranslator translator = GoogleTranslator();
  if (language == 'Marathi') {
    texts = lang["Marathi"] ?? [];
  } else if (language == 'English') {
    texts = lang["English"] ?? [];
  } else {
    texts = lang["Tamil"] ?? [];
  }

  print(texts[107]);
  // var index = 0;
  // for(var i in texts){
  //   var newText = "";
  //   (lang == "Marathi")
  //       ?await translator.translate(APP_NAME, from: 'en', to: 'mr').then((v){
  //         newText = v.text;
  //       })
  //       :await translator.translate(APP_NAME, from: 'mr', to: 'en').then((v){
  //     newText = v.text;
  //   });
  //   texts[index++] = newText;
  // }
  // print(texts.toString());
}
