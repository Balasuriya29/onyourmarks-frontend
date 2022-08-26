import 'package:flutter/material.dart';

import '../Utilities/Components/functional.dart';
import '../Utilities/functions.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var dropdownValue = "English";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(texts[0]),
      ),
      body: Column(
        children: [
          placeASizedBoxHere(50),
          getHeader(texts[85], texts[86]),
          placeASizedBoxHere(20),
          customPaddedRowWidget(
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  color: Colors.blueGrey.shade100,
                  height: 125,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28.0, vertical: 17.0),
                        child: Text(
                          texts[109],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(
                        thickness: 1.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? newValue) {
                            if (dropdownValue != newValue) {
                              changeLanguage(newValue!);
                            }
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          items: <String>['English', 'Tamil', 'Marathi']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              10)
        ],
      ),
    );
  }
}
