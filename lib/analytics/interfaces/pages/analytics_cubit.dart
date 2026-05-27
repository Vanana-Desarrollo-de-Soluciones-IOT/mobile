import 'package:flutter_bloc/flutter_bloc.dart';

part 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit() : super(const AnalyticsState());
}
