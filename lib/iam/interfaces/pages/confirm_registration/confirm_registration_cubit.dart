import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/iam/domain/model/commands/confirm_registration.command.dart';
import 'package:mobile/iam/domain/model/valueobjects/session_id.valueobject.dart';
import 'package:mobile/iam/domain/model/valueobjects/verification_code.valueobject.dart';
import 'package:mobile/iam/domain/services/authentication.command-service.dart';

part 'confirm_registration_state.dart';

class ConfirmRegistrationCubit extends Cubit<ConfirmRegistrationState> {
  final AuthenticationCommandService _commandService;

  ConfirmRegistrationCubit(this._commandService) : super(const ConfirmRegistrationState());

  Future<void> confirmRegistration({
    required String sessionId,
    required String verificationCode,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final sessionIdVo = SessionId(sessionId);
      final codeVo = VerificationCode(verificationCode);
      final command = ConfirmRegistrationCommand(
        sessionId: sessionIdVo,
        verificationCode: codeVo,
      );

      final result = await _commandService.handleConfirmRegistration(command);

      result.fold(
        (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
        (_) => emit(state.copyWith(isLoading: false, isSuccess: true)),
      );
    } on ArgumentError catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message as String?));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
