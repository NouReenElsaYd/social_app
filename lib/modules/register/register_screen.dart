
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/component/components.dart';
import '../../shared/style/colors.dart';
import '../layout/social_layout.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class RegisterScreen extends StatelessWidget {
   RegisterScreen({super.key});

   var emailController = TextEditingController();
   var passwordController = TextEditingController();
   var nameController = TextEditingController();
   var phoneController = TextEditingController();

   var registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit,RegisterStates>(
        listener: (context, state) {
          if(state is CreateUserSuccessState)
            {
              navigateAndFinish(SocialLayout(), context);
            }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: registerFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'REGISTER',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        'Register now to communicate with friends',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      defaultFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Name must not be empty';
                            }
                            return null;
                          },
                          lable: 'Name',
                          prefix: Icons.person),
                      const SizedBox(
                        height: 20.0,
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
                          obscureText: RegisterCubit.get(context).obscureText,
                          type: TextInputType.visiblePassword,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'The password os too short';
                            }
                            return null;
                          },
                          lable: 'Password',
                          prefix: Icons.lock_outline,
                          suffix: RegisterCubit.get(context).suffix,
                          onPressed: () {
                            RegisterCubit.get(context).changePasswordVisibility();
                          }),
                      const SizedBox(
                        height: 20.0,
                      ),
                      defaultFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Phone must not be empty';
                            }
                            return null;
                          },
                          lable: 'Phone',
                          prefix: Icons.phone),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultButton(
                          text: 'REGISTER',
                          function: () {
                            if (registerFormKey.currentState!.validate()) {
                              RegisterCubit.get(context).userRegister(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                  phone: phoneController.text);

                            }
                          },
                          color: baseColor),

                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  }

