class DailyAlertSummaryResource {
  final String date;
  final num count;

  const DailyAlertSummaryResource({
    required this.date,
    required this.count,
  });

  factory DailyAlertSummaryResource.fromJson(
      Map<String, dynamic> json,
      ) {
    return DailyAlertSummaryResource(
      date: json['date'],
      count: json['count'],
    );
  }
}