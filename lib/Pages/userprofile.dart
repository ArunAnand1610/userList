import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:userlist_projects/Pages/authscrreen.dart';
import 'package:userlist_projects/Styles/authstyle.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
       
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Column(
                children: [
                  Container(
                height: 48,
                width: double.infinity,
                color:const Color(0xffffffff),
                child: const Center(child: Text("My Account",style: TextStyle(color: Color(0xff251f1f),fontSize: 14,fontWeight: FontWeight.w500),)),
              ),
              Container(
                height: 120,
                width: 120,
                decoration:const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(

                  child: SizedBox.fromSize(
                  size: const Size.fromRadius(30),
                    child:  Image.asset('assets/images.png')),
                  ),
                ),
                
              
            ]),
            Container(
                        margin: const EdgeInsets.only(left: 16,top:12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                              Padding(
                                padding: EdgeInsets.only(top:10.0),
                                child: Text("User Name",style: TextStyle(color: Color(0xff444444),fontSize: 12,fontWeight: FontWeight.w500,fontFamily: "Gordita"),),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text("",style: TextStyle(color: Color(0xffa4a4a4),fontSize: 10,fontWeight: FontWeight.normal,fontFamily: "Gordita"),),
                              SizedBox(
                                height: 10,
                              ),
                          ],
                        ),
                      ),
                       Container(
                        margin: const EdgeInsets.only(left: 16,top: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              const Padding(
                                padding: EdgeInsets.only(top:10.0),
                                child: Text("E-Mail",style: TextStyle(color: Color(0xff444444),fontSize: 12,fontWeight: FontWeight.w500,fontFamily: "Gordita"),),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(FirebaseAuth.instance.currentUser?.email ?? "",style: const TextStyle(color: Color(0xffa4a4a4),fontSize: 10,fontWeight: FontWeight.normal,fontFamily: "Gordita"),),
                              const SizedBox(
                                height: 10,
                              ),
                          ],
                        ),
                      ),
                       Container(
                  height: 48,
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 52, left: 32, right: 32),
                  decoration: buttondecoration,
                  child: MaterialButton(
                    child: const Center(
                      child: 
                           Text("LOGOUT" ,
                              style: buttonstyle)
                          
                    ),
                    onPressed: () {
                       logOut();
           Navigator.popUntil(context,
                                                      (route) => false);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const LoginPage()));
                    },
                  ),
                ),
                     
             
              
                ],
              )
            
          ),
        )
        
          
      
    );
  }
  logOut() {
  FirebaseAuth.instance.signOut();
}
}