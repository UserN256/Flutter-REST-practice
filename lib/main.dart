// 1st 3 variants commented below. Originalnoe zakommentil v konce
// Copyright (c) 2018, Marco Esposito (marcoesposito1988@gmail.com).
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http_auth/http_auth.dart';

Future<List<User>> fetchUser() async {
  var client = BasicAuthClient('admin@gmail.com', 'admin');
  //client.get(url).then((r) => stderr.writeln((r.body)));
  final response = await client.get(
    Uri.parse('https://javaops-demo.ru/topjava/rest/admin/users'),
    // Send authorization headers to the backend.
  );
  Iterable l = json.decode(response.body);
  List<User> users = List<User>.from(l.map((model) => User.fromJson(model)));
  return users;
}

class User {
  final int id;
  final String name;
  final String email;
  final bool isenabled;
  final String registered;
  final List<dynamic> roles;
  final int caloriesPerDay;
  final String? meals;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.isenabled,
      required this.registered,
      required this.roles,
      required this.caloriesPerDay,
      this.meals});

  factory User.fromJson(Map<String, dynamic> json) {
    // Declaring and putting items in User object
    return User(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        isenabled: json['enabled'] as bool,
        registered: json['registered'] as String,
        roles: json['roles'] as List<dynamic>,
        caloriesPerDay: json['caloriesPerDay'] as int,
        meals: json['meals'] as String?);
  }

  @override
  // toString didnt worked correctly somewhere =)
  String toString() {
    return '{ id: $id, name: $name, email: $email, isenabled: $isenabled, registered: $registered, list of roles: $roles, caloriesPerDay: $caloriesPerDay, meals: $meals';
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<User>> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Json Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        backgroundColor: Colors.greenAccent,
        appBar: AppBar(
          title: const Text('Fetch JSON Data Example'),
        ),
        body: Center(
          child: FutureBuilder<List<User>>(
            future: futureUser,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Showing list of all Users with Builder template
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return item4Builder(snapshot, index);
                    });
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  Container item4Builder(AsyncSnapshot<List<User>> snapshot, int index) {
    return Container(
      width: 200,
      height: 70,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green[700],
          child: const Icon(
            Icons.person_outline_outlined,
            color: Colors.white,
          ),
        ),
        // Showing name
        title: Text(
          snapshot.data![index].name,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        // Showing email...
        subtitle: Text(snapshot.data![index].email),
        //...and enabled state
        trailing: snapshot.data![index].isenabled
            ? Icon(
                Icons.check_circle,
                color: Colors.green[700],
              )
            : const Icon(
                Icons.check_circle_outline,
                color: Colors.grey,
              ),
        /*onTap: () {
                              setState(() {
                                contacts[index].isSelected = !contacts[index].isSelected;
                                if (contacts[index].isSelected == true) {
                                  selectedContacts.add(ContactModel(name, phoneNumber, true));
                                } else if (contacts[index].isSelected == false) {
                                  selectedContacts
                                      .removeWhere((element) => element.name == contacts[index].name);
                                }
                              });
                            }*/
      ),
    );
  }
}
