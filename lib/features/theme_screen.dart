import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/AuthCubit/auth_cubit.dart';
import 'splash_screen.dart';

import '../bloc/cubit/app_cubit.dart';
import '../bloc/cubit/app_states.dart';
import '../components/components.dart';
import '../theme/palette.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);

        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SplashScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Next',
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                      SizedBox(width: 3.w,),
                      Icon(
                        Icons.double_arrow,
                        color:cubit.primaryColor ?? Palette.amber100,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 60.h,
              ),
              Container(
                  alignment: Alignment.center,
                  child: Image.asset("assets/images/logo.png",
                    width: 150.w, height: 120.h,)
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Choose your preferred language',
                  style: TextStyle(
                      fontSize: 16
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                child: InkWell(
                  splashColor: cubit.textColor.withOpacity(0.0),
                  highlightColor: cubit.textColor.withOpacity(0.0),
                  onTap: () => AuthCubit.get(context).changeLanguageContainerStatus(),
                  child: buildRowItem(
                    context,
                    cubit,
                    Icons.language,
                    'language',
                    AuthCubit.get(context).isLanguageContainerOpen,
                  ),
                ),
              ),
              if (AuthCubit.get(context).isLanguageContainerOpen) ...[
                const SizedBox(height: 10),
                myDivider(cubit,horizontalPad: 0.0),
                const SizedBox(height: 5),
                ////////////////////////////////
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child:  buildLanguageColumn(cubit, state,context),
                ),
              ],
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(color: Colors.grey,),),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Choose your preferred theme',
                  style: TextStyle(
                      fontSize: 16
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                child: InkWell(
                  splashColor: cubit.textColor.withOpacity(0.0),
                  highlightColor: cubit.textColor.withOpacity(0.0),
                  onTap: () =>AuthCubit.get(context).changeThemeContainerStatus(),
                  child: buildRowItem(
                    context,
                    cubit,
                    Icons.brightness_4,
                    'theme',
                    AuthCubit.get(context).isThemeContainerOpen,
                  ),
                ),
              ),
              if (AuthCubit.get(context).isThemeContainerOpen) ...[
                const SizedBox(height: 20),
                myDivider(AppCubit(),horizontalPad: 0.0,),
                const SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: buildNotificationOptionRow(context,Theme.of(context).brightness == Brightness.dark ?  "Light Mode" : "Dark Mode",Icons.dark_mode, AppCubit.get(context).themeMode,(value) {
                    AppCubit.get(context).changeTheme();
                  },),
                ),
                const SizedBox(height: 15),
                buildThemeColumn(cubit, state,context),
              ],

            ],
          ),
        );
      },
    );
  }
}