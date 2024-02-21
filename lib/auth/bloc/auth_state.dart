part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthLoggedInState extends AuthState {
  final AppUser user;
  AuthLoggedInState(this.user);
}

class AuthRequestedState extends AuthState {
  AuthRequestedState();
}

class AuthAlreadyReqState extends AuthState {
  AuthAlreadyReqState();
}

class AuthErrorState extends AuthState {
  final String error;
  AuthErrorState(this.error);
}