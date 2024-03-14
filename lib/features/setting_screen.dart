import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:launch_review/launch_review.dart';
import '../bloc/AuthCubit/auth_states.dart';

import '../core/network/local/DbHelper.dart';
import 'loading.dart';
import '../theme/palette.dart';
import '../theme/text_style.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Router.dart';
import '../bloc/AuthCubit/auth_cubit.dart';
import '../bloc/cubit/app_cubit.dart';
import '../bloc/cubit/app_states.dart';
import '../components/components.dart';
import '../widgets/PopDialog.dart';
import '../widgets/custom_listTile.dart';
import '../widgets/dialog_widget.dart';


class SettingsScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state){},
        builder: (context, state)
        {
          var nameController = TextEditingController();

          var authCubit = AuthCubit.get(context);
          var cubit = AppCubit.get(context);
          return SafeArea(
            child: Scaffold(
                body: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.h),
                      height: 50.h,
                      child: Text(
                        "App Setting".tr().toUpperCase(),
                        style: textStyle(
                            context,
                            fontWeight: FontWeight.w700,
                            size: 22,
                            spacing: 1.4

                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        //shrinkWrap: true,
                        //physics: NeverScrollableScrollPhysics(),
                        children: [
                         Padding(
                              padding: EdgeInsets.all(20.h),
                              child: Text(
                                'My Account'.tr().toUpperCase(),
                                style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                              )),
                          Card(
                              child: Column(children: [
                                if(CacheHelper.getData(key: "isLogged") != false)...[
                                  CustomListTile(
                                    press: ()async{
                                      Navigator.pushNamed(context, Routes.profilePage);
                                    },
                                    title: 'Profile'.tr(),
                                    leadingIcon: Icons.person,
                                  ),
                                  Divider(color: Colors.grey,),
                                  CustomListTile(
                                    press: ()async{
                                      cubit.getArea(context);
                                    },
                                    title: 'Shipping Place'.tr(),
                                    leadingIcon: Icons.local_shipping_outlined,
                                  ),
                                  Divider(color: Colors.grey,),
                                ],




                                CustomListTile(
                                  press:  (){
                                    showDialog(context: context, builder: (context){
                                      return  AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15)
                                        ),
                                        title: Image.asset('assets/gifs/about.gif'
                                            ,alignment: Alignment.center,fit: BoxFit.contain,height: 120.h),
                                        content: Text("Change Language".tr(),style: textStyle(
                                          context,
                                          size: 20,
                                          fontWeight: FontWeight.w600,
                                        ),textAlign: TextAlign.center),
                                        actions: [
                                          Column(
                                            children: [
                                              Text(
                                                "What Language do you prefer ?".tr(),style:textStyle(
                                                context,

                                              ),textAlign: TextAlign.center
                                                ,),

                                              SizedBox(height: 5.h,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [

                                                  InkWell(
                                                    onTap:(){
                                                      cubit.changeAppLanguage('en');
                                                      EasyLocalization.of(context)!.setLocale(Locale('en', 'US'));
                                                    },
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      height:30,
                                                      width:80,
                                                      child: Text("English".tr(),style: textStyle(
                                                        context,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.white,

                                                      ),),
                                                      decoration:BoxDecoration(
                                                          color:cubit.primaryColor,
                                                          borderRadius: BorderRadius.circular(10)
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap:() {
                                                      cubit.changeAppLanguage('ar');
                                                      EasyLocalization.of(context)!.setLocale(Locale('ar','IQ'));
                                                    },
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      height:30,
                                                      width:80,
                                                      child: Text("العربيه".tr(),style: textStyle(
                                                        context,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.white,

                                                      ),),
                                                      decoration:BoxDecoration(
                                                          color:Colors.red,
                                                          borderRadius: BorderRadius.circular(10)
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      );
                                    });
                                  },
                                  title: 'language'.tr(),
                                  leadingIcon: Icons.language,
                                ),

                                Divider(color: Colors.grey,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                                  child: InkWell(
                                    splashColor: cubit.textColor.withOpacity(0.0),
                                    highlightColor: cubit.textColor.withOpacity(0.0),
                                    onTap: () =>AuthCubit.get(context).changeThemeContainerStatus(),
                                    child: buildRowItem(
                                      context,
                                      cubit,
                                      Icons.brightness_4,
                                      'theme'.tr(),
                                      AuthCubit.get(context).isThemeContainerOpen,
                                    ),
                                  ),
                                ),
                                if (AuthCubit.get(context).isThemeContainerOpen) ...[
                                  const SizedBox(height: 20),
                                  myDivider(AppCubit(),horizontalPad: 0.0,),
                                  const SizedBox(height: 5),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    child: buildNotificationOptionRow(context,Theme.of(context).brightness == Brightness.dark ?  "Light Mode".tr() : "Dark Mode".tr(),Icons.dark_mode, AppCubit.get(context).themeMode,(value) {
                                      AppCubit.get(context).changeTheme();
                                    },),
                                  ),
                                  const SizedBox(height: 15),
                                  buildThemeColumn(cubit, state,context),
                                ],


                                Divider(color: Colors.grey,),
                                buildNotificationOptionRow(context,"Enable Notification".tr(),Icons.notifications_active, AppCubit.get(context).notification ,(val) async {
                                  await AppCubit.get(context).saveNotificationSetting(context,val);

                                },),
                                Divider(color: Colors.grey,),
                                buildNotificationOptionRow(context,"Enable FingerPrint".tr(),Icons.fingerprint, AuthCubit.get(context).fingerPrint ,(val) async {
                                  await AuthCubit.get(context).savefingerPrintSetting(context,val);
                                }),
                              ])),
                         /* Padding(
                              padding: EdgeInsets.all(20.h),
                              child: Text(
                                'Reach out to us'.tr().toUpperCase(),
                                style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                              )),*/

                          Padding(
                              padding: EdgeInsets.all(20.h),
                              child: Text(
                                'Know More'.tr().toUpperCase(),
                                style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                              )),
                          Card(
                            child: Column(
                              children:  [

                             /*   CustomListTile(
                                  title: 'Join Our Community'.tr(),
                                  leadingIcon:  Icons.telegram,
                                  press: (() => launchUrl(Uri.parse('https://t.me/+4wlim8cxONpmNDE0'),mode: LaunchMode.externalApplication)),
                                ),
                                Divider(color: Colors.grey,),
                                CustomListTile(
                                  title: 'FAQs'.tr(),
                                  leadingIcon:  Icons.question_answer_outlined,
                                  press: (() => Navigator.pushNamed(context, Routes.faqsPage)),
                                ),
                                Divider(color: Colors.grey,),
*/
                                CustomListTile(
                                  title: 'Privacy Policy'.tr(),
                                  leadingIcon:  Icons.question_mark,
                                  press: (() => Navigator.pushNamed(context, Routes.privacyPage)),
                                ),
                                Divider(color: Colors.grey,),


                                CustomListTile(
                                  title: 'Share App'.tr(),
                                  leadingIcon:  Icons.share,
                                  press: (){
                                    Share.share(
                                        "If you love the app please review the app on playstore ore and share it with your friends. https://play.google.com/store/apps/details?id=com.talabatek.app".tr());

                                  },
                                ),
                                Divider(color: Colors.grey,),

                                CustomListTile(
                                  title: 'Rate App'.tr(),
                                  leadingIcon:  Icons.star,
                                  press: (){
                                    LaunchReview.launch(androidAppId: "com.talabatek.app",
                                        iOSAppId: "1568670214");
                                  },
                                ),
                                Divider(color: Colors.grey,),

                                CustomListTile(
                                  title: 'About App'.tr(),
                                  leadingIcon:  Icons.info_outline,
                                  press: (){
                                    ShowDialog(context: context,
                                      gif: 'assets/gifs/about.gif',title: "About App".tr(),
                                      description: "aboutUsDes".tr(),sharedKey: "isTrans",
                                      okBut: true,
                                      okString: "Ok".tr(), canString: 'No'.tr(),
                                      canButton: ()=>Navigator.pop(context),
                                      okButton: ()=>Navigator.pop(context),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 10.h,
                          ),
                          Card(
                            child: TextButton(
                                onPressed:CacheHelper.getData(key: "isLogged") == false  ?

                                (){
                                  CacheHelper.saveBoolData(
                                      key: "isLogged", value: false);
                                  CacheHelper.saveBoolData(key: 'firebaseLogin', value: false);

                                  Navigator.pushNamedAndRemoveUntil(context,
                                      Routes.smsPage, (route) => false);
                                }:  () async{
                                  showDialog(context: context, builder: (context){
                                    return  AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15)
                                      ),
                                      title: Image.asset('assets/images/logo.png'
                                        ,alignment: Alignment.center,fit: BoxFit.contain,height: 120.h),
                                      content: Text("Log-Out".tr(),style: textStyle(
                                        context,
                                        size: 20,
                                        fontWeight: FontWeight.w600,
                                      ),textAlign: TextAlign.center),
                                      actions: [
                                       Column(
                                         children: [
                                           Text(
                                             "Are your sure you want to sign out ?".tr(),style:textStyle(
                                             context,

                                           ),textAlign: TextAlign.center
                                             ,),

                                           SizedBox(height: 5.h,),
                                           Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                             children: [

                                               InkWell(
                                                 onTap:(){
                                                   CacheHelper.saveBoolData(
                                                       key: "isLogged", value: false);
                                                   CacheHelper.saveBoolData(key: 'firebaseLogin', value: false);

                                                   Navigator.pushNamedAndRemoveUntil(context,
                                                       Routes.smsPage, (route) => false);
                                                 },
                                                 child: Container(
                                                   alignment: Alignment.center,
                                                   height:30,
                                                   width:80,
                                                   child: Text("Yes".tr(),style: textStyle(
                                                     context,
                                                     fontWeight: FontWeight.w600,
                                                     color: Colors.white,

                                                   ),),
                                                   decoration:BoxDecoration(
                                                       color:cubit.primaryColor,
                                                       borderRadius: BorderRadius.circular(10)
                                                   ),
                                                 ),
                                               ),
                                               InkWell(
                                                 onTap:()=>Navigator.pop(context),
                                                 child: Container(
                                                   alignment: Alignment.center,
                                                   height:30,
                                                   width:80,
                                                   child: Text("No".tr(),style: textStyle(
                                                     context,
                                                     fontWeight: FontWeight.w600,
                                                     color: Colors.white,

                                                   ),),
                                                   decoration:BoxDecoration(
                                                       color:Colors.red,
                                                       borderRadius: BorderRadius.circular(10)
                                                   ),
                                                 ),
                                               ),
                                             ],
                                           )
                                         ],
                                       )
                                      ],
                                    );
                                  });
                               /*   ShowDialog(context: context,
                                      gif: 'assets/images/logo.png',title: "Log-Out".tr(),
                                      description: "Are your sure you want to sign out ?".tr(),sharedKey: "isTrans",
                                      okBut: false,
                                      okString: "Yes".tr(), canString: 'No'.tr(),
                                      canButton: ()=>Navigator.pop(context),
                                      okButton: (){

                                  }
                                  );*/
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.logout,color: CacheHelper.getData(key: "isLogged") == false  ? cubit.primaryColor: Colors.red,),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      CacheHelper.getData(key: "isLogged") == false  ?
                                      'Sign In'.tr()
                                          :
                                      'Sign Out'.tr(),style:textStyle(context,size: 18.sp,color: cubit.themeMode == true ? Colors.grey[300] : Colors.black),),
                                  ],
                                )),
                          ),
                          SizedBox(height: 20.h,),
                          Text('Contact With Us'.tr(),style: textStyle(context,size: 13.sp,
                            fontWeight: FontWeight.bold,color: Colors.grey
                          ),textAlign: TextAlign.center,),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(onPressed: (){
                                 // launchUrl(Uri.parse('https://www.facebook.com/profile.php?id=100093519372837&mibextid=ZbWKwL'),mode: LaunchMode.externalApplication);

                                },
                                    icon: const Icon(FontAwesomeIcons.facebook),
                                    color: cubit.primaryColor,iconSize: 20),

                                IconButton(onPressed: (){
                               //   launchUrl(Uri.parse('https://wa.me/+249997803436?text=السلام عليكم'),mode: LaunchMode.externalApplication);

                                },
                                    icon:const  Icon(FontAwesomeIcons.whatsapp),
                                    color: cubit.primaryColor,iconSize: 20),

                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0,top: 5),
                            child: Text("© AppName Team All rights reserved".tr(),style:
                            textStyle(context,color: Colors.grey,
                                size: 12.w),
                              textAlign: TextAlign.center,),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          );});
  }
}