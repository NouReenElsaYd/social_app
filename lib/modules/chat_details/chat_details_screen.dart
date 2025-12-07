import 'package:app_social/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../../shared/style/colors.dart';

class ChatDetailsScreen extends StatelessWidget {
  ChatDetailsScreen({super.key, required this.userModel});
  UserModel userModel;  //receiver
  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getMessages(receiverId: userModel.uId);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage('${userModel.image}'),
                    ),
                    SizedBox(width: 15.0),
                    Text(
                      '${userModel.name}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          var message = SocialCubit.get(context).messages[index];
                          if(message.senderId == SocialCubit.get(context).userModel!.uId)
                            return buildMyMessage(message);
                          return buildMessage(message);

                        },
                        separatorBuilder: (context, index)=>SizedBox(
                          height: 10.0,
                        ),
                        itemCount: SocialCubit.get(context).messages.length,
                      ),
                    ),
                    Spacer(),
                    Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),

                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                              child: TextFormField(
                                controller: messageController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'type your message here ...',
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 50.0,
                            color: baseColor,
                            child: MaterialButton(
                              onPressed: () {
                                SocialCubit.get(context).sendMessage(
                                  receiverId: userModel.uId,
                                  dateTime: DateTime.now().toString(),
                                  text: messageController.text,
                                );
                                //SocialCubit.get(context).logout(context);
                                // print('the uid issssss: ');
                                // print(uId);
                                // SocialCubit.get(context).logout(context);
                                // print('the uid issssss: ');
                                // print(uId);
                              },
                              minWidth: 1.0,
                              child: Icon(
                                Icons.send,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(MessageModel model) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadiusDirectional.only(
          bottomEnd: Radius.circular(10),
          topEnd: Radius.circular(10),
          topStart: Radius.circular(10),
        ),
      ),
      padding: EdgeInsetsDirectional.symmetric(vertical: 5, horizontal: 10),
      child: Text('${model.text}'),
    ),
  );

  Widget buildMyMessage(MessageModel model) => Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      decoration: BoxDecoration(
        color: baseColor.withAlpha((0.2 * 255).toInt()),
        borderRadius: BorderRadiusDirectional.only(
          bottomStart: Radius.circular(10),
          topEnd: Radius.circular(10),
          topStart: Radius.circular(10),
        ),
      ),
      padding: EdgeInsetsDirectional.symmetric(vertical: 5, horizontal: 10),
      child: Text('${model.text}'),
    ),
  );
}
