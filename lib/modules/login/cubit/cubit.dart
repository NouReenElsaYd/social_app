import 'package:app_social/modules/login/cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/component/constants.dart';
import '../../../shared/network/local/cache_helper.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitState());

  static LoginCubit get(context) => BlocProvider.of(context);
  //late LoginModel loginModel;

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      String newUid = value.user!.uid;
      print("✅ Login Successful: $newUid");

      // ✅ Save new user ID globally and in local storage
      uId = newUid;
      CacheHelper.saveData(key: 'uId', value: newUid).then((success) {
        if (success) {
          print("🔹 uId saved successfully: $newUid");
        } else {
          print("❌ Failed to save uId");
        }
      });

      emit(LoginSuccessState(newUid));
    }).catchError((error) {
      print("❌ Login Failed: ${error.toString()}"); // Print error details
      emit(LoginErrorState(error.toString()));
    });
  }




  bool obscureText = true;
  IconData suffix = Icons.visibility;

  void changePasswordVisibility() {
    obscureText = !obscureText;
    suffix = obscureText ? Icons.visibility_off : Icons.visibility;
    emit(LoginChangePasswordVisibilityState());
  }
}
