import 'package:flutter_bloc/flutter_bloc.dart';

part 'alerts_state.dart';

class AlertsCubit extends Cubit<AlertsState> {
  AlertsCubit() : super(const AlertsState());
}
