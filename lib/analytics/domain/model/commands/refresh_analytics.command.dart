import 'package:mobile/analytics/domain/model/valueobjects/analytics_id.valueobject.dart';

class RefreshAnalyticsCommand {
  final AnalyticsId analyticsId;

  const RefreshAnalyticsCommand({required this.analyticsId});
}
