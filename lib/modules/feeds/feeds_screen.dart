import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/post_model.dart';
import '../../shared/component/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../../shared/style/colors.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (BuildContext context, Object? state) {},
      builder: (BuildContext context, state) {
        if (SocialCubit.get(context).posts.isNotEmpty &&
            SocialCubit.get(context).userModel != null) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Card(
                  elevation: 5.0,
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.all(8.0),
                  child: Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      Image(
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          'https://img.freepik.com/free-photo/low-angle-view-unrecognizable-muscular-build-man-preparing-lifting-barbell-health-club_637285-2497.jpg?t=st=1738765548~exp=1738769148~hmac=d2ec4cfff9f038fcb4ab87118d8ca9db75470564640dde4c577b9e4eaf101a86&w=740',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Communicate with friends',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder:
                      (context, index) => buildPostItem(
                        SocialCubit.get(context).posts[index],
                        context,
                        index,
                      ),
                  itemCount: SocialCubit.get(context).posts.length,
                  separatorBuilder: (context, index) => SizedBox(height: 10.0),
                ),
                SizedBox(height: 8.0),
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildPostItem(PostModel model, context, index) => Card(
    color: Colors.white,
    elevation: 3.0,
    clipBehavior: Clip.antiAlias,
    margin: EdgeInsets.symmetric(horizontal: 8.0),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage('${model.image}'),
                radius: 25.0,
              ),
              SizedBox(width: 15.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${model.name}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Icon(Icons.check_circle, color: baseColor, size: 15.0),
                      ],
                    ),
                    Text(
                      '${model.dateTime}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   width: 15.0,
              // ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_horiz, size: 20),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey[300],
            ),
          ),
          Text(
            '${model.text}',
            style: TextStyle(height: 1.3, fontWeight: FontWeight.w500),
          ),
          // Padding(
          //   //Tags
          //   padding: const EdgeInsets.only(bottom: 7.0),
          //   child: Container(
          //     width: double.infinity,
          //     child: Wrap(
          //       spacing: 5,
          //       children: [
          //         Container(
          //           height: 25.0,
          //           child: MaterialButton(
          //             onPressed: () {},
          //             minWidth: 1.0,
          //             padding: EdgeInsets.zero,
          //             child: Text(
          //               '#Software',
          //               style: TextStyle(color: baseColor, fontSize: 12),
          //             ),
          //           ),
          //         ),
          //         Container(
          //           height: 25.0,
          //           child: MaterialButton(
          //             onPressed: () {},
          //             minWidth: 1.0,
          //             padding: EdgeInsets.zero,
          //             child: Text(
          //               '#Software',
          //               style: TextStyle(color: baseColor, fontSize: 12),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          if (model.postImage != '')
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 15.0),
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  image: DecorationImage(
                    image: NetworkImage('${model.postImage}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            color: Colors.red,
                            size: 18.0,
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            '${SocialCubit.get(context).likes[index]}',
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.comment, color: Colors.amber, size: 18.0),
                          SizedBox(width: 5.0),
                          Text(
                            '${SocialCubit.get(context).commentsCount[index]} comment',
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, width: double.infinity, color: Colors.grey[300]),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: InkWell(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      '${SocialCubit.get(context).userModel?.image}',
                    ),
                    radius: 15.0,
                  ),
                  SizedBox(width: 15.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'write a comment ...',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    child: Row(
                      children: [
                        Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                          size: 18.0,
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          'Like',
                          style: TextStyle(fontSize: 13.0, color: Colors.grey),
                        ),
                      ],
                    ),
                    onTap: () {
                      SocialCubit.get(
                        context,
                      ).likePost(SocialCubit.get(context).postsId[index]);
                    },
                  ),
                  SizedBox(width: 15),
                  InkWell(
                    child: Row(
                      children: [
                        Icon(Icons.ios_share, color: Colors.green, size: 18.0),
                        SizedBox(width: 5.0),
                        Text(
                          'Share',
                          style: TextStyle(fontSize: 13.0, color: Colors.grey),
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                ],
              ),
              onTap: () {
                showSimpleBottomSheet(context, model.postId!);
              },
            ),
          ),
        ],
      ),
    ),
  );
}
