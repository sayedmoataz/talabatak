import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/bloc/AuthCubit/auth_cubit.dart';
import 'package:news_app/core/network/local/DbHelper.dart';
import 'package:news_app/firebase_options.dart';
import 'package:news_app/theme/custom_theme.dart';
import 'package:sizer/sizer.dart';

import 'Router.dart';
import 'bloc/bloc_observer.dart';
import 'bloc/cubit/app_cubit.dart';
import 'bloc/cubit/app_states.dart';
import 'core/network/remote/dio_helper.dart';

String? Fcmtoken;
bool enableNotification = true;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CacheHelper.init();
  bool firstMode = CacheHelper.getData(key: "isLight") ?? true;
  CacheHelper.saveIntData(key: 'homePath', value: 1);
//  await  CacheHelper.sharedPreferences!.remove( 'CityId');
  DioHelper.init();
  if (CacheHelper.getData(key: "isLogged") == null) {
    CacheHelper.saveBoolData(key: "isLogged", value: false);
  }

  await EasyLocalization.ensureInitialized();
  await Future.delayed(Duration(seconds: 2));
  await firebaseMessaging.getToken().then((token) {
    Fcmtoken = token;
    print("Fcmtoken" + Fcmtoken!);
  }).catchError((e) {
    log('firebaseMessaging.getToken() error is: $e');
  });
  log(Fcmtoken ?? 'test token');

  handleNotifications();

  BlocOverrides.runZoned(
    () {
      return runApp(MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => AuthCubit()
                ..isBiometricsAvailable()
                ..getUserData()),
          BlocProvider(
              create: (context) => AppCubit()
                ..getNumbers(context)
                ..getVendors(context)
                ..getSlider()
                ..getCategories()
                ..getProducts()
                ..getFirstMode(firstMode)
                ..checkNotificationSetting()
                ..getNotification()),
        ],
        child: EasyLocalization(
          child: MyApp(),
          supportedLocales: [
            Locale('en', 'US'),
            Locale('ar', 'IQ'),
            Locale('tr', 'TR')
          ],
          saveLocale: true,
          fallbackLocale: Locale('ar', 'IQ'),
          path: 'assets/languages',
        ),
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

handleNotifications() async {
  NotificationSettings settings =
      await firebaseMessaging.requestPermission(sound: true, alert: true);
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    log('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    log('User granted provisional permission');
  } else {
    log('User declined or has not accepted permission');
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await firebaseMessaging.subscribeToTopic("all");
  await firebaseMessaging.subscribeToTopic("customer");
  await firebaseMessaging.subscribeToTopic(
    "${CacheHelper.getData(key: 'email').replaceAll("@", '').replaceAll(".", '').replaceAll("-", '')}",
  );
}

void sendTokenToServer(String fcmToken) {
  print('Token: $fcmToken');
  // send key to your server to allow server to use
  // this token to send push notifications
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter appRouter = AppRouter();
  @override
  void initState() {
    super.initState();
    firebaseMessaging.onTokenRefresh.listen(sendTokenToServer);
    firebaseMessaging.getToken();

    firebaseMessaging.subscribeToTopic('all');
    if (CacheHelper.getData(key: 'email') != null) {
      firebaseMessaging.subscribeToTopic(
          "${CacheHelper.getData(key: 'email').replaceAll("@", '').replaceAll(".", '').replaceAll("-", '')}");
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: ${message.data}");
      final notification = message.notification;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessage: ${message.data}");
      final notification = message.notification;

      firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) => BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) => Sizer(builder:
            (BuildContext context, Orientation orientation, deviceType) {
          return MaterialApp(
            title: "طلباتك - Talabatek",
            debugShowCheckedModeBanner: false,
            themeMode: AppCubit.get(context).themeMode
                ? ThemeMode.dark
                : ThemeMode.light,
            theme: CustomTheme.lightTheme(context),
            darkTheme: CustomTheme.darkTheme(context),
            initialRoute: CacheHelper.getData(key: "firstOpen") != true
                ? Routes.welcomeScreen
                : Routes.splashScreen,
            onGenerateRoute: appRouter.onGenerateRoute,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              EasyLocalization.of(context)!.delegate,
            ],
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          );
        }),
      ),
    );
  }
}

//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