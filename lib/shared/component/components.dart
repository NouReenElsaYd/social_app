import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../style/colors.dart';

void navigateTo({required Widget to, required context}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => to));
}

void navigateAndFinish(widget, context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
    (Route<dynamic> route) => false,
  );
}

Widget defaultFormField({
  required TextEditingController controller,
  bool obscureText = false,
  required TextInputType type,
  required FormFieldValidator validate,
  required String lable,
  required IconData prefix,
  IconData? suffix,
  VoidCallback? onPressed,
  ValueChanged<String>? onSubmitted,
}) => TextFormField(
  controller: controller,
  obscureText: obscureText,
  keyboardType: type,
  validator: validate,
  onFieldSubmitted: onSubmitted,

  //onChanged: (value) {
  //passwordController.text=value;
  // },
  decoration: InputDecoration(
    border: const OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: baseColor, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: baseColor)),
    labelText: lable,
    prefixIcon: Icon(prefix),
    suffixIcon: IconButton(icon: Icon(suffix), onPressed: onPressed),
  ),
);
Widget defaultButton({
  required String text,
  required VoidCallback function,
  Color? color,
  double hight = 40,
  double width = double.infinity,
  Color? fontColor,
}) => Container(
  width: double.infinity,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(4),
    color: color,
  ),
  child: MaterialButton(
    onPressed: function,
    child: Text(text, style: TextStyle(color: fontColor)),
  ),
);

Widget defaultTextButton({
  required VoidCallback function,
  required String text,
}) => TextButton(
  onPressed: function,
  child: Text(text, style: TextStyle(color: baseColor)),
);

// void showToast({required String message, required ToastStates state}) =>
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_LONG, //android
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 5, //IOS and Web
//       backgroundColor: changeToastColor(state),
//       textColor: Colors.white,
//       fontSize: 16.0,
//     );

enum ToastStates { SUCCESS, ERROR, WARNING }

Color changeToastColor(ToastStates state) {
  late Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.greenAccent;
      break;

    case ToastStates.ERROR:
      color = Colors.red;
      break;

    case ToastStates.WARNING:
      color = Colors.amberAccent;
      break;
  }
  return color;
}

Widget defaultOutlinedButton({
  double radius = 4,
  required Widget widget,
  required VoidCallback function,
}) => OutlinedButton(
  style: OutlinedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius), // Set border radius here
    ),
    foregroundColor: Colors.blue,
    side: BorderSide(color: defaultGray, width: 1),

    //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  ),
  onPressed: function,
  child: widget,
);

PreferredSizeWidget defaultAppBar({
  required BuildContext context,
  String title = '',
  List<Widget>? actions,
}) => AppBar(
  leading: IconButton(
    onPressed: () {
      Navigator.pop(context);
    },
    icon: const Icon(Icons.arrow_back_ios),
  ),
  title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
  titleSpacing: 0.0,
  actions: actions,
);

Future showSimpleBottomSheet(BuildContext context, String postId) {
  var commentController = TextEditingController();

  SocialCubit.get(context).getComments(postId); // ✅ Fetch comments using the passed postId

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
    ),
    builder: (context) {
      double sheetHeight = MediaQuery.of(context).size.height -
          AppBar().preferredSize.height -
          MediaQuery.of(context).padding.top;

      return Container(
        padding: const EdgeInsets.all(15),
        height: sheetHeight,
        child: Column(
          children: [
            const Text(
              "Comments",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // ✅ Display comments
            Expanded(
              child: BlocBuilder<SocialCubit, SocialStates>(
                builder: (context, state) {
                  var comments = SocialCubit.get(context).postComments[postId] ?? [];

                  return state is SocialGetAllCommentsLoadingState
                      ? const Center(child: CircularProgressIndicator()) // ✅ Show loader
                      : comments.isEmpty
                      ? const Center(child: Text("No comments yet.")) // ✅ No comments message
                      : ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      var comment = comments[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(comment.image ?? ''),
                          radius: 20.0,
                        ),
                        title: Text(comment.name ?? 'Unknown',style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(comment.comment ?? ''),
                      );
                    },
                  );
                },
              ),
            ),

            // ✅ Comment Input Field
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300, width: 0.5)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        '${SocialCubit.get(context).userModel?.image}'),
                    radius: 15.0,
                  ),
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: TextFormField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: "Write a comment...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      if (commentController.text.trim().isNotEmpty) {
                        SocialCubit.get(context).commentOnPost(
                          postId, // ✅ Use the passed postId
                          commentController.text.trim(),
                        );
                        commentController.clear(); // ✅ Clear input after submission
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget myDivider() => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Container(height: 1.0, color: Colors.grey),
);
