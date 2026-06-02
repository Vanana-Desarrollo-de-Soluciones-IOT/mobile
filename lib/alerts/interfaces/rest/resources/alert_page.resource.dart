import 'alert_response.resource.dart';

class AlertPageResource {
  final List<AlertResponseResource> content;
  final int totalElements;
  final int totalPages;
  final int size;
  final int number;

  AlertPageResource({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.size,
    required this.number,
  });

  factory AlertPageResource.fromJson(
      Map<String, dynamic> json,
      ) {
    return AlertPageResource(
      content: (json['content'] as List)
          .map(
            (e) => AlertResponseResource.fromJson(
          e as Map<String, dynamic>,
        ),
      )
          .toList(),
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
      size: json['size'],
      number: json['number'],
    );
  }
}