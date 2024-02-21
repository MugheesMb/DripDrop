part of 'auth_bloc.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

class RequestRegEvent extends AuthEvent{
  final AppUser user;
  RequestRegEvent(this.user);
}

class SignUpEvent extends AuthEvent {
  final AppUser appUser;

  SignUpEvent(
      this.appUser);
}
