import 'package:flutter_bloc/flutter_bloc.dart';

import 'sign_up_state.dart';

/// Holds Sign Up flow state (role, name/phone/email, location, terms) so it
/// survives navigation between Choose Role and the Sign Up steps. Provided
/// once, above all of those routes, via ShellRoute in app_router.dart.
class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(const SignUpState());

  void selectRole(UserRole role) => emit(state.copyWith(role: role));

  void updateStep1({
    required String fullName,
    required String phone,
    required String email,
  }) {
    emit(state.copyWith(fullName: fullName, phone: phone, email: email));
  }

  void updateLocation(String location) => emit(state.copyWith(location: location));

  void setAgreedToTerms(bool agreed) => emit(state.copyWith(agreedToTerms: agreed));
}
