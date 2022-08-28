import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:untitled/manager/service_request_manager.dart';
import 'package:untitled/screens/login_page_screen.dart';
import 'package:untitled/screens/rw_vendor_management_screen.dart';
import 'package:untitled/screens/splashscreen.dart';
import 'package:untitled/screens/test_screen.dart';
import 'package:untitled/screens/vendor_inprogrees_screen.dart';
import 'package:untitled/screens/vendor_pending_screen.dart';
import 'package:untitled/screens/vendor_registration_screen_v1.dart';
import 'package:untitled/screens/vendor_request_accept.screen.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/manager/login_manager.dart';
import 'package:untitled/manager/manager.dart';
import 'package:untitled/manager/location_manager.dart';
import 'package:untitled/manager/vendor_manager.dart';
import './theme/theme_manager.dart';
import './theme/themes.dart';
import 'manager/profile_manager.dart';
import 'manager/staff_manager.dart';
import 'manager/vendor_mechanic_manager.dart';


import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  log("Handling a background message: ${message.messageId}");
  if (message.notification != null ) {
    navigatorKey.currentState?.pushNamed('/vendor_accept_screen');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  String? token = await FirebaseMessaging.instance.getToken();
  log("$token");

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('Got a message whilst in the foreground!');
    log('Message data: ${message.data}');


    if (message.notification != null) {
      log('body: ${message.notification?.body}');
      navigatorKey.currentState?.pushNamed('/vendor_accept_screen');
      log('Message also contained a notification: ${message.notification?.title}');
    }
  });
  runApp(RunWheelz());
}

void _handleScreen() {

}
ThemeManager themeManager = ThemeManager();

class RunWheelz extends StatefulWidget {
  const RunWheelz({Key? key}) : super(key: key);


  @override
  RunWheelzState createState() => RunWheelzState();
}

class RunWheelzState extends State<RunWheelz> {

  @override
  void dispose() {
      super.dispose();
      themeManager.removeListener(themeListener);
  }

  @override
  void initState() {
    super.initState();
    themeManager.addListener(themeListener);
  }
  themeListener() {
    if (mounted) {
      setState(() => {} );
    }
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //ChangeNotifierProvider<RoleManager>(create: (context) => RoleManager()),
        ChangeNotifierProvider<StaffManager>(create: (context) => StaffManager()),
        ChangeNotifierProvider<LocationManager>(create: (context) => LocationManager()),
        ChangeNotifierProvider<ApplicationManager>(create: (context) => ApplicationManager()),
        ChangeNotifierProvider<VendorManager>(create: (context) => VendorManager()),
        ChangeNotifierProvider<LogInManager>(create: (context) => LogInManager()),
        ChangeNotifierProvider<ProfileManager>(create: (context) => ProfileManager()),
        ChangeNotifierProvider<VendorMechanicManager>(create: (context) => VendorMechanicManager()),
        ChangeNotifierProvider<ServiceRequestManager>(create: (context) => ServiceRequestManager())
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          navigatorKey: navigatorKey,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeManager.themeMode,
          //home: const SplashScreen(),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/phone_verification': (context) => const LoginScreen(),
          '/vendor_accept_screen': (context) => VendorRequestAcceptScreen()
        },
        ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: Container(
            color: Colors.white,
            width: 350,
            height: 300,
            padding: const EdgeInsets.all(30),
            child: OTPEntryBox(
              numOfFields: 6,
              onFieldTextChanged: (val) => log("fieldvalue: $val"),
              onCompleted: (val) => {
                log("_completedOTP: $val")
              },
            )
          )
        )
    );
  }

}

