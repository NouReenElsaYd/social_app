
import 'package:app_social/services/local_notification_service.dart';
import 'package:app_social/services/push_notification_service.dart';
import 'package:app_social/shared/bloc_observer.dart';
import 'package:app_social/shared/component/constants.dart';
import 'package:app_social/shared/cubit/cubit.dart';
import 'package:app_social/shared/network/local/cache_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'firebase_options.dart';
import 'modules/layout/social_layout.dart';
import 'modules/login/login_screen.dart';

void main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await PushNotificationService.init();
  await LocalNotificationService.init();

 var token = await FirebaseMessaging.instance.getToken();

 print(token);

 await FirebaseMessaging.onMessageOpenedApp.listen((event){
   print(event.data.toString());
 });

  // ✅ Ensure uId is always a String
  uId = CacheHelper.getData(key: 'uId') ?? '';

  if (uId.isEmpty) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      uId = user.uid;
      CacheHelper.saveData(key: 'uId', value: uId);
    }

  }


  Widget startWidget = (uId.isNotEmpty)
      ? SocialLayout()
      : LoginScreen();

  runApp(MyApp(startWidget: startWidget));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.startWidget});
  final Widget startWidget;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialCubit()..getUserData()..getPosts(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: startWidget
      ),
    );
  }
}
