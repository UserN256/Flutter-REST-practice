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
  //final responseJson = jsonDecode(response.body);
  //return User.fromJson(responseJson[0]);
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
        appBar: AppBar(
          title: const Text('Fetch JSON Data Example'),
        ),
        body: Center(
          child: FutureBuilder<List<User>>(
            future: futureUser,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Showing list of all Users
                return ListView(
                  children: [
                    if (snapshot.data != null)
                      for (int i = 0; i < snapshot.data!.length; i++)
                        Container(
                          constraints: BoxConstraints.expand(
                            width: 200,
                            height: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .fontSize! * 1.1 + 40.0,                                        
                          ),
                          padding: const EdgeInsets.all(8.0),
                          color: Colors.blue,
                          alignment: Alignment.center,
                          child: Text(
                              'User name is: ${snapshot.data![i].name}' ,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                  color: Color.fromARGB(255, 43, 29, 235))),
                          /*Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                        color: const Color.fromARGB(
                                            255, 43, 29, 235)
                                            ))*/
                        ),
                  ],
                );
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
}
