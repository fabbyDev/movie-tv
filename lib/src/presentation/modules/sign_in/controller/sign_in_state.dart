import 'package:equatable/equatable.dart';

class SignInState extends Equatable {
  final String username;
  final String password;
  final bool fetching;

  const SignInState({
    required this.username,
    required this.password,
    required this.fetching,
  });

  @override
  List<Object?> get props => [username, password, fetching];

  SignInState copyWith({
    String? username,
    String? password,
    bool? fetching,
  }) {
    return SignInState(
      username: username ?? this.username,
      password: password ?? this.password,
      fetching: fetching ?? this.fetching,
    );
  }
}
