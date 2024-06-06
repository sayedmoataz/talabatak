import 'package:flutter/material.dart';
import 'features/PhoneAuth/phone_screen.dart';
import 'features/ProfileScreens/change_password_screen.dart';
import 'features/ProfileScreens/profile_screen.dart';
import 'features/login_screen.dart';
import 'features/notification_screen.dart';
import 'features/setting_screen.dart';
import 'features/signup_scren.dart';
import 'features/theme_screen.dart';

import 'features/OrderScreens/my_orders_screen.dart';
import 'features/ProfileScreens/edit_profile_screen.dart';
import 'features/faqs_screen.dart';
import 'features/layout/bottomNavigation_layout.dart';
import 'features/layout/forgetPassword_screen.dart';
import 'features/on_boarding_screen.dart';
import 'features/privacy_screen.dart';
import 'features/splash_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (context) => BottomNavigation());
      case Routes.welcomeScreen:
        return MaterialPageRoute(builder: (context) => OnBoardingScreen());
      case Routes.settingPage:
        return MaterialPageRoute(builder: (context) => SettingsScreen());
      case Routes.loginPage:
        return MaterialPageRoute(builder: (context) => LoginView());
      case Routes.signUpPage:
        return MaterialPageRoute(builder: (context) => RegisterScreen());
      case Routes.forgetPage:
        return MaterialPageRoute(builder: (context) => ForgetView());
      case Routes.faqsPage:
        return MaterialPageRoute(builder: (context) => FAQsScreen());
      case Routes.privacyPage:
        return MaterialPageRoute(builder: (context) => InstructionsScreen());
      case Routes.profilePage:
        return MaterialPageRoute(builder: (context) => ProfileScreen());
      case Routes.identificationScreen:
      case Routes.themeScreen:
        return MaterialPageRoute(builder: (context) => ThemeScreen());
      case Routes.smsPage:
        return MaterialPageRoute(builder: (context) => PhoneRegPage());
      case Routes.notificationScreen:
        return MaterialPageRoute(builder: (context) => NotificationScreen());
      case Routes.editProfilePage:
        return MaterialPageRoute(builder: (context) => EditProfileScreen());
      case Routes.changePasswordPage:
        return MaterialPageRoute(builder: (context) => ChangePassword());
      case Routes.myOrders:
        return MaterialPageRoute(builder: (context) => MyOrdersScreen());
      default:
        return null;
    }
  }
}

class Routes {
  static const splashScreen = '/splashScreen';
  static const welcomeScreen = '/welcomeScreen';
  static const homeScreen = '/homeScreen';
  static const settingPage = '/setting-page';
  static const loginPage = '/loginPage';
  static const smsPage = '/smsPage';

  static const signUpPage = '/signUpPage';
  static const forgetPage = '/forgetPage';
  static const faqsPage = '/faqsPage';
  static const privacyPage = '/privacyPage';
  static const profilePage = '/profilePage';
  static const editProfilePage = '/editProfilePage';
  static const changePasswordPage = '/changePasswordPage';
  static const walletPage = '/changePasswordPage';

  static const verifyAccount = '/verifyPage';
  static const tasksScreen = '/tasksScreen';
  static const updateTaskScreen = '/updateTaskScreen';
  static const discussScreen = '/discussScreen';
  static const myDiscussScreen = '/myDiscussScreen';
  static const addDiscussScreen = '/addDiscussScreen';
  static const companyReviewScreen = '/companyReviewScreen';
  static const addReviewScreen = '/addReviewScreen';
  static const addFreelanceScreen = '/addFreelanceScreen';
  static const myServicecreen = '/myServicecreen';
  static const myOrders = '/myOrders';

  static const myJobScreen = '/myJobScreen';
  static const addJobScreen = '/addJobScreen';
  static const applicationScreen = '/applicationScreen';
  static const identificationScreen = '/identificationScreen';
  static const themeScreen = '/themeScreen';
  static const notificationScreen = '/notificationScreen';
  static const chatAdminScreen = '/chatAdminScreen';
  static const chatBotScreen = '/chatBotScreen';
  static const congratsScreen = '/congratsScreen';
  static const addRefScreen = '/addRefScreen';
  static const addServiceScreen = '/addServiceScreen';

  static const myRefscreen = '/myRefscreen';
  static const favScreenn = '/FavoritesScreen';
}
