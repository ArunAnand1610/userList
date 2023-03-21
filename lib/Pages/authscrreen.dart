// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, non_constant_identifier_names, prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers, unused_local_variable, deprecated_member_use

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:userlist_projects/Model/usermodel.dart';
import 'package:userlist_projects/Pages/homescreen.dart';
import 'package:userlist_projects/Styles/authstyle.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final login = TextEditingController();
  final password = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();
  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  bool hide = false;
  int flag = 0;
  bool validate = false;
  bool parentvalid = false;
  bool suffvalid = false;
  bool? usernameExists;
  bool isLogin = true;
  var insCode;
  String? accessKey;
  String mailerror = "";
  bool isLoading = false;
  final usersCollection =
      FirebaseFirestore.instance.collection('users').withConverter(
            fromFirestore: (snap, _) => UserModel.fromMap(snap.data()!),
            toFirestore: (user, _) => user.toMap(),
          );
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    focusNode1.addListener(() {
      setState(() {});
    });
    focusNode2.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      focusNode1.unfocus();
      focusNode2.unfocus();
      print("inactive");
    } else if (state == AppLifecycleState.resumed) {
      print('app resumed');
    }
  }

  usersLogin() async {
    setState(() {
      validate = true;
    });
    if (_formKey1.currentState!.validate() &&
        parentvalid == false &&
        suffvalid == false) {
      setState(() {
        validate = true;
        print("the validare : $validate");
        flag = 1;
      });
      setState(() {
        isLoading = true;
      });
      try {
        final email = login.text.trim();
        final passWord = password.text.trim();

        // final isEmail =
        //     userOrEmail.contains('@') && userOrEmail.endsWith('.com');

        // if (isEmail) {
        //   email = userOrEmail;
        // } else {
        //   final foundedUser = await usersCollection
        //       .where('username', isEqualTo: userOrEmail)
        //       .get()
        //       .then((value) => value.docs[0].data());
        //   email = foundedUser.email;
        // }
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: passWord,
        );
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        toast('$e');
        debugPrint("Error: $e");
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void register() async {
    setState(() {
      validate = true;
    });
    if (_formKey1.currentState!.validate() &&
        parentvalid == false &&
        suffvalid == false) {
      setState(() {
        validate = true;
        print("the validare : $validate");
        flag = 1;
      });
      final email = login.text.trim();
      final passWord = password.text.trim();

      setState(() {
        isLoading = true;
      });

      try {
        final emailExists = await usersCollection
            .where('email', isEqualTo: email)
            .get()
            .then((value) => value.docs.isNotEmpty);
        if (emailExists) {
          if (!mounted) return;
          toast("This email already exists, Login!");

          setState(() {
            isLoading = false;
          });
          return;
        }
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: passWord,
        );

        final createdUser = credential.user!;

        final newUser = UserModel(
          id: createdUser.uid,
          email: email,
          username: '',
        );

        await usersCollection.doc(createdUser.uid).set(newUser);
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        toast("$e");
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Form(
            key: _formKey1,
            child: Column(
              children: [
                Container(
                  height: 72,
                  width: 72,
                  margin: const EdgeInsets.only(
                    top: 40,
                  ),
                  child: Center(child: Image.asset("assets/images.png")),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 40, left: 32, right: 32),
                  child: Center(
                      child: Text(isLogin ? "  Login" : "Register",
                          style: headstyle)),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 6, left: 32, right: 32),
                  child: Center(
                      child: Text(
                          "Lorem ipsum dolor sit amet, consetetur adipscing elitr, sed diam nonumy eirmod tempor",
                          textAlign: TextAlign.center,
                          style: contentstyle)),
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 50, left: 34, right: 34),
                      height: 50,
                      width: double.infinity,
                      child: TextFormField(
                        enableSuggestions: false,
                        autocorrect: false,
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        style: logintextstyle,
                        cursorHeight: 18,
                        onChanged: ((v) {
                          if (login.text.isEmpty) {
                            if (v.isEmpty) {
                              setState(() {
                                suffvalid = true;
                              });
                            }
                          } else {
                            if (login.text[0] == " " && v == " ") {
                              setState(() {
                                suffvalid = true;
                                login.clear();
                              });
                            } else {
                              setState(() {
                                suffvalid = false;
                              });
                            }
                          }
                          debugPrint("te vali : $validate");
                          if (validate == true) {
                            _formKey1.currentState!.validate();
                          }
                        }),
                        validator: (value) {
                          if (value!.isEmpty) {
                            setState(() {
                              suffvalid = true;
                            });
                            return "Please Enter Your Mail";
                          } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            setState(() {
                              suffvalid = true;
                            });
                            return "Please Enter Valid Mail";
                          } else {
                            setState(() {
                              suffvalid = false;
                            });
                            return null;
                          }
                        },
                        focusNode: focusNode1,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Color(0xff007ebc))),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Color(0xff00c09d))),
                          errorBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.red)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Color(0xffe8e8e8))),
                          hintText: 'E-Mail',
                          hintStyle: TextStyle(
                              fontSize: 13,
                              fontFamily: "Gordita",
                              fontWeight: focusNode1.hasFocus
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                              color: focusNode1.hasFocus
                                  ? Color(0xFF00c19d)
                                  : Color(0xFFd4d4d4)),
                        ),
                        controller: login,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 30, left: 34, right: 34),
                      height: 60,
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: TextFormField(
                          scrollPadding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          focusNode: focusNode2,
                          style: logintextstyle,
                          obscureText: hide == true ? false : true,
                          obscuringCharacter: "*",
                          cursorHeight: 18,
                          validator: (value) {
                            if (value == null) return "";

                            if (value.isEmpty) {
                              setState(() {
                                parentvalid = true;
                              });
                              return "Please enter your password";
                            } else if (!pass_valid.hasMatch(value)) {
                              return 'Password must containes atleast one capital letter,' +
                                  '\n' +
                                  'one lowercase letter,one special charcter,8 character';
                            } else {
                              setState(() {
                                parentvalid = false;
                              });
                              return null;
                            }
                          },
                          onChanged: (v) {
                            if (validate == true) {
                              _formKey1.currentState!.validate();
                            }
                          },
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xff007ebc))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xff00c09d))),
                            errorBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.red)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xffe8e8e8))),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                                fontSize: 13,
                                fontFamily: "Gordita",
                                fontWeight: focusNode2.hasFocus
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                                color: focusNode2.hasFocus
                                    ? Color(0xFF00c19d)
                                    : Color(0xFFd4d4d4)),
                            suffixIcon: IconButton(
                                onPressed: (() {
                                  setState(() {
                                    hide = !hide;
                                  });
                                }),
                                icon: hide == false
                                    ? Image(
                                        image: AssetImage("assets/Hide.png"),
                                        height: 20,
                                        width: 20,
                                      )
                                    : Image(
                                        image: AssetImage("assets/Show.png"),
                                        height: 20,
                                        width: 20,
                                      )),
                          ),
                          controller: password,
                        ),
                      ),
                    ),
                  ],
                ),

                Container(
                  height: 48,
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 72, left: 32, right: 32),
                  decoration: buttondecoration,
                  child: MaterialButton(
                    child: Center(
                      child: !isLoading
                          ? Text(isLogin ? "LOGIN" : "REGISTER",
                              style: buttonstyle)
                          : LoadingAnimationWidget.prograssiveDots(
                              color: Colors.white, size: 40),
                    ),
                    onPressed: () {
                      if (flag == 0) {
                        isLogin ? usersLogin() : register();
                      }
                    },
                  ),
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(isLogin ? "Register" : "Login")),
                // Container(
                //   height: 48,
                //   width: double.infinity,
                //   margin: const EdgeInsets.only(top: 32, left: 42, right: 42),
                //   decoration: buttondecoration,
                //   child: MaterialButton(
                //     child: Center(
                //       child: flag == 0
                //       ?isLogin
                //           ? Text("LOGIN", style: buttonstyle)
                //           :Text("Register", style: buttonstyle)
                //           : LoadingAnimationWidget.prograssiveDots(
                //               color: Colors.white, size: 40),
                //     ),
                //     onPressed: () {
                //       if (flag == 0) {
                //         setState(() {
                //           isLogin = !isLogin;
                //         });
                //       }
                //     },
                //   ),
                // ),

                SizedBox(
                  height: focusNode1.hasFocus ? 16 : 0,
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
