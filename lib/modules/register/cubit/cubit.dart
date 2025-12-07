
import 'package:app_social/modules/register/cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/user_model.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitState());

  static RegisterCubit get(context) => BlocProvider.of(context);
  //late LoginModel loginModel;

  void userCreate({
    required String email,
    required String name,
    required String phone,
    required String uId,
  })
  {

    UserModel model = UserModel(
        email: email,
        phone: phone,
        name: name,
        uId: uId,
        isEmailVerified: false,
        image:
            'https://img.freepik.com/free-photo/half-length-shot-cheerful-man-points-yellow-t-shirt-has-glad-expression-advertises-new-outfit-poses-against-bright-background_273609-34045.jpg?t=st=1739103683~exp=1739107283~hmac=d1fbd13dcf02cfd2278d38045ccadc74f7c707155df2a06d567d9a23bec2b6b1&w=740',
        bio: 'Write your bio ...',
        cover:
        'https://img.freepik.com/free-photo/low-angle-view-unrecognizable-muscular-build-man-preparing-lifting-barbell-health-club_637285-2497.jpg?t=st=1738765548~exp=1738769148~hmac=d2ec4cfff9f038fcb4ab87118d8ca9db75470564640dde4c577b9e4eaf101a86&w=740');
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error) {
      print('The error : ${error.toString()}');
      emit(CreateUserErrorState(error.toString()));
    });
  }

  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      userCreate(email: email, name: name, phone: phone, uId: value.user!.uid);
      print(value.user?.email);
      print(value.user?.uid);
    }).catchError((error) {
      emit(RegisterErrorState(error.toString()));
    });
  }

  bool obscureText = true;
  IconData suffix = Icons.visibility;

  void changePasswordVisibility() {
    obscureText = !obscureText;
    suffix = obscureText ? Icons.visibility_off : Icons.visibility;
    emit(RegisterChangePasswordVisibilityState());
  }
}
