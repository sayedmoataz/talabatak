import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/AuthCubit/auth_cubit.dart';
import '../../bloc/AuthCubit/auth_states.dart';
import '../../bloc/cubit/app_cubit.dart';
import '../../components/components.dart';
import '../loading.dart';

import '../../Router.dart';
import '../../core/network/local/DbHelper.dart';
import '../../theme/text_style.dart';
import '../../widgets/custom_listTile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AuthCubit()..getUserData(),
        child: BlocConsumer<AuthCubit, AuthStates>(
          listener: (BuildContext context, Object? state) {},
          builder: (BuildContext context, state) {
            AuthCubit cubit = AuthCubit.get(context);

            return cubit.userModel == null
                ? const LoadingScreen()
                : SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SafeArea(
                            child: SizedBox.shrink(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  margin: EdgeInsets.all(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        Icon(Icons.arrow_back_ios_new_outlined),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  "Profile".tr(),
                                  style: GoogleFonts.poppins(
                                    color: AppCubit.get(context).primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),

                        /*  Container(
                            padding: const EdgeInsets.all(4.0),
                            width: 425.w,
                            height: 125.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                shape: BoxShape.rectangle,
                                color: AppCubit.get(context).primaryColor,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage('assets/images/logo.png'),
                                )
                            ),

                          ),*/
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4.0),
                                width: 125.w,
                                height: 125.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppCubit.get(context).primaryColor,
                                ),
                                child: CircleAvatar(
                                  radius: 48, // Image radius
                                  backgroundImage: NetworkImage(cubit.userModel!.image ?? "https://i.imgur.com/7vHILrC.jpeg"),
                                ),
                              ),

                              Positioned(
                                bottom: 10.0,
                                right: 10.0,
                                child: Container(
                                  width: 30.0,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                    color: AppCubit.get(context).primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check_circle_outline_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                            ],
                          ),

                          SizedBox(
                            height: 10.0.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.person_outline,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                cubit.userModel!.name!,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                          if( cubit.userModel!.email != null)...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.email_outlined,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text(
                                  cubit.userModel!.email ?? '',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],


                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.phone_outlined,
                                color: Colors.green,
                                size: 18,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                cubit.userModel!.phone!,
                                style: GoogleFonts.poppins(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0.h,
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          CustomListTile(
                            title: 'My Orders'.tr(),
                            leadingIcon: Icons.category_outlined,
                            press: () {
                              Navigator.pushNamed(
                                  context, Routes.myOrders);
                            },
                          ),
                          Divider(
                            color: Colors.grey,
                          ),

                          CustomListTile(
                            title: 'Edit Profile'.tr(),
                            leadingIcon: Icons.edit_outlined,
                            press: () {
                              Navigator.pushNamed(
                                  context, Routes.editProfilePage);
                            },
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          CustomListTile(
                            title: 'Change Password'.tr(),
                            leadingIcon: Icons.edit_outlined,
                            press: () {
                              Navigator.pushNamed(
                                  context, Routes.changePasswordPage);
                            },
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          Card(
                            child: TextButton(
                                onPressed: () async{
                                  showDialog(context: context, builder: (context){
                                    return  AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      title: Image.asset('assets/images/logo.png'
                                          ,alignment: Alignment.center,fit: BoxFit.contain,height: 120.h),
                                      content: Text("Delete Account".tr(),style: textStyle(
                                        context,
                                        size: 20,
                                        fontWeight: FontWeight.w600,
                                      ),textAlign: TextAlign.center),
                                      actions: [
                                        Column(
                                          children: [
                                            Text(
                                              "Are your sure you want to delete account ?".tr(),style:textStyle(
                                              context,

                                            ),textAlign: TextAlign.center
                                              ,),

                                            SizedBox(height: 5.h,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [

                                                InkWell(
                                                  onTap:(){
                                                   cubit.deleteAcc(context, cubit.userModel!.id!);

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
                                                        color:AppCubit.get(context).primaryColor,
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

                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.delete_outline,color: Colors.red,),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text('Delete Account'.tr(),style:textStyle(context,size: 18.sp,color: AppCubit.get(context).themeMode == true ? Colors.grey[300] : Colors.black),),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
