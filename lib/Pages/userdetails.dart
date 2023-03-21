import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:userlist_projects/Model/adduser.dart';
import 'package:userlist_projects/Model/usermodel.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final postsCollection =
      FirebaseFirestore.instance.collection('posts').withConverter(
            fromFirestore: (snap, _) => snap.data() == null
                ? const Post(
                    id: '1',
                    name: 'name',
                    email: 'email',
                    password: 'password',
                    role: 'role')
                : Post.fromMap(
                    snap.data()!,
                  ),
            toFirestore: (post, _) => post.toMap(),
          );
  List<String> followings = [];
  final uid = FirebaseAuth.instance.currentUser?.uid;
  late final DocumentReference<Map<String, dynamic>> currentUserDoc;
  @override
  void initState() {
    super.initState();
    currentUserDoc = FirebaseFirestore.instance.collection('users').doc(uid);
    currentUserDoc.get().then((snap) {
      final data = snap.data();
      if (data == null) return;
      final currentUser = UserModel.fromMap(data);
      followings = currentUser.followings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FirestoreListView(
      query: postsCollection.where('ownerId',
          whereIn: followings.isEmpty ? null : followings),
      itemBuilder: (context, snap) {
        final post = snap.data();
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
           
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.blue,
                      backgroundImage: AssetImage('assets/images.png')),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post.name),
                        Text(post.email!),
                        Text(post.role!),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      loadingBuilder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
      emptyBuilder: (context) {
        return const Center(
          child: Text('Follow people to see posts'),
        );
      },
    );
  }
}
