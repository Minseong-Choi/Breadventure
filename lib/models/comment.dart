/// Comment 모델 정의
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

  /// JSON(Map) -> Comment 객체 변환
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      reviewerName: json['reviewer_name'] as String? ?? '',
      reviewerGrade: json['reviewer_grade'] as String? ?? '0',
      reviewerPhoto: json['reviewer_photo'] as String? ?? '',
      reviewerComment: json['reviewer_comment'] as String? ?? '',
    );
  }

  /// Comment 객체 -> JSON(Map) 변환
  Map<String, dynamic> toJson() {
    return {
      'reviewer_name': reviewerName,
      'reviewer_grade': reviewerGrade,
      'reviewer_photo': reviewerPhoto,
      'reviewer_comment': reviewerComment,
    };
  }
}