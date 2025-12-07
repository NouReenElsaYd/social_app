import 'package:app_social/services/local_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService{
 static FirebaseMessaging messaging = FirebaseMessaging.instance;

 static Future init() async{
    await messaging.requestPermission();
    String? token = await messaging.getToken();
    //background
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
    //foreground => when the app opened
    FirebaseMessaging.onMessage.listen((message){
      //show local notification
      LocalNotificationService.showBasicNotification(message);
    });

  }
static Future<void> backgroundMessageHandler(RemoteMessage message)async {}


}