import 'package:flutter/material.dart';

@immutable
class UserModel {
  final String id;
  final String username;
  final String email;
  final String? profilePic;
  final List<String> followings;
  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.profilePic,
    this.followings=const [],
    
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'],
      username: data['username'],
      email: data['email'],
      profilePic: data['profilePic'],
      followings: List<String>.from(data['followings'] ?? [])
     
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profilePic': profilePic,
      "followings":followings,
    };
  }
}