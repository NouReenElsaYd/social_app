import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_model.dart';
import '../../shared/component/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../chat_details/chat_details_screen.dart';


class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        if (SocialCubit.get(context).users.isNotEmpty) {
          return ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder:
                (context, index) => buildChatItem(
                  SocialCubit.get(context).users[index],
                  context,
                ),
            itemCount: SocialCubit.get(context).users.length,
            separatorBuilder: (context, index) => myDivider(),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildChatItem(UserModel model, context) => InkWell(
    onTap: () {
      navigateTo(to: ChatDetailsScreen(userModel: model), context: context);
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage('${model.image}'),
            radius: 25.0,
          ),
          SizedBox(width: 15.0),
          Text(
            '${model.name}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              height: 1.3,
            ),
          ),
          // SizedBox(
          //   width: 15.0,
          // ),
          Spacer(),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz, size: 20)),
        ],
      ),
    ),
  );
}
