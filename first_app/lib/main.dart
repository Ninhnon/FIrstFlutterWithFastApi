import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Profile {
  final String name;

  const Profile({required this.name});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
    );
  }
}

void main() {
  runApp(const FinTechExplainedApp());
}

class FinTechExplainedApp extends StatelessWidget {
  const FinTechExplainedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinTechExplainedApp',
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
              'Welcome to FinTechExplainedApp Profiles RestAPI Example'),
        ),
        body: const Center(
          child: FinTechExplainedProfilesWidget(),
        ),
      ),
    );
  }
}

class FinTechExplainedProfilesWidget extends StatefulWidget {
  const FinTechExplainedProfilesWidget({super.key});

  @override
  State<FinTechExplainedProfilesWidget> createState() =>
      _FinTechExplainedProfilesWidgetState();
}

class _FinTechExplainedProfilesWidgetState
    extends State<FinTechExplainedProfilesWidget> {
  @override
  final _biggerFont = const TextStyle(fontSize: 18);
  final profile_box = TextEditingController();
  late Future futureProfiles;
  String serviceURL = "http://localhost:8000/";

  Future<List<Profile>> getProfiles() async {
    List<Profile> profiles = [];
    var response = await http.get(Uri.parse('${serviceURL}profiles'),
        headers: {"Accept": "application/json"});
    var responseData = json.decode(response.body);
    for (var profileData in responseData) {
      profiles.add(Profile.fromJson(profileData));
    }

    return profiles;
  }

  void createProfile(String name) async {
    await http.post(
      Uri.parse('${serviceURL}profile'),
      body: jsonEncode(<String, String>{
        'name': name,
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    futureProfiles = getProfiles();
  }

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          Expanded(
              child: TextField(
            controller: profile_box,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter Profile',
            ),
          )),
          Expanded(
              child: IconButton(
            icon: Icon(
              Icons.add,
            ),
            iconSize: 50,
            color: Colors.green,
            splashColor: Colors.purple,
            onPressed: () => setState(() {
              createProfile(profile_box.text);
            }),
          ))
        ]),
        Expanded(
            child: FutureBuilder(
                future: getProfiles(),
                builder: (context, data) {
                  if (data.data == null) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: data.data?.length,
                        itemBuilder: (context, index) {
                          final title = data.data![index]?.name;
                          return Text(title!);
                        });
                  }
                })),
      ],
    );
  }
}
