import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:userlist_projects/Model/adduser.dart';
import 'package:userlist_projects/Model/usermodel.dart';
import 'package:userlist_projects/Pages/adduser.dart';
import 'package:userlist_projects/Pages/postitem.dart';
import 'package:userlist_projects/Pages/userdetails.dart';
import 'package:userlist_projects/Pages/userprofile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String? password;
  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  final newpassword=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: const Text("Add new user"),
                          content: const Text(
                              "do you want add new user...................?"),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.leftToRight,
                                        childCurrent: widget,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        child: const Adduser()));
                              },
                            )
                          ]);
                    });
              },
              child: const Icon(Icons.add_photo_alternate),
            ),
            key: _scaffoldKey,
            drawer: Drawer(
                child: Center(
              child: ListView(
                children: [
                  Center(
                    child: UserAccountsDrawerHeader(
                      accountName: const Text("Hii User"),
                      accountEmail:
                          Text(FirebaseAuth.instance.currentUser?.email ?? ""),
                      currentAccountPicture: const CircleAvatar(
                          radius: 66,
                          backgroundColor: Colors.blue,
                          backgroundImage: AssetImage('assets/images.png')),
                    ),
                  ),
                  ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text("Change Password"),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: const Text("Password Change"),
                                  content: TextFormField(
                                      decoration: new InputDecoration(
                                          hintText: 'Password'),
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                          controller: newpassword,
                                      validator: validateMobile,
                                      onSaved: (String? val) {
                                        password = val;
                                      }),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text("OK"),
                                      onPressed: () async {
                                       await FirebaseAuth.instance.sendPasswordResetEmail(email: newpassword.text);
                                       toast("Password change successfully");
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ]);
                            });
                      }),
                      ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text("Profie"),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>UserProfile()));
                      }),
                ],
              ),
            )),
            body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView(children: [
                  Container(
                    height: 48,
                    width: double.infinity,
                    color: const Color.fromRGBO(40, 115, 240, 1),
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                _scaffoldKey.currentState!.openDrawer();
                              },
                              icon: const Icon(
                                Icons.menu,
                                color: Colors.white,
                                size: 28,
                              )),
                          const Padding(
                            padding: EdgeInsets.only(left: 56.0),
                            child: Text(
                              "Home Page",
                              style: TextStyle(
                                  fontFamily: "Gortita",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height/2,
                      margin:
                          const EdgeInsets.only(right: 16, left: 16, top: 16),
                      color: Colors.white,
                      child: const UserDetails())
                ]))));
  }

  String? validateMobile(String? value) {
    if (value == null) return "";

    if (value.isEmpty) {
      return "Please enter your password";
    } else if (!pass_valid.hasMatch(value)) {
      return 'Password must containes atleast one capital letter,' +
          '\n' +
          'one lowercase letter,one special charcter';
    } else if (value.length != 9) {
      return "Please length atleast 8 character";
    } else {
      return null;
    }
  }
}
