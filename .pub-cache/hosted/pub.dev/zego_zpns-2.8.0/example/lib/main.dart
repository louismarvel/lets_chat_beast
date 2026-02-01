import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zego_zpns/zego_zpns.dart';
import 'package:zego_zim/zego_zim.dart';


@pragma('vm:entry-point')
Future<void> _zpnsMessagingBackgroundHandler(ZPNsMessage message) async{
  print("good job");
}

void main() async {
  runApp(const MyApp());
  if (kIsWeb) {
    ZIMAppConfig appConfig = ZIMAppConfig();
    appConfig.appID = 0;
    appConfig.appSign = "";

    ZIM.create(appConfig);
    return;
  }
  // CallKit.setInitConfiguration(CXProviderConfiguration(localizedName: 'localizedName',iconTemplateImageName: '211'));
  // ZPNsEventHandler.onRegistered = (ZPNsRegisterMessage registerMessage) {
  //   log(registerMessage.errorCode.toString());
  // };
  // CallKitEventHandler.performAnswerCallAction = (CXAction action){
  //   log('answter');
  //   action.fulfill();
  // };
  // CallKitEventHandler.didReceiveIncomingPush = (Map extras, UUID uuid){
  //   log('didReceive');
  // };
  ZPNs.setBackgroundMessageHandler(_zpnsMessagingBackgroundHandler);
  ZPNsConfig config = ZPNsConfig();
  config.enableFCMPush = true;
  ZPNs.setPushConfig(config);
  // Request notification rights from the user when appropriate,iOS only
  ZPNs.getInstance().applyNotificationPermission();
  // Select an ZPNsIOSEnvironment value based on the iOS development/Distribution certificate.Change this enum when switching certificates
  ZPNs.getInstance()
      .registerPush(iOSEnvironment: ZPNsIOSEnvironment.Development,enableIOSVoIP: true)
      .catchError((onError) {
    if (onError is PlatformException) {
      //Notice exception here
      log(onError.message ?? "");
    }
  });
  ZPNsEventHandler.onNotificationClicked = (ZPNsMessage zpnsMessage) {
    if (zpnsMessage.pushSourceType == ZPNsPushSourceType.APNs) {
      Map aps = Map.from(zpnsMessage.extras['aps'] as Map);
      String payload = aps['payload'];
      log("My payload is $payload");
    } else if (zpnsMessage.pushSourceType == ZPNsPushSourceType.FCM) {
      // FCM does not support this interface,please use Intent get payload at Android Activity.
    }
    log("user clicked the offline push notification,title is ${zpnsMessage.title},content is ${zpnsMessage.content}");
  };
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(children: [
          GestureDetector(
            // When the child is tapped, show a snackbar.
            onTap: () {
              ZPNsWebConfig config = ZPNsWebConfig();
              config.apiKey = "";
              config.authDomain = "";
              config.projectID = "";
              config.storageBucket = "";
              config.messagingSenderID = "";
              config.appID = "";
              config.measurementID = "";
              config.vapidKey = "";
              ZPNs.getInstance().registerPush(webConfig: config);
            },
            // The custom button
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('register'),
            ),
          ),
          GestureDetector(
            // When the child is tapped, show a snackbar.
            onTap: () {
              ZIMUserInfo userInfo = ZIMUserInfo();
              String token = "";
              userInfo.userID = "";
              userInfo.userName = "";
              ZIM.getInstance()!.login(userInfo, token);
            },
            // The custom button
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('login'),
            ),
          ),
        ],)
      ),
    );
  }
}
