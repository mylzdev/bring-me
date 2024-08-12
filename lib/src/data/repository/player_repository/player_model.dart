import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerModel {
  final String? id;
  final String username;
  final int avatarIndex;
  final int multiGameScore;
  final int singleGameScore;
  PlayerModel({
    this.id,
    required this.username,
    required this.avatarIndex,
    this.multiGameScore = 0,
    this.singleGameScore = 0,
  });

  PlayerModel copyWith({
    String? username,
    int? avatarIndex,
    int? multiGameScore,
    int? singleGameScore,
  }) {
    return PlayerModel(
      username: username ?? this.username,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      multiGameScore: multiGameScore ?? this.multiGameScore,
      singleGameScore: singleGameScore ?? this.singleGameScore,
    );
  }

  static PlayerModel empty() => PlayerModel(username: '', avatarIndex: 0);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'avatarIndex': avatarIndex,
      'multiGameScore': multiGameScore,
      'singleGameScore': singleGameScore,
    };
  }

  factory PlayerModel.fromMap(Map<String, dynamic> map) {
    return PlayerModel(
      username: map['username'] as String,
      avatarIndex: map['avatarIndex'] as int,
      multiGameScore: map['multiGameScore'] as int,
      singleGameScore: map['singleGameScore'] as int,
    );
  }

  factory PlayerModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.exists) {
      final data = document.data()!;
      return PlayerModel(
        id: document.id,
        username: data['username'] as String,
        avatarIndex: data['avatarIndex'] as int,
        multiGameScore: data['multiGameScore'] as int,
        singleGameScore: data['singleGameScore'] as int,
      );
    } else {
      return PlayerModel.empty();
    }
  }

  String toJson() => json.encode(toMap());

  factory PlayerModel.fromJson(String source) =>
      PlayerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PlayerModel(id: $id, username: $username, avatarIndex: $avatarIndex, multiGameScore: $multiGameScore, singleGameScore: $singleGameScore)';
  }
}
