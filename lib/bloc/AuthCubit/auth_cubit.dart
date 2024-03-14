import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../Router.dart';
import '../../core/network/local/DbHelper.dart';
import '../../core/network/remote/biometric_helper.dart';
import '../../core/network/remote/dio_helper.dart';
import '../../features/PhoneAuth/otp_screen.dart';
import '../../main.dart';
import '../../models/country_model.dart';
import '../../models/notification_model.dart';
import '../../models/user_model.dart';
import '../../widgets/PopDialog.dart';
import '../cubit/app_cubit.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(InitialState());
  static AuthCubit get(context) => BlocProvider.of(context);

  //----------------------------------------------------------------------------

  bool isThemeContainerOpen = false;
  void changeThemeContainerStatus() {
    isThemeContainerOpen = !isThemeContainerOpen;
    emit(ChangeThemeContainerStatusState());
  }

  bool isLanguageContainerOpen = false;
  void changeLanguageContainerStatus() {
    isLanguageContainerOpen = !isLanguageContainerOpen;
    emit(ChangeLanguageContainerStatusState());
  }

  bool changeSign = false;
  void changeSignStatus() {
    changeSign = !changeSign;
    emit(ChangeLanguageContainerStatusState());
  }

  DateTime? dateTime;

  void changeOnDateTime(dateTime) {
    this.dateTime = dateTime;
    emit(ChangeDateState());
  }

  bool isPasswordObscure = true;
  IconData icon = Icons.visibility;
  void changePasswordVisibility() {
    isPasswordObscure = !isPasswordObscure;
    icon = isPasswordObscure ? Icons.visibility : Icons.visibility_off;
    emit(ChangePasswordVisibilityState());
  }

  bool isConfirmPasswordObscure = true;
  IconData confirmIcon = Icons.visibility;
  void changeConfirmPasswordVisibility() {
    isConfirmPasswordObscure = !isConfirmPasswordObscure;
    confirmIcon =
        isConfirmPasswordObscure ? Icons.visibility : Icons.visibility_off;
    emit(ChangePasswordVisibilityState());
  }

  bool isLoading = false;
  var verificationCode;
  Future phoneAuthApi(countryCode, phoneNumber, context) async {
    emit(LogInInitialState());
    int min = 100000;
    int max = 999999;

    Random random = Random();
    int? randomNum;
    print(countryCode + phoneNumber);
    print(randomNum);
    if (countryCode + phoneNumber == '972123456789') {
      randomNum = 123456;
      print(randomNum);
    } else {
      randomNum = min + random.nextInt(max - min + 1);
      print(countryCode + phoneNumber);
      print(randomNum);
    }
    String url =
        'https://www.tweetsms.ps/api.php?comm=sendsms&api_key=b396e922bd719f3404246cd2eed7ae74&to=${countryCode + phoneNumber}&message=${'Your code is : ' + randomNum.toString()}&sender=Talabatk';

    try {
      http.Response response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        // Request successful
        print(response.body);
        print('SMS sent');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpPage(
                      phoneNumber: countryCode + phoneNumber,
                      verificationCode: randomNum.toString(),
                    )));
        emit(LogInSuccessState());
      } else {
        // Request failed
        print('Failed to send SMS. Status code: ${response.statusCode}');
        emit(LogInErrorState());
      }
    } catch (e) {
      emit(LogInErrorState());
      print('Error sending SMS: $e');
    }
  }

  Future otpSignInApi(phoneNumber, verificationCode, code, context) async {
    emit(LogInInitialState());

    isLoading = true;
    if (verificationCode == code) {
      try {
        FirebaseFirestore _firestore = FirebaseFirestore.instance;

        isLoading = false;
        DioHelper.postData(
                url: "user/sms-login",
                data: CacheHelper.getData(key: 'fcm') == null
                    ? {
                        'phone': phoneNumber,
                        'fcm': Fcmtoken,
                      }
                    : {
                        'phone': phoneNumber,
                        'fcm': Fcmtoken,
                      })
            .then((value) async {
          if (value.statusCode == 200) {
            isLoading = false;

            print(value.data);
            CacheHelper.saveStringData(key: 'fcm', value: Fcmtoken);
            CacheHelper.saveStringData(
                key: 'username', value: value.data['user']['name']);
            CacheHelper.saveStringData(
                key: 'access', value: value.data['user']['token']);
            CacheHelper.saveStringData(key: 'phoneNumber', value: phoneNumber);

            getUserData(context: context);
            popDialog(
                context: context,
                title: 'Welcome Back'.tr(),
                content: 'Login Done Sucessfully'.tr(),
                boxColor: AppCubit.get(context).primaryColor);

            await _firestore.collection('Users').doc(phoneNumber).set({
              'phone': phoneNumber,
              'uid': phoneNumber,
              'fcm': Fcmtoken,
            });
            emit(LogInSuccessState());
            CacheHelper.saveBoolData(key: "isLogged", value: true);
            emit(SignUpSuccessState());
          } else {
            isLoading = false;

            print(value.data);
            Navigator.pop(context);
            popDialog(
                context: context,
                title: 'Something wrong happen'.tr(),
                content: value.toString(),
                boxColor: Colors.red);
            emit(LogInErrorState());
          }

          // createSnackBar(context,'Welcome Back ${value.user!.displayName}');
          isLoading = false;
        }).catchError((e) {
          isLoading = false;

          showToast(
            e.toString(),
            context: context,
            borderRadius: BorderRadius.circular(5),
            animation: StyledToastAnimation.scale,
            reverseAnimation: StyledToastAnimation.fade,
            animDuration: Duration(milliseconds: 250),
          );
          emit(LogInErrorState());
          print(e.toString());
        });
      } catch (e) {
        print(e.toString());
      }
    } else {
      popDialog(
          context: context,
          title: 'Otp code Not Correct'.tr(),
          content: 'Check and add it again'.tr(),
          boxColor: Colors.red);
    }
  }

  Future phoneAuth(countryCode, phoneNumber, context) async {
    isLoading = true;
    // FirebaseFirestore _firestore = FirebaseFirestore.instance;
/*
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: countryCode+ phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential){
          _firebaseAuth.signInWithCredential(credential).then((userData)async{
            await _firestore.collection('Users').doc(userData.user!.phoneNumber).set({
              'phone':userData.user!.phoneNumber!,
              'uid':userData.user!.uid,
              'fcm':Fcmtoken,
            });

            isLoading = false;
          });
          emit(SignUpSuccessState());

        },
        verificationFailed: (FirebaseAuthException error){
          print("Firebase Error : ${error.message}");
        },
        codeSent: (String verificationId,int? resendToken){
          isLoading = false;
          verificationCode = verificationId;
         Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpPage(phoneNumber: countryCode+ phoneNumber,verificationCode: verificationId,)));
          emit(SignUpSuccessState());

        },
        codeAutoRetrievalTimeout: (String verificationId){
          isLoading = false;
          verificationCode = verificationId;
        Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpPage(phoneNumber: countryCode+ phoneNumber,verificationCode: verificationId,)));
          emit(SignUpSuccessState());

        },timeout: Duration(seconds: 120));*/
  }

  Future otpSignIn(phoneNumber, verificationCode, code, context) async {
    isLoading = true;
    try {
      //FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      // FirebaseFirestore _firestore = FirebaseFirestore.instance;

      isLoading = false;
      DioHelper.postData(
              url: "user/sms-login",
              data: CacheHelper.getData(key: 'fcm') == null
                  ? {
                      'phone': phoneNumber,
                      'fcm': Fcmtoken,
                    }
                  : {
                      'phone': phoneNumber,
                      'fcm': Fcmtoken,
                    })
          .then((value) {
        if (value.statusCode == 200) {
          print(value.data);
          CacheHelper.saveStringData(key: 'fcm', value: Fcmtoken);
          CacheHelper.saveStringData(
              key: 'username', value: value.data['user']['name']);
          CacheHelper.saveStringData(
              key: 'access', value: value.data['user']['token']);
          CacheHelper.saveStringData(key: 'phoneNumber', value: phoneNumber);

          getUserData(context: context);
          popDialog(
              context: context,
              title: 'Welcome Back'.tr(),
              content: 'Login Done Sucessfully'.tr(),
              boxColor: AppCubit.get(context).primaryColor);
          emit(SignUpSuccessState());
        } else {
          popDialog(
              context: context,
              title: 'Something wrong happen'.tr(),
              content: value.toString(),
              boxColor: Colors.red);
          emit(SignUpSuccessState());
        }

        // createSnackBar(context,'Welcome Back ${value.user!.displayName}');
        emit(LogInSuccessState());
        CacheHelper.saveBoolData(key: "isLogged", value: true);
      }).catchError((e) {
        showToast(
          e.toString(),
          context: context,
          borderRadius: BorderRadius.circular(5),
          animation: StyledToastAnimation.scale,
          reverseAnimation: StyledToastAnimation.fade,
          animDuration: Duration(milliseconds: 250),
        );
        emit(LogInErrorState());
        print(e.toString());
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void createEmail(
    context, {
    required first_name,
    required address,
    required password,
    required password2,
    required email,
    required phone_number,
    /*required age*/
  }) {
    emit(SignUpInitialState());
    FormData formData = FormData.fromMap({
      'name': first_name,
      'address': address,
      'password': password,
      'confirm_password': password2,
      "email": email,
      'phone': phone_number,
      'fcm': Fcmtoken,
      // 'invited_user' : shared,
    });

    print(phone_number);
    DioHelper.postUser(path: "user/signup", data: formData).then((value) async {
      print(value.data);
      print('user reg');
      //CacheHelper.saveStringData(key: "access",value: value.data['tokens']["access"]);
      if (value.statusCode == 200) {
        Navigator.pop(context);
        popDialog(
            context: context,
            title: 'Welcome to you'.tr(),
            content: 'Account Created Successfully'.tr(),
            boxColor: AppCubit.get(context).primaryColor);
        User? user = (await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: email, password: password))
            .user;
        user!.updateDisplayName(first_name);
        user.updateEmail(email);
        //  user.updatePhoneNumber(phone_number);

        if (user.uid.isNotEmpty) {
          FirebaseFirestore.instance.collection("Users").doc(email).set({
            'name': first_name,
            'address': address,
            'password': password,
            'confirm_password': password2,
            "email": email,
            'phone': phone_number,
            'fcm': Fcmtoken,
            'image': ''
          });
          CacheHelper.saveStringData(key: 'fcm', value: Fcmtoken);
        }
      } else {
        popDialog(
            context: context,
            title: 'Something wrong happen'.tr(),
            content: value.toString(),
            boxColor: Colors.red);
      }
      //Navigator.pushReplacementNamed(context, Routes.loginPage);

      emit(SignUpSuccessState());
    }).catchError((e) {
      print(e.toString());
      showToast(
        e.toString(),
        borderRadius: BorderRadius.circular(5),
        context: context,
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        animDuration: Duration(milliseconds: 600),
      );
      emit(SignUpErrorState());
    });
  }

  void loginWithEmailAndPassword(
      {required email, required password, required context}) {
    emit(LogInInitialState());
    // LoadingScreen();

    DioHelper.postData(url: "user/login", data: {
      'password': password,
      'key': email,
      'fcm': Fcmtoken,
    }).then((value) {
      if (value.statusCode == 200) {
        print(value.data);
        CacheHelper.saveStringData(key: 'fcm', value: Fcmtoken);
        CacheHelper.saveStringData(key: 'email', value: email);
        CacheHelper.saveStringData(
            key: 'username', value: value.data['user']['name']);
        CacheHelper.saveStringData(
            key: 'access', value: value.data['user']['token']);
        //CacheHelper.saveStringData(key: 'plan', value: value.data['user']['id']);
        firebaseMessaging.subscribeToTopic(
            "${email.replaceAll("@", '').replaceAll(".", '').replaceAll("-", '')}");

        getUserData(context: context);
        popDialog(
            context: context,
            title: 'Welcome Back'.tr(),
            content: 'Login Done Sucessfully'.tr(),
            boxColor: AppCubit.get(context).primaryColor);
      } else {
        popDialog(
            context: context,
            title: 'Something wrong happen'.tr(),
            content: value.toString(),
            boxColor: Colors.red);
      }

      // createSnackBar(context,'Welcome Back ${value.user!.displayName}');
      emit(LogInSuccessState());
      CacheHelper.saveBoolData(key: "isLogged", value: true);
    }).catchError((e) {
      showToast(
        e.toString(),
        context: context,
        borderRadius: BorderRadius.circular(5),
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        animDuration: Duration(milliseconds: 250),
      );
      emit(LogInErrorState());
      print(e.toString());
    });
  }

  void logout({required context}) {
    emit(outInitialState());

    DioHelper.postData(url: "v1/logout/", data: {}).then((value) {
      Navigator.pushReplacementNamed(context, Routes.loginPage);
      CacheHelper.saveBoolData(key: "isLogged", value: false);

      emit(outSuccessState());
    }).catchError((e) {
      showToast(
        e.toString(),
        context: context,
        borderRadius: BorderRadius.circular(5),
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        animDuration: Duration(milliseconds: 250),
      );
      emit(outErrorState());
      print(e.toString());
    });
  }

  getFlagOfCountry(nameOfUserCountry) {
    late String flagOfUserCountry;
    for (Country country in Country.getCountries()) {
      String flag = country.countryFlag.toUpperCase().replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) =>
              String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
      if (nameOfUserCountry == country.name) {
        flagOfUserCountry = flag;
      }
    }
    return flagOfUserCountry;
  }

  bool isDescriptionContainerOpen = false;

  void changeDescriptionContainerStatus() {
    isDescriptionContainerOpen = !isDescriptionContainerOpen;
    emit(ChangeDescriptionContainerStatusState());
  }

  bool isSkillsContainerOpen = false;

  void changeSkillsContainerStatus() {
    isSkillsContainerOpen = !isSkillsContainerOpen;
    emit(ChangeDescriptionContainerStatusState());
  }

  String selectedImagePath = '';
  String selectedCoverPath = '';
  int imageNum = 0;
  String? userImage;
  Future<void> updateProfile(context,
      {first_name,
      last_name,
      bio,
      phone_number,
      country,
      age,
      address,
      image,
      cover}) async {
    emit(UploadProfileImageLoadingState());
    FormData formData = FormData.fromMap({
      'name': first_name,
      'address': last_name,
      'phone': phone_number,
      'image': selectedImagePath != ''
          ? await MultipartFile.fromFile(selectedImagePath)
          : userModel!.image,
    });

    DioHelper.patchData(url: "user/update", data: formData).then((value) {
      print(value.data);
      //CacheHelper.saveStringData(key: "access",value: value.data['tokens']["access"]);
      getUserData();
      Navigator.pop(context);
      Navigator.pop(context);
      popDialog(
          context: context,
          title: 'Profile Updated'.tr(),
          content: 'Profile Updated Sucessfully'.tr(),
          boxColor: AppCubit.get(context).primaryColor);
      FirebaseFirestore.instance
          .collection("Users")
          .doc(CacheHelper.getData(key: 'email'))
          .update({
        'firstName': first_name,
        'lastName': last_name,
        'phone': phone_number,
      });
      emit(UploadProfileImageSuccessState());
    }).catchError((e) {
      popDialog(
          context: context,
          title: 'Problem happen'.tr(),
          content: e.toString(),
          boxColor: Colors.red);
      print(e.toString());
      showToast(
        e.toString(),
        borderRadius: BorderRadius.circular(5),
        context: context,
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        animDuration: Duration(milliseconds: 600),
      );
      emit(UploadProfileImageErrorState(e.toString()));
    });
  }

  Future<void> changePassword(context, {oldPass, newPass, confPass}) async {
    emit(UploadProfileImageLoadingState());
    FormData formData = FormData.fromMap({
      "old_password": oldPass,
      'new_password': newPass,
      'confirm_password': confPass
    });

    DioHelper.postData(url: "user/reset-password", data: {
      "old_password": oldPass,
      'new_password': newPass,
      'confirm_password': confPass
    }).then((value) {
      print(value.data);
      //CacheHelper.saveStringData(key: "access",value: value.data['tokens']["access"]);
      getUserData();
      Navigator.pop(context);
      Navigator.pop(context);
      popDialog(
          context: context,
          title: 'Password Updated'.tr(),
          content: 'Password Updated Sucessfully'.tr(),
          boxColor: AppCubit.get(context).primaryColor);
      FirebaseAuth.instance.currentUser!
          .updatePassword(newPass)
          .then((value) => {
                FirebaseFirestore.instance
                    .collection("Users")
                    .doc(CacheHelper.getData(key: 'email'))
                    .update({
                  'password': newPass,
                  'confirm_password': confPass,
                })
              });

      emit(UploadProfileImageSuccessState());
    }).catchError((e) {
      popDialog(
          context: context,
          title: 'Problem happen'.tr(),
          content: e.toString(),
          boxColor: Colors.red);
      print(e.toString());
      showToast(
        e.toString(),
        borderRadius: BorderRadius.circular(5),
        context: context,
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        animDuration: Duration(milliseconds: 600),
      );
      emit(UploadProfileImageErrorState(e.toString()));
    });
  }

  Future<void> deleteAcc(context, id) async {
    emit(UploadProfileImageLoadingState());

    DioHelper.deleteData(
      url: "user/delete/$id",
    ).then((value) {
      print(value.data);
      CacheHelper.saveBoolData(key: "isLogged", value: false);
      CacheHelper.saveBoolData(key: 'firebaseLogin', value: false);

      Navigator.pushNamedAndRemoveUntil(
          context, Routes.loginPage, (route) => false);

      emit(UploadProfileImageSuccessState());
    }).catchError((e) {
      popDialog(
          context: context,
          title: 'Problem happen'.tr(),
          content: e.toString(),
          boxColor: Colors.red);
      print(e.toString());
      showToast(
        e.toString(),
        borderRadius: BorderRadius.circular(5),
        context: context,
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        animDuration: Duration(milliseconds: 600),
      );
      emit(UploadProfileImageErrorState(e.toString()));
    });
  }

  selectImageFromGallery() async {
    emit(PickProfileImageFromGalleryLoadingState());
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (file != null) {
      emit(PickProfileImageFromGallerySuccessState());
      return file.path;
    } else {
      emit(PickProfileImageFromGalleryErrorState(
          'Error: selectImageFromGallery'));
      return '';
    }
  }

  selectImageFromCamera() async {
    emit(PickProfileImageFromCameraLoadingState());
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    if (file != null) {
      emit(PickProfileImageFromCameraSuccessState());
      return file.path;
    } else {
      emit(
          PickProfileImageFromCameraErrorState('Error: selectImageFromCamera'));
      return '';
    }
  }

  UserModel? userModel;
  getUserData({context}) async {
    emit(getProfileInitialState());
    DioHelper.getData(
      url: 'user/profile',
    ).then((value) {
      print(value.data);
      print(CacheHelper.getData(key: 'access'));

      userModel = UserModel.fromJson(value.data);
      Navigator.pushReplacementNamed(context, Routes.homeScreen);

      print(value.data);
      print("user data");
      emit(getProfileSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(getProfileErrorState());
    });
  }

  bool notification = true;

  checkNotificationSetting() async {
    final value = CacheHelper.getData(key: 'notification') ?? 1;
    if (value == 1) {
      notification = true;
      enableNotification = true;
      emit(UpdateNotificationStatus());
    } else {
      notification = false;
      enableNotification = false;
      emit(UpdateNotificationStatus());
    }
  }

  saveNotificationSetting(context, bool val) async {
    final value = val ? 1 : 0;
    CacheHelper.saveIntData(key: 'notification', value: value);
    if (value == 1) {
      notification = true;
      enableNotification = true;
      emit(UpdateNotificationStatus());
    } else {
      notification = false;
      enableNotification = false;
      emit(UpdateNotificationStatus());
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacementNamed(context, Routes.homeScreen);
    });
    emit(SaveNotificationStatus());
  }

  List<NotificationModel> notificationModel = [];
  void getNotification() {
    /*   FirebaseFirestore.instance.collection('Notifications').where("sendTo",whereIn: ['all',CacheHelper.getData(key: 'fcmToken') ?? '']).get().then((value) {
      print(value.docs);
      value.docs.forEach((element) {
        print(element.data());
        notificationModel.add(NotificationModel.fromJson(element.data()));

        emit(GetNotificationSuccessState());
      });
    }).catchError((error) {
      print(error);
      emit(GetNotificationErrorState());
    });*/
  }

  //Method for showing the date picker
  DateTime? selectedDate;

  void pickDateDialog(
    BuildContext context,
  ) {
    showDatePicker(
            context: context,
            initialDate: DateTime(2001),
            //which date will display when user open the picker
            firstDate: DateTime(1960),
            //what will be the previous supported year in picker
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      selectedDate = pickedDate;
      print(pickedDate);
      //then usually do the future job
      if (selectedDate == null || selectedDate == DateTime.now()) {
        showToast(
          "Please Select right date",
          context: context,
          borderRadius: BorderRadius.circular(5),
          animation: StyledToastAnimation.scale,
          reverseAnimation: StyledToastAnimation.fade,
          animDuration: Duration(milliseconds: 250),
        );
        //if user tap cancel then this function will stop
        return;
      }
      emit(pickDateState());
    });
  }

  var val = "value";
  bool isChanged = false;
  genderChange(value) {
    isChanged = true;
    val = value.toString();
    emit(changeGenderState());
  }

  Country? country;
  bool isCountryChanged = false;

  List<DropdownMenuItem<Country>>? buildDropdownMenuItemsFrom(List countries) {
    List<DropdownMenuItem<Country>> items = [];
    for (Country country in countries) {
      String flag = country.countryFlag.toUpperCase().replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) =>
              String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
      items.add(
        DropdownMenuItem(
          value: country,
          child: Text(country.name + '  ' + flag),
        ),
      );
    }

    return items;
  }

  onChangeDropdownItemFrom(Country? selectedCountryFrom) {
    country = selectedCountryFrom!;
    isCountryChanged = true;

    print('sp from ${country!.countryCode}');
    emit(changeCountryState());
  }

  String jobValue = "value";
  bool jobChanged = false;
  jobChange(value) {
    jobChanged = true;
    jobValue = value.toString();
    emit(changeJobState());
  }

  List<String> jobsItems = [
    'Accounting/Finance',
    'Engineering - Construction',
    'Writing/Editorial',
    'IT/Software Development',
    'Manufacturing/Production',
    'Quality',
    'Administration',
    'Business Development',
    'Marketing/PR/Advertising',
    'Analyst/Research',
    'Creative/Design/Art',
    'Human Resources',
    'Media/Journalism/Publishing',
    'Customer Service/Support',
    'Pharmaceutical',
    'Marketing/PR/Advertising',
    'Strategy/Consulting',
  ];
