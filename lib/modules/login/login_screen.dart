
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/component/components.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../shared/style/colors.dart';
import '../layout/social_layout.dart';
import '../register/register_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});

   var loginFormKey = GlobalKey<FormState>();
var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit,LoginStates>(
        listener: (BuildContext context, state) {
          // if(state is LoginErrorState){
          //   showToast(message: state.error, state: ToastStates.ERROR);
          // }
          if(state is LoginSuccessState)
            {
              CacheHelper.saveData(key: 'uId', value: state.uId).then((value){
                navigateAndFinish(SocialLayout(), context);
              });
            }
        },
        builder: (BuildContext context, state) =>Scaffold(
          appBar: AppBar(),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOGIN',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        'LogIn now to communicate with friends',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Email must not be empty';
                            }
                            return null;
                          },
                          lable: 'Email',
                          prefix: Icons.email),
                      const SizedBox(
                        height: 20.0,
                      ),
                      defaultFormField(
                          controller: passwordController,
                          obscureText: LoginCubit.get(context).obscureText,
                          type: TextInputType.visiblePassword,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'The password os too short';
                            }
                            return null;
                          },
                          lable: 'Password',
                          prefix: Icons.lock_outline,
                          suffix: LoginCubit.get(context).suffix,
                          onPressed: () {
                            LoginCubit.get(context)
                                .changePasswordVisibility();
                          }),
                      const SizedBox(
                        height: 40.0,
                      ),
                      defaultButton(
                          text: 'LOGIN',
                          function: () {
                            if (loginFormKey.currentState!.validate()) {
                              LoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text);
                            navigateTo(to: SocialLayout(), context: context);
                             }
                          },
                          color: baseColor),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an account?'),
                          defaultTextButton(
                              function: () {
                               navigateTo(
                                   to: RegisterScreen(), context: context);
                              },
                              text: 'Register now')
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
