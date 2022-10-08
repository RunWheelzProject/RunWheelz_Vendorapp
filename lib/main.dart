import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/manager/preferred_mechanic_manager.dart';
import 'package:untitled/manager/service_request_manager.dart';
import 'package:untitled/manager/vendor_works_manager.dart';
import 'package:untitled/screens/breakdown_services.dart';
import 'package:untitled/screens/current_offers.dart';
import 'package:untitled/screens/customer_board.dart';
import 'package:untitled/screens/customer_registration_screen.dart';
import 'package:untitled/screens/firebase_authentication.dart';
import 'package:untitled/screens/general_services_screen.dart';
import 'package:untitled/screens/login_confirm.dart';
import 'package:untitled/screens/login_page_screen.dart';
import 'package:untitled/screens/offer_screen.dart';
import 'package:untitled/screens/profile.dart';
import 'package:untitled/screens/request_status_screen.dart';
import 'package:untitled/screens/rw_management_screen.dart';
import 'package:untitled/screens/rw_mgmt_marketing_agent_screen.dart';
import 'package:untitled/screens/rw_vendor_management_screen.dart';
import 'package:untitled/screens/splashscreen.dart';
import 'package:untitled/screens/splashscreen_v1.dart';
import 'package:untitled/screens/test_screen.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import 'package:untitled/screens/vendor_inprogrees_screen.dart';
import 'package:untitled/screens/vendor_mechanic_accept_screen.dart';
import 'package:untitled/screens/vendor_mechanic_dashboard.dart';
import 'package:untitled/screens/vendor_pending_screen.dart';
import 'package:untitled/screens/vendor_registration_screen_v1.dart';
import 'package:untitled/screens/vendor_request_accept_screen.dart';
import 'package:untitled/screens/vendor_works.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/manager/login_manager.dart';
import 'package:untitled/manager/manager.dart';
import 'package:untitled/manager/location_manager.dart';
import 'package:untitled/manager/vendor_manager.dart';
import './theme/theme_manager.dart';
import './theme/themes.dart';
import 'manager/customer_managere.dart';
import 'manager/live_tracker_manager.dart';
import 'manager/profile_manager.dart';
import 'manager/roles_manager.dart';
import 'manager/staff_manager.dart';
import 'manager/vendor_mechanic_manager.dart';
import 'package:http/http.dart' as http;
import '../resources/resources.dart' as res;

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'model/customer.dart';
import 'model/servie_request.dart';
import 'model/vendor_mechanic.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
FirebaseMessaging? messaging;
AndroidNotificationChannel? channel;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  log("Handling a background message: ${message.messageId}");
  if (message.notification != null ) {
    var data = message.data;
    //_handleMessage(data);
  }
}

