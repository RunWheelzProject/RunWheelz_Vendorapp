import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:untitled/manager/service_request_manager.dart';
import 'package:untitled/screens/breakdown_services.dart';
import 'package:untitled/screens/customer_board.dart';
import 'package:untitled/screens/customer_registration_screen.dart';
import 'package:untitled/screens/general_services_screen.dart';
import 'package:untitled/screens/login_confirm.dart';
import 'package:untitled/screens/login_page_screen.dart';
import 'package:untitled/screens/profile.dart';
import 'package:untitled/screens/request_status_screen.dart';
import 'package:untitled/screens/rw_mgmt_marketing_agent_screen.dart';
import 'package:untitled/screens/rw_vendor_management_screen.dart';
import 'package:untitled/screens/splashscreen.dart';
import 'package:untitled/screens/test_screen.dart';
import 'package:untitled/screens/vendor_inprogrees_screen.dart';
import 'package:untitled/screens/vendor_mechanic_accept_screen.dart';
import 'package:untitled/screens/vendor_pending_screen.dart';
import 'package:untitled/screens/vendor_registration_screen_v1.dart';
import 'package:untitled/screens/vendor_request_accept.screen.dart';
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
    _handleMessage(data);
  }
}


void _handleMessage(data) async {
  int id = int.parse(data["id"] ?? "");

  http.Response response = await http.get(
      Uri.parse("${res.APP_URL}/api/servicerequest/service_request/$id"));
  var serviceJson = jsonDecode(response.body);
  log("customerJson: ${serviceJson["requestedCustomer"]}");
  response = await http.get(Uri.parse(
      "${res.APP_URL}/api/customer/${serviceJson["requestedCustomer"]}"));
  var customerJson = jsonDecode(response.body);

  log("customerJson: $customerJson");

  if (data["screen"] == "vendor_accept") {
    navigatorKey.currentState?.pushNamed('/vendor_accept_screen',
        arguments: ServiceRequestArgs(
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
                phoneNumber: customerJson["phoneNumber"])
        )
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

    await FirebaseMessaging.instance
        .getInitialMessage()
        .then((value) =>
        _handleMessage(value?.notification?.body ?? "1"));

    String? token = await FirebaseMessaging.instance.getToken();
    log("$token");

    /*await FirebaseMessaging.instance
      .getInitialMessage()
      .then((value) =>
      _handleMessage(value?.notification?.body ?? "1"));
*/

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

      /*if (message.notification != null) {
        log('body: ${message.notification?.body}');
        int id = int.parse(message.notification?.body ?? "");
        navigatorKey.currentState?.pushNamed('/vendor_accept_screen', arguments: ServiceRequestArgs(requestID: id));
        log('Message also contained a notification: ${message.notification?.title}');
      }*/
    });

    setupInteractedMessage();

    FirebaseMessaging.onMessageOpenedApp
        .listen((message) => _handleMessage(message.notification?.body ?? ""));

    themeManager.addListener(themeListener);
  }

  Future<dynamic> onSelectNotification(payload) async {
    Map<String, dynamic> action = jsonDecode(payload);
    _handleMessage(action);
  }

  Future<void> setupInteractedMessage() async {
    await FirebaseMessaging.instance
        .getInitialMessage()
        .then((value) =>
        _handleMessage(value?.notification?.body ?? "1"));
  }

  void _handleMessage(data) async {
    int id = int.parse(data["id"] ?? "");

    http.Response response = await http.get(Uri.parse("${res.APP_URL}/api/servicerequest/service_request/$id"));
    var serviceJson = jsonDecode(response.body);
    log("customerJson: ${serviceJson["requestedCustomer"]}");
    response = await http.get(Uri.parse("${res.APP_URL}/api/customer/${serviceJson["requestedCustomer"]}"));
    var customerJson = jsonDecode(response.body);

    log("customerJson: $customerJson");

   /* ServiceRequestManager serviceRequestManager = Provider.of<ServiceRequestManager>(context, listen: false);
    serviceRequestManager.serviceRequestDTO = ServiceRequestDTO.fromJson(serviceJson);
    serviceRequestManager.serviceRequestDTO.customerDTO = Customer.fromJson(customerJson);
*/
    if (data["screen"] == "vendor_accept") {
      navigatorKey.currentState?.pushNamed('/vendor_accept_screen',
          arguments: ServiceRequestArgs(
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
            customerArgs: CustomerArgs(id: customerJson["id"], name: customerJson["name"], phoneNumber: customerJson["phoneNumber"])
          )
      );
    }

    if (data["screen"] == "mechanic_accept") {
      navigatorKey.currentState?.pushNamed('/mechanic_accept_screen',
          arguments: ServiceRequestArgs(
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
              customerArgs: CustomerArgs(id: customerJson["id"], name: customerJson["name"], phoneNumber: customerJson["phoneNumber"])
          )
      );
    }

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
        ChangeNotifierProvider<LiveTrackerManager>(create: (context) => LiveTrackerManager())
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
          '/': (context) => LogInConfirmation(),
          '/phone_verification': (context) => const LoginScreen(),
          VendorRequestAcceptScreen.routeName: (context) => const VendorRequestAcceptScreen(),
          VendorMechanicRequestAcceptScreen.routeName: (context) => const VendorMechanicRequestAcceptScreen()
        },
      ),
    );
  }
}