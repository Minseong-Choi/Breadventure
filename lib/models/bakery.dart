// 📄 bakery.dart
import 'review.dart';

class Bakery {
  final String name;
  final String menu;
  final String rating;
  final String image;

  Bakery({
    required this.name,
    required this.menu,
    required this.rating,
    required this.image,
  });

  factory Bakery.fromJson(Map<String, dynamic> json) => Bakery(
    name: json['name'],
    menu: json['menu'],
    rating: json['rating'],
    image: json['image'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'menu': menu,
    'rating': rating,
    'image': image,
  };
}