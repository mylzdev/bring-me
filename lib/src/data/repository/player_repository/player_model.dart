import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerModel {
  String name;
  bool isLeader;
  bool isReady;
  int score;
  PlayerModel({
    required this.name,
    this.isLeader = true,
    this.isReady = true,
    this.score = 0,
  });

  PlayerModel copyWith({
    String? id,
    String? name,
    bool? isLeader,
    bool? isReady,
    int? score,
  }) {
    return PlayerModel(
      name: name ?? this.name,
      isLeader: isLeader ?? this.isLeader,
      isReady: isReady ?? this.isReady,
      score: score ?? this.score,
    );
  }

  static PlayerModel empty() => PlayerModel(name: '');

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'isLeader': isLeader,
      'isReady': isReady,
      'score': score,
    };
  }

  factory PlayerModel.fromMap(Map<String, dynamic> map) {
    return PlayerModel(
      name: map['name'] as String,
      isLeader: map['isLeader'] as bool,
      isReady: map['isReady'] as bool,
      score: map['score'] as int,
    );
  }

  factory PlayerModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.exists) {
      final data = document.data()!;
      return PlayerModel(
        name: data['name'] as String,
        isLeader: data['isLeader'] as bool,
        isReady: data['isReady'] as bool,
        score: data['score'] as int,
      );
    } else {
      return PlayerModel.empty();
    }
  }

  @override
  String toString() =>
      'User(name: $name, isLeader: $isLeader, isReady: $isReady, Score: $score)';
}