void _handleMessage(data) async {
  int id = int.parse(data["id"] ?? "");


  SharedPreferences prefs = await SharedPreferences.getInstance();

  http.Response response;
  ServiceRequestArgs? serviceRequestArgs;
  var offersJson;


  if (data["screen"] == "mechanic_accept" ||
      data["screen"] == "vendor_accept") {
    response = await http.get(
        Uri.parse("${res.APP_URL}/api/servicerequest/service_request/$id"));
    var serviceJson = jsonDecode(response.body);
    response = await http.get(Uri.parse(
        "${res.APP_URL}/api/customer/${serviceJson["requestedCustomer"]}"));
    var customerJson = jsonDecode(response.body);
    serviceRequestArgs = ServiceRequestArgs(
        id: serviceJson["id"],
        serviceType: serviceJson["serviceType"],
        make: serviceJson["make"],
        vehicleNumber: serviceJson["vehicleNumber"],
        latitude: serviceJson["latitude"],
        longitude: serviceJson["longitude"],
        acceptedByVendor: serviceJson["acceptedByVendor"],
        assignedToMechanic: serviceJson["assignedToMechanic"],
        status: serviceJson["status"],
        comments: serviceJson["comments"],
        customerArgs: CustomerArgs(id: customerJson["id"],
            name: customerJson["name"],
            phoneNumber: customerJson["phoneNumber"]));

    await prefs.remove("ServiceRequestArgs");
    await prefs.setString("ServiceRequestArgs", jsonEncode(serviceRequestArgs));
  } else {
    response = await http.get(Uri.parse("${res.APP_URL}/api/offers/$id"));
    offersJson = jsonDecode(response.body);
    await prefs.remove("offersJson");
    await prefs.setString("offersJson", jsonEncode(offersJson));
  }


  if ((prefs.getBool("SHARED_LOGGED") != null)) {
    bool isLoggedIn = prefs.getBool("SHARED_LOGGED") as bool;
    log("isLogged: $isLoggedIn");
    if (isLoggedIn) {
      if (data["screen"] == "vendor_accept") {
        navigatorKey.currentState?.pushNamed('/vendor_accept_screen',
            arguments: serviceRequestArgs
        );
      }else if (data["screen"] == "mechanic_accept") {
        navigatorKey.currentState?.pushNamed('/mechanic_accept_screen',
            arguments: serviceRequestArgs
        );
      } else if (data["screen"] == "new_offer") {
        log("new_offer");
        log(jsonEncode(offersJson));
        navigatorKey.currentState?.pushNamed('/new_offer',
            arguments: offersJson
        );
      }
    } else {
      navigatorKey.currentState?.pushNamed('/ask_login');
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const RunWheelz());
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


  void fireBaseInstallation() async {
    messaging = FirebaseMessaging.instance;

    // while app running in background

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin?.
    resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel as AndroidNotificationChannel);


  }

  @override
  void initState() {
    super.initState();
    fireBaseInstallation();

    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin?.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification
    );

    setupInteractedMessage();

    // while application in foreground but not terminated

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      RemoteNotification? remoteNotification = message.notification;
      AndroidNotification? android = message.notification?.android;

      log("test: ${message.notification}, ${message.data["id"]}");

      if (remoteNotification != null && android != null ) {
        String action = jsonEncode(message.data);

        log('Got a message whilst in the foreground!');
        log('Message data: ${message.data}, ${message.notification}');
        flutterLocalNotificationsPlugin?.show(
            remoteNotification.hashCode,
            remoteNotification.title,
            remoteNotification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel!.id,
                channel!.name,
                channel!.description,
                icon: android.smallIcon,
                priority: Priority.high,
                importance: Importance.max,
                setAsGroupSummary: true,
                styleInformation: const DefaultStyleInformation(true, true),
                largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
                channelShowBadge: true,
                autoCancel: true,
              ),
            ),
            payload: action);
      }

      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}, ${message.notification}');

    });

    themeManager.addListener(themeListener);
  }

  Future<Map<String, dynamic>> _handleRemoteMessage(RemoteMessage message) async {
    Map<String, dynamic> data = message.data;
    int id = int.parse(data["id"] ?? "");

    http.Response response = await http.get(Uri.parse("${res.APP_URL}/api/servicerequest/service_request/$id"));
    var serviceJson = jsonDecode(response.body);
    response = await http.get(Uri.parse("${res.APP_URL}/api/customer/${serviceJson["requestedCustomer"]}"));
    var customerJson = jsonDecode(response.body);

    ServiceRequestArgs serviceRequestArgs = ServiceRequestArgs(
        id: serviceJson["id"],
        serviceType: serviceJson["serviceType"],
        make: serviceJson["make"],
        vehicleNumber: serviceJson["vehicleNumber"],
        latitude: serviceJson["latitude"],
        longitude: serviceJson["longitude"],
        acceptedByVendor: serviceJson["acceptedByVendor"],
        assignedToMechanic: serviceJson["assignedToMechanic"],
        status: serviceJson["status"],
        comments: serviceJson["comments"],
        customerArgs: CustomerArgs(id: customerJson["id"], name: customerJson["name"], phoneNumber: customerJson["phoneNumber"]));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("ServiceRequestArgs");
    await prefs.setString("ServiceRequestArgs", jsonEncode(serviceRequestArgs));

    Map<String, dynamic> result = {"isLoggedIn": false, "screen": data["screen"]};


    if ((prefs.getBool("SHARED_LOGGED") != null)) {
      result["isLoggedIn"] = prefs.getBool("SHARED_LOGGED") as bool;
    }

    return result;
  }


  Future<dynamic> onSelectNotification(payload) async {
    Map<String, dynamic> action = jsonDecode(payload);
    _handleMessage(action);
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    log("iam working");
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    String action = jsonEncode(initialMessage?.data);

    if (initialMessage != null) {
      _handleRemoteMessage(initialMessage).then((res) {
        log(jsonEncode(res));
        if (res["isLoggedIn"]) {
          if (res["screen"] == "vendor_accept") {
            Navigator.pushNamed(context, '/vendor_accept_screen');
          } else if (res["screen"] == "mechanic_accept") {
            Navigator.pushNamed(context, '/mechanic_accept_screen');
          }
        } else {
          navigatorKey.currentState?.pushNamed('/ask_login');
        }
      });
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleRemoteMessage);
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
        ChangeNotifierProvider<RoleManager>(create: (context) => RoleManager()),
        ChangeNotifierProvider<StaffManager>(create: (context) => StaffManager()),
        ChangeNotifierProvider<CustomerManager>(create: (context) => CustomerManager()),
        ChangeNotifierProvider<LocationManager>(create: (context) => LocationManager()),
        ChangeNotifierProvider<ApplicationManager>(create: (context) => ApplicationManager()),
        ChangeNotifierProvider<VendorManager>(create: (context) => VendorManager()),
        ChangeNotifierProvider<LogInManager>(create: (context) => LogInManager()),
        ChangeNotifierProvider<ProfileManager>(create: (context) => ProfileManager()),
        ChangeNotifierProvider<VendorMechanicManager>(create: (context) => VendorMechanicManager()),
        ChangeNotifierProvider<ServiceRequestManager>(create: (context) => ServiceRequestManager()),
        ChangeNotifierProvider<LiveTrackerManager>(create: (context) => LiveTrackerManager()),
        ChangeNotifierProvider<PreferredMechanicManager>(create: (context) => PreferredMechanicManager()),
        ChangeNotifierProvider<VendorWorksManager>(create: (context) => VendorWorksManager())
      ],
      child: FirebasePhoneAuthProvider(
        child: MaterialApp(
            title: 'Flutter Demo',
            navigatorKey: navigatorKey,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeManager.themeMode,
            //home: const SplashScreen(),
            initialRoute: '/',
            routes: {
              '/': (context) => SplashScreenV1(),
              '/ask_login': (context) => SplashScreenV1(),
              '/phone_verification': (context) => const LoginScreen(),
              '/vendor_dashboard': (context) => const VendorDashBoard(),
              '/customer_dashboard': (context) => CustomerDashBoard(isCustomer: true,),
              '/mechanic_dashboard': (context) => VendorMechanicDashBoard(requestId: ''),
              '/staff_dashboard': (context) => const RunWheelManagementPage(),
              '/new_offer': (context) => RunWheelzOffer(),
              '/offers_screen': (context) => CurrentOffersScreen(),
              VendorRequestAcceptScreen.routeName: (context) => VendorRequestAcceptScreen(),
              VendorMechanicRequestAcceptScreen.routeName: (context) => const VendorMechanicRequestAcceptScreen()
            },
          ),
        )
    );
  }
}