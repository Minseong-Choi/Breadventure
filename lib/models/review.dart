// 📄 review.dart
class Review {
  final String image;
  final int rating;
  final String comment;

  Review({
    required this.image,
    required this.rating,
    required this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    image: json['image'],
    rating: json['rating'],
    comment: json['comment'],
  );

  Map<String, dynamic> toJson() => {
    'image': image,
    'rating': rating,
    'comment': comment,
  };
}