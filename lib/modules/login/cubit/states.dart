abstract class LoginStates {}

class LoginInitState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  final String uId;

  LoginSuccessState(this.uId);

  // final LoginModel loginModel;
  // LoginSuccessState(this.loginModel);
}

class LoginErrorState extends LoginStates {
  final String error;
  LoginErrorState(this.error);
}

class LoginChangePasswordVisibilityState extends LoginStates {}
