
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/component/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../../shared/style/colors.dart';
import '../new_post/new_post_screen.dart';

class SocialLayout extends StatelessWidget {
  SocialLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (BuildContext context, Object? state) {
        if(state is SocialNewPostState) {
          navigateTo(to: NewPostScreen(), context: context);
        }
      },
      builder: (BuildContext context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              cubit.titles[cubit.currentIndex],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                  onPressed: () {}, icon: Icon(Icons.notifications_none)),
              IconButton(onPressed: () {
                cubit.logout(context);
              }, icon: Icon(Icons.search))
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNav(index);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.chat_rounded), label: 'Chats'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.file_upload_outlined), label: 'Post'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.location_history), label: 'Users'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Settings')
            ],
            selectedItemColor: baseColor,
            unselectedItemColor: Colors.grey,
            elevation: 20.0,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
          ),
        );
      },
    );
  }
}
