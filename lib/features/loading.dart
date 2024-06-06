/*
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

import '../bloc/cubit/app_cubit.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage(AppCubit.get(context).themeMode == false ? 'assets/gifs/white_loading.gif':
              'assets/gifs/white_loading.gif')
            )
          ),
   ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:news_app/bloc/cubit/app_cubit.dart';


class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        alignment: Alignment.center,
        child: LoadingBouncingGrid.circle(
          borderColor: AppCubit
              .get(context)
              .primaryColor,
          borderSize: 3.0,
          size: 90.0,
          backgroundColor: AppCubit
              .get(context)
              .primaryColor,
          duration: Duration(milliseconds: 2500),
        ),
      ),
    );
  }
}
