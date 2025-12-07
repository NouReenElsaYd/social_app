import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/component/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../../shared/style/colors.dart';

class EditProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        var userModel = SocialCubit.get(context).userModel;
        var profileImage = SocialCubit.get(context).profileImage;
        var coverImage = SocialCubit.get(context).coverImage;

        nameController.text = userModel!.name!;
        bioController.text = userModel.bio!;
        phoneController.text = userModel.phone!;

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Edit Profile',
            actions: [
              defaultTextButton(
                  function: () {
                    SocialCubit.get(context).updateUser(
                        name: nameController.text,
                        phone: phoneController.text,
                        bio: bioController.text);
                  },
                  text: 'Update'),
              SizedBox(
                width: 15.0,
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is SocialUserUpdateLoadingState)
                    LinearProgressIndicator(),
                  if (state is SocialUserUpdateLoadingState)
                    SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 190,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 140,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(6.0),
                                      topRight: Radius.circular(6.0)),
                                  image: DecorationImage(
                                      image: coverImage == null
                                          ? NetworkImage('${userModel.cover}')
                                          : FileImage(coverImage),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  SocialCubit.get(context).getCoverImage();
                                },
                                icon: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: baseColor,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundImage: profileImage == null
                                    ? NetworkImage('${userModel.image}')
                                    : FileImage(profileImage),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                SocialCubit.get(context).getProfileImage();
                              },
                              icon: CircleAvatar(
                                radius: 20,
                                backgroundColor: baseColor,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  if (SocialCubit.get(context).profileImage != null ||
                      SocialCubit.get(context).coverImage != null)
                    Row(
                      children: [
                        if (SocialCubit.get(context).profileImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultButton(
                                    text: 'upload profile image',
                                    function: () {
                                      SocialCubit.get(context).uploadProfileImage(
                                          name: nameController.text,
                                          phone: phoneController.text,
                                          bio: bioController.text);
                                    },
                                    color: baseColor),
                                if (state is SocialUserUpdateLoadingState)
                                SizedBox(
                                  height: 5.0,
                                ),
                                if (state is SocialUserUpdateLoadingState)
                                  LinearProgressIndicator()
                              ],
                            ),
                          ),
                        SizedBox(
                          width: 5.0,
                        ),
                        if (SocialCubit.get(context).coverImage != null)
                          Expanded(
                              child: Column(
                            children: [
                              defaultButton(
                                  text: 'upload cover image',
                                  function: () {
                                    SocialCubit.get(context).uploadCoverImage(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        bio: bioController.text);
                                  },
                                  color: baseColor),
                              if (state is SocialUserUpdateLoadingState)
                                SizedBox(
                                height: 5.0,
                              ),
                              if (state is SocialUserUpdateLoadingState)
                                LinearProgressIndicator(),
                              if (state is SocialUserUpdateLoadingState)
                                SizedBox(
                                  height: 5.0,
                                ),
                            ],
                          ))
                      ],
                    ),
                  SizedBox(
                    height: 15.0,
                  ),
                  defaultFormField(
                      controller: nameController,
                      type: TextInputType.name,
                      validate: (value) {
                        if (value.isEmpty) {
                          return 'name must not be empty';
                        }
                        return null;
                      },
                      lable: 'Name',
                      prefix: Icons.person),
                  SizedBox(
                    height: 10.0,
                  ),
                  defaultFormField(
                      controller: bioController,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value.isEmpty) {
                          return 'name bio not be empty';
                        }
                        return null;
                      },
                      lable: 'Bio',
                      prefix: Icons.info_outline),
                  SizedBox(
                    height: 10.0,
                  ),
                  defaultFormField(
                      controller: phoneController,
                      type: TextInputType.phone,
                      validate: (value) {
                        if (value.isEmpty) {
                          return 'phone must not be empty';
                        }
                        return null;
                      },
                      lable: 'Phone',
                      prefix: Icons.phone),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
