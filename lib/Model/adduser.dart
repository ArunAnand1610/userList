import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';


@immutable
class Post {
  final String id;
  final String name;
  final String? email;
  final String? password;
  final String? role;
 

  const Post({
    required this.id,
    required this.name,
    required this.email,
    required this.password, required this.role,
    
  });

  factory Post.fromMap(Map<String, dynamic> data) {
    return Post(
      id: data['id'],
      name: data['name'],
      password: data['password'],
      email: data['email'],
      role: data["role"]
      
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'email': email,
      'role': role,
      
    };
  }
}
