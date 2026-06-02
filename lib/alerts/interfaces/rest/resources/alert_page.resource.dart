import 'package:mobile/alerts/interfaces/rest/resources/alert_response.resource.dart';

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
}
