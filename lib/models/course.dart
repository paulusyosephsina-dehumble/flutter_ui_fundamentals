
class Course {
  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;

  Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    required this.status,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
     code: json['code'] as String? ??
    'POST${json['id'] ?? json['userId'] ?? ''}',
      title: json['title'] as String? ?? 'Tanpa judul',
      credits: json['credits'] as int? ?? 0,
      status: json['status'] as String? ?? 'planned',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'credits': credits,
      'status': status,
    };
  }
}
