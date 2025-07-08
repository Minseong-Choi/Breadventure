class Bakery {
  final String id;
  final String name;
  final String address;
  final String roadAddress;
  final String x;
  final String y;
  final String placeUrl;
  final String phone;
  final String distance;
  final List<String> photos;
  final double totalStar;
  final List<Menu> menu;
  final List<OpeningHour> openingHours;
  final List<Comment> comments;

  Bakery({
    required this.id,
    required this.name,
    required this.address,
    required this.roadAddress,
    required this.x,
    required this.y,
    required this.placeUrl,
    required this.phone,
    required this.distance,
    required this.photos,
    required this.totalStar,
    required this.menu,
    required this.openingHours,
    required this.comments,
  });

  factory Bakery.fromJson(Map<String, dynamic> json) {
    return Bakery(
      id: json['id'],
      name: json['place_name'],
      address: json['address_name'],
      roadAddress: json['road_address_name'],
      x: json['x'],
      y: json['y'],
      placeUrl: json['place_url'],
      phone: json['phone'] ?? '',
      distance: json['distance'],
      photos: List<String>.from(json['photo_url'] ?? []),
      totalStar: double.tryParse(json['total_star'] ?? '') ?? 0.0,
      menu: (json['menu'] ?? []).map<Menu>((m) => Menu.fromJson(m)).toList(),
      openingHours: (json['opening_hours'] ?? [])
          .map<OpeningHour>((o) => OpeningHour.fromJson(o))
          .toList(),
      comments: (json['comments'] ?? [])
          .map<Comment>((c) => Comment.fromJson(c))
          .toList(),
    );
  }
}

//딕셔너리 형태의 데이터는 따로 필드 소명
class Menu {
  final String name;

  Menu({required this.name});

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(name: json['name']);
}

class OpeningHour {
  final String day;
  final String time;

  OpeningHour({required this.day, required this.time});

  factory OpeningHour.fromJson(Map<String, dynamic> json) =>
      OpeningHour(day: json['day'], time: json['time']);
}

class Comment {
  final String reviewerName;
  final String reviewerGrade;
  final String reviewerPhoto;
  final String reviewerComment;

  Comment({
    required this.reviewerName,
    required this.reviewerGrade,
    required this.reviewerPhoto,
    required this.reviewerComment,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    reviewerName: json['reviewer_name'],
    reviewerGrade: json['reviewer_grade'],
    reviewerPhoto: json['reviewer_photo'],
    reviewerComment: json['reviewer_comment'],
  );
}
