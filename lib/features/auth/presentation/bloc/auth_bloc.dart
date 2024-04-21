import 'package:blog_app/features/auth/domain/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;

  AuthBloc(this._userSignUp, this._userLogin) : super(AuthInitial()) {
    on<AuthSignUp>(onSignUp);
    on<AuthLogin>(onLogin);
  }

  void onSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    res.fold(
      (err) => emit(AuthFailure(err.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  void onLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(UserLoginParams(event.email, event.password));

    res.fold(
      (err) => emit(AuthFailure(err.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }
}