//------------------------------------------------------------------------------
//IdentificationScreen
  int activeStep = 0; // Initial step set to 0.
  int upperBound = 3; // upperBound MUST BE total number of icons minus 1.

  void changeActiveStep(indexOfStep) {
    activeStep = indexOfStep;
    emit(ChangeActiveStepState());
    emit(IncrementActiveStepState());
  }

  void incrementActiveStep() {
    // Increment activeStep, when the next button is tapped. However, check for upper bound.
    if (activeStep < upperBound) {
      activeStep++;
      emit(IncrementActiveStepState());
    }
  }

  void decrementActiveStep() {
    // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
    if (activeStep > 0) {
      activeStep--;
      emit(DecrementActiveStepState());
    }
  }

  // Returns the header text based on the activeStep.
  String headerText() {
    switch (activeStep) {
      case 1:
        return 'Card ID Scan';
      case 2:
        return 'Face Scan';
      case 3:
        return 'Done';
      default:
        return 'Introduction';
    }
  }

  File? imgOfFrontCard;
  Future getImageOfFrontCard() async {
    emit(PickImageForMatchCardLoadingState());
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) {
        emit(PickImageForMatchCardErrorState());
        return;
      }

      final imgTemp = File(image.path);
      imgOfFrontCard = imgTemp;
      emit(PickImageForMatchCardSuccessState());
    } on PlatformException catch (e) {
      print('Failed to pick image of front card: $e');
      emit(PickImageForMatchCardErrorState());
    }
  }

  void makeImageOfFrontCardEqualNull() {
    imgOfFrontCard = null;
    emit(RemoveFrontImageState());
  }

  File? imgOfBackCard;
  Future getImageOfBackCard() async {
    emit(PickImageForMatchCardLoadingState());
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) {
        emit(PickImageForMatchCardErrorState());
        return;
      }

      final imgTemp = File(image.path);
      imgOfBackCard = imgTemp;
      emit(PickImageForMatchCardSuccessState());
    } on PlatformException catch (e) {
      print('Failed to pick image of back card: $e');
      emit(PickImageForMatchCardErrorState());
    }
  }

  void makeImageOfBackCardEqualNull() {
    imgOfBackCard = null;
    emit(RemoveBackImageState());
  }

  File? imgToMatch;

  Future getImageToMatch(ImageSource source) async {
    emit(PickImageForMatchCardLoadingState());
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) {
        emit(PickImageForMatchCardErrorState());
        return;
      }

      final imgTemp = File(image.path);
      imgToMatch = imgTemp;
      emit(PickImageForMatchCardSuccessState());
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
      emit(PickImageForMatchCardErrorState());
    }
  }

  void makeImageToMatchEqualNull() {
    imgToMatch = null;
    emit(RemoveMatchImageState());
  }

  bool fingerPrint = false;

  checkfingerPrintSetting() async {
    final value = CacheHelper.getData(key: 'fingerPrint') ?? false;
    print(value);
    if (value == true) {
      fingerPrint = true;
      emit(UpdatefingerStatus());
    } else {
      fingerPrint = false;
      emit(UpdatefingerStatus());
    }
  }

  savefingerPrintSetting(context, bool val) async {
    CacheHelper.saveBoolData(key: 'fingerPrint', value: val);
    if (val == true) {
      fingerPrint = true;
      emit(UpdatefingerStatus());
    } else {
      fingerPrint = false;
      emit(UpdatefingerStatus());
    }
    emit(SavefingerStatus());
  }

  bool showBiometric = false;
  bool isAuthenticated = false;

  isBiometricsAvailable() async {
    showBiometric = await BiometricHelper().hasEnrolledBiometrics();
    emit(BiomatricStatus());
  }

  authBiometric(context) async {
    CacheHelper.getData(key: 'fingerPrint') == true
        ? BiometricHelper().authenticate().then((value) {
            isAuthenticated = value;
            print(value);
            if (!isAuthenticated) {
              authBiometric(context);
              emit(BiomatricStatus());
            }
          })
        : isAuthenticated = false;
  }
}
