
import 'package:app_social/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../shared/component/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../../shared/style/colors.dart';

class NewPostScreen extends StatelessWidget {
  NewPostScreen({super.key});

  var textController = TextEditingController();
  var nowDate = DateTime.now();
  late String formattedDate1 = DateFormat('dd/MM/yyyy').format(nowDate);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        var postImage = SocialCubit.get(context).postImage;
        var userModel = SocialCubit.get(context).userModel;

        return Scaffold(
          appBar:
              defaultAppBar(context: context, title: 'Create Post', actions: [
            defaultTextButton(
                function: () {
                  // print(formattedDate1);
                  if (SocialCubit.get(context).postImage == null) {  // if there is not photo
                    SocialCubit.get(context).createPost(
                        text: textController.text, dateTime: formattedDate1);
                  } else {
                    SocialCubit.get(context).uploadPostImage(  // text only
                        dateTime: formattedDate1, text: textController.text);
                  }
                },
                text: 'Post')
          ]),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state is SocialCreatePostLoadingState)
                  LinearProgressIndicator(),
                if (state is SocialCreatePostLoadingState)
                  SizedBox(
                    height: 10.0,
                  ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          '${userModel!.image}'),
                      radius: 25.0,
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${userModel!.name}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                height: 1.3),
                          ),
                          Text(
                            'public',
                            style: TextStyle(
                                color: Colors.grey, fontSize: 12, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                        hintText: 'What is on your mind ....',
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 20.0,),
                if(SocialCubit.get(context).postImage != null)
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        image: DecorationImage(
                            image: FileImage(postImage!),
                            fit: BoxFit.cover),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        SocialCubit.get(context).removePostImage();
                      },
                      icon: CircleAvatar(
                        radius: 20,
                        backgroundColor: baseColor,
                        child: Icon(
                          Icons.clear,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20.0,),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          SocialCubit.get(context).getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo,
                              color: baseColor,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'add photo',
                              style: TextStyle(color: baseColor),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        child:
                            defaultTextButton(function: () {}, text: '# tags'))
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
