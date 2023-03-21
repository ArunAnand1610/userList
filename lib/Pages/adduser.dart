import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:userlist_projects/Model/adduser.dart';
import 'package:userlist_projects/Styles/authstyle.dart';

class Adduser extends StatefulWidget {
  const Adduser({super.key});

  @override
  State<Adduser> createState() => _AdduserState();
}

class _AdduserState extends State<Adduser> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String? name, email, password, role;
  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  final userName = TextEditingController();
  final usermail = TextEditingController();
  final userpassword = TextEditingController();
  final userrole = TextEditingController();
  final postsCollection =
      FirebaseFirestore.instance.collection('posts').withConverter(
            fromFirestore: (snap, _) => Post.fromMap(snap.data()!),
            toFirestore: (post, _) => post.toMap(),
          );
  void createPost() async {
    //final postId = const Uuid().v4();
    final ownerId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final newPost = Post(
        id: ownerId,
        name: userName.text,
        email: usermail.text,
        password: userpassword.text,
        role: userrole.text,
      );
      await postsCollection.doc(ownerId).set(newPost);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      toast("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView(children: [
                  Container(
                    height: 48,
                    width: double.infinity,
                    color: Color.fromRGBO(40, 115, 240, 1),
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Image(
                                image:
                                    AssetImage("assets/Mask Group 22@3x.png"),
                                height: 20,
                                width: 20,
                                color: Colors.white,
                              )),
                          const Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Text(
                              "Add User Details",
                              style: TextStyle(
                                  fontFamily: "Gortita",
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 32, left: 16, right: 16),
                    child: Form(
                      key: _key,
                      //autovalidate: _validate,
                      child: FormUI(),
                    ),
                  ),
                ]))));
  }

  Widget FormUI() {
    return Column(
      children: [
        TextFormField(
          controller: userName,
          decoration: InputDecoration(hintText: 'Full Name'),
          validator: validateName,
          onSaved: (String? val) {
            name = val;
          },
        ),
        SizedBox(height: 15.0),
        TextFormField(
            controller: usermail,
            decoration: new InputDecoration(hintText: 'Email ID'),
            keyboardType: TextInputType.emailAddress,
            validator: validateEmail,
            onSaved: (String? val) {
              email = val;
            }),
        SizedBox(height: 15.0),
        TextFormField(
            controller: userpassword,
            decoration: new InputDecoration(hintText: 'Password'),
            keyboardType: TextInputType.visiblePassword,
            validator: validateMobile,
            onSaved: (String? val) {
              password = val;
            }),
        SizedBox(height: 15.0),
        TextFormField(
            controller: userrole,
            decoration: new InputDecoration(hintText: 'Role'),
            keyboardType: TextInputType.visiblePassword,
            validator: validateRole,
            onSaved: (String? val) {
              role = val;
            }),
        SizedBox(height: 15.0),
        Container(
            height: 48,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 72, left: 32, right: 32),
            decoration: buttondecoration,
            child: MaterialButton(
                onPressed: () {
                  _sendToServer();
                },
                child:
                    const Center(child: Text("SUBMIT", style: buttonstyle)))),
      ],
    );
  }

  String? validateName(String? value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value!.length == 0) {
      return "Name is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  String? validateRole(String? value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value!.length == 0) {
      return "Role is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    }
    return null;
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

  String? validateEmail(String? value) {
    if (value!.length == 0) {
      return "Email is Required";
    } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  _sendToServer() {
    if (_key.currentState!.validate()) {
      // No any error in validation
      _key.currentState!.save();
      createPost();
      toast("SUccessfully added user detais");
      Navigator.of(context).pop();
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }
}
