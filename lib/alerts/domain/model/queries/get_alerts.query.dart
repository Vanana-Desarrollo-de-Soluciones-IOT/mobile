class GetAlertsQuery {
  final String? severity;
  final bool? acknowledged;

  const GetAlertsQuery({this.severity, this.acknowledged});
}
