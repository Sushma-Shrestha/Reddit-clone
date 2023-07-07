import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Community {
  final String name;
  final String id;
  final String banner;
  final String avatar;
  final List<dynamic> members;
  final List<dynamic> mods;
  Community({
    required this.name,
    required this.id,
    required this.banner,
    required this.avatar,
    required this.members,
    required this.mods,
  });

  Community copyWith({
    String? name,
    String? id,
    String? banner,
    String? avatar,
    List<dynamic>? members,
    List<dynamic>? mods,
  }) {
    return Community(
      name: name ?? this.name,
      id: id ?? this.id,
      banner: banner ?? this.banner,
      avatar: avatar ?? this.avatar,
      members: members ?? this.members,
      mods: mods ?? this.mods,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'banner': banner,
      'avatar': avatar,
      'members': members,
      'mods': mods,
    };
  }

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
        name: map['name'] as String,
        id: map['id'] as String,
        banner: map['banner'] as String,
        avatar: map['avatar'] as String,
        members: List<dynamic>.from((map['members'] as List<dynamic>)),
        mods: List<dynamic>.from(
          (map['mods'] as List<dynamic>),
        ));
  }

  String toJson() => json.encode(toMap());

  factory Community.fromJson(String source) =>
      Community.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Community(name: $name, id: $id, banner: $banner, avatar: $avatar, members: $members, mods: $mods)';
  }

  @override
  bool operator ==(covariant Community other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.id == id &&
        other.banner == banner &&
        other.avatar == avatar &&
        listEquals(other.members, members) &&
        listEquals(other.mods, mods);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        id.hashCode ^
        banner.hashCode ^
        avatar.hashCode ^
        members.hashCode ^
        mods.hashCode;
  }
}
