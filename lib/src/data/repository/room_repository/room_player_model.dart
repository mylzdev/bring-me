import 'package:cloud_firestore/cloud_firestore.dart';

class RoomPlayerModel {
  static const int maxItems = 5;

  final String name;
  bool isLeader;
  bool isReady;
  int score;
  int itemLeft;
  int? avatarIndex;
  RoomPlayerModel({
    required this.name,
    this.isLeader = true,
    this.isReady = true,
    this.score = 0,
    this.itemLeft = maxItems,
    this.avatarIndex = 0,
  });

  RoomPlayerModel copyWith({
    String? id,
    String? name,
    bool? isLeader,
    bool? isReady,
    int? score,
    int? itemLeft,
    int? avatarIndex,
  }) {
    return RoomPlayerModel(
      name: name ?? this.name,
      isLeader: isLeader ?? this.isLeader,
      isReady: isReady ?? this.isReady,
      score: score ?? this.score,
      itemLeft: itemLeft ?? this.itemLeft,
      avatarIndex: avatarIndex ?? this.avatarIndex,
    );
  }

  static RoomPlayerModel empty() => RoomPlayerModel(name: '');

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'isLeader': isLeader,
      'isReady': isReady,
      'score': score,
      'itemLeft': itemLeft,
      'avatarIndex': avatarIndex,
    };
  }

  factory RoomPlayerModel.fromMap(Map<String, dynamic> map) {
    return RoomPlayerModel(
      name: map['name'] as String,
      isLeader: map['isLeader'] as bool,
      isReady: map['isReady'] as bool,
      score: map['score'] as int,
      itemLeft: map['itemLeft'] as int,
      avatarIndex: map['avatarIndex'] as int,
    );
  }

  factory RoomPlayerModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.exists) {
      final data = document.data()!;
      return RoomPlayerModel(
        name: data['name'] as String,
        isLeader: data['isLeader'] as bool,
        isReady: data['isReady'] as bool,
        score: data['score'] as int,
        itemLeft: data['itemLeft'] as int,
        avatarIndex: data['avatarIndex'] as int,
      );
    } else {
      return RoomPlayerModel.empty();
    }
  }

  @override
  String toString() =>
      'User(name: $name, isLeader: $isLeader, isReady: $isReady, Score: $score), AvatarIndex: $avatarIndex';
}
