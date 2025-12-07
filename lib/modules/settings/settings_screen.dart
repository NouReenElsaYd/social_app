
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/component/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../../shared/style/colors.dart';
import '../edit_profile/edit_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 190,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6.0),
                              topRight: Radius.circular(6.0)),
                          image: DecorationImage(
                              image: NetworkImage(userModel?.cover ??
                                  'https://img.freepik.com/free-photo/low-angle-view-unrecognizable-muscular-build-man-preparing-lifting-barbell-health-club_637285-2497.jpg?t=st=1738765548~exp=1738769148~hmac=d2ec4cfff9f038fcb4ab87118d8ca9db75470564640dde4c577b9e4eaf101a86&w=740'),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 64,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      child: CircleAvatar(
                        radius: 60.0,
                        backgroundImage: NetworkImage(userModel?.image ??
                            'https://img.freepik.com/free-photo/half-length-shot-cheerful-man-points-yellow-t-shirt-has-glad-expression-advertises-new-outfit-poses-against-bright-background_273609-34045.jpg?t=st=1739103683~exp=1739107283~hmac=d1fbd13dcf02cfd2278d38045ccadc74f7c707155df2a06d567d9a23bec2b6b1&w=740'),
                      ),
                    )
                  ],
                ),
              ),
              Text(
                '${userModel!.name}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              Text(
                userModel.bio ?? '',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children: [
                            Text(
                              '100',
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              'Posts',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            )
                          ],
                        ),
                        onTap: () {},
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children: [
                            Text(
                              '10K',
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              'Followers',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            )
                          ],
                        ),
                        onTap: () {},
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children: [
                            Text(
                              '64',
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              'Following',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            )
                          ],
                        ),
                        onTap: () {},
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children: [
                            Text(
                              '265',
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              'Photos',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            )
                          ],
                        ),
                        onTap: () {},
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: defaultOutlinedButton(widget: Text(
                        'Add Photos',
                        style: TextStyle(color: baseColor,fontWeight: FontWeight.w700),
                      ), function: (){})),
                  SizedBox(
                    width: 10.0,
                  ),
                  defaultOutlinedButton(
                      widget: Icon(
                        Icons.edit,
                        color: baseColor,
                        size: 18,
                      ),
                      function: () {
                        navigateTo(to: EditProfileScreen(), context: context);
                      })
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
