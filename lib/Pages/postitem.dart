import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:userlist_projects/Model/adduser.dart';
import 'package:userlist_projects/Model/usermodel.dart';

class PostItem extends StatefulWidget {
  const PostItem({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  final postsCollection =
      FirebaseFirestore.instance.collection('posts').withConverter(
            fromFirestore: (snap, _) => Post.fromMap(snap.data()!),
            toFirestore: (post, _) => post.toMap(),
          );
  final usersCollection =
      FirebaseFirestore.instance.collection('users').withConverter(
            fromFirestore: (snap, _) => UserModel.fromMap(snap.data()!),
            toFirestore: (user, _) => user.toMap(),
          );
  late final DocumentReference<Post> postRef;
  late final StreamSubscription postSubscription;
  late Post post;
  final currentUser = FirebaseAuth.instance.currentUser!;
  String? username;
  String? userImgUrl;

  @override
  void initState() {
    super.initState();
    post = widget.post;
    postRef = postsCollection.doc(widget.post.id);
    postSubscription = postRef.snapshots().listen((event) {
      final updatedPost = event.data();
      if (updatedPost == null) return;
      setState(() {
        post = updatedPost;
      });
    });

    usersCollection.doc(post.id).get().then((value) {
      final postOwner = value.data();
      if (postOwner == null) return;
      setState(() {
        username = postOwner.username;
        userImgUrl = postOwner.profilePic;
      });
    });
  }

  @override
  void didUpdateWidget(covariant PostItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.id == post.id) return;
    post = widget.post;
  }

  @override
  void dispose() {
    postSubscription.cancel();
    super.dispose();
  }

  void toggleLike() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final postRef = postsCollection.doc(widget.post.id);
  }

  ImageProvider<Object> getBackgroundImage() {
    if (userImgUrl == null) {
      return const AssetImage('assets/blank_profile.png');
    }
    return NetworkImage(userImgUrl!);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("$username"),
            accountEmail: Text("$username"),
            currentAccountPicture: const CircleAvatar(
                radius: 66,
                backgroundColor: Colors.blue,
                backgroundImage: AssetImage('assets/images.png')),
          )
        ],
      ),
    );
  }
}
