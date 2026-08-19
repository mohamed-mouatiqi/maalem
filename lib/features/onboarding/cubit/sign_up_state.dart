import 'package:equatable/equatable.dart';

/// Which side of the marketplace the new account is for.
enum UserRole { customer, craftsman }

/// Everything collected across the multi-step Sign Up flow (Choose Role →
/// Step 1 → Step 3). One Cubit/State pair per flow, not per screen — each
/// screen only reads/writes the slice of state it cares about.
class SignUpState extends Equatable {
  const SignUpState({
    this.role,
    this.fullName = '',
    this.phone = '',
    this.email = '',
    this.location = '',
    this.agreedToTerms = false,
  });

  final UserRole? role;
  final String fullName;
  final String phone;
  final String email;
  final String location;
  final bool agreedToTerms;

  SignUpState copyWith({
    UserRole? role,
    String? fullName,
    String? phone,
    String? email,
    String? location,
    bool? agreedToTerms,
  }) {
    return SignUpState(
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      location: location ?? this.location,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
    );
  }

  @override
  List<Object?> get props => [role, fullName, phone, email, location, agreedToTerms];
}
