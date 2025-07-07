
// 📄 user.dart
import 'review.dart';
import 'bakery.dart';

class UserData {
  final int id;
  final String username;
  final String profileImage;
  final List<Review> reviews;
  final List<Bakery> favorites;

  UserData({
    required this.id,
    required this.username,
    required this.profileImage,
    required this.reviews,
    required this.favorites,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json['id'],
    username: json['username'],
    profileImage: json['profileImage'],
    reviews: (json['reviews'] as List)
        .map((reviewJson) => Review.fromJson(reviewJson))
        .toList(),
    favorites: (json['favorites'] as List)
        .map((favJson) => Bakery.fromJson(favJson))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'profileImage': profileImage,
    'reviews': reviews.map((r) => r.toJson()).toList(),
    'favorites': favorites.map((b) => b.toJson()).toList(),
  };
}
