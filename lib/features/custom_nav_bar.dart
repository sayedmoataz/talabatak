import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/text_style.dart';

import '../bloc/cubit/app_cubit.dart';
import '../bloc/cubit/app_states.dart';
import '../theme/palette.dart';


class CustomBottomNavigationBar extends StatefulWidget {
  final int defaultSelectedIndex;
  final Function(int) onChange;
  final List<IconData> selectedIconList;
  final List<IconData> unselectedIconList;
  final List<String> titleList;

  CustomBottomNavigationBar({
    this.defaultSelectedIndex = 1,
    required this.onChange,
    required this.selectedIconList,
    required this.unselectedIconList,
    required this.titleList
  });

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  List<IconData> _selectedIconList = [];
  List<IconData> _unSelectedIconList = [];
  List<String> _titleList = [];

  @override
  void initState() {
    _selectedIndex = widget.defaultSelectedIndex;
    _selectedIconList = widget.selectedIconList;
    _unSelectedIconList = widget.unselectedIconList;
    _titleList = widget.titleList;
    super.initState();



  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _navBarItemList = [];

    for (var i = 0; i < _selectedIconList.length; i++) {
      _navBarItemList.add(
          buildNavBarItem(_selectedIconList[i], _unSelectedIconList[i], widget.titleList[i],i));
    }

    return Material(
      
      borderRadius: BorderRadius.circular(10),
      elevation: 2,
      color:AppCubit.get(context).themeMode != true ? Colors.grey[200] : Colors.grey[800],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _navBarItemList,
      ),
    );
  }

  Widget buildNavBarItem(IconData selectedIcon, IconData unSelectedIcon,String title,
      int index) {
    return GestureDetector(
      onTap: () {
        widget.onChange(index);
        setState(() {
          _selectedIndex = index;
        });
      },
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);

          return index == 1 ? Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            child: Container(
                height: 70.h,
                width:70.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/icon.png')
                  ),
                  gradient:index != _selectedIndex ? LinearGradient(
                    colors: [AppCubit.get(context).primaryColor,Colors.greenAccent]
                  ) : LinearGradient(
                      colors: [AppCubit.get(context).primaryColor,AppCubit.get(context).primaryColor]
                  ),
                   // color:index == _selectedIndex ? AppCubit.get(context).primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(56)),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                 /*   Icon(
                      index == _selectedIndex ? selectedIcon : unSelectedIcon,
                    ),
                    Text(title,style: textStyle(context,size: 8.sp),)*/
                  ],
                )
            ),
          ) : Container(
            height: 50.h,
            width:50.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color:index == _selectedIndex ? AppCubit.get(context).primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(12)),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  index == _selectedIndex ? selectedIcon : unSelectedIcon,
                ),
                Text(title,style: textStyle(context,size: 8.sp),)
              ],
            )
          );
        },
      ),
    );
  }
}

class NavigationTabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool above;

  const NavigationTabItem({
    Key? key,
    required this.icon,
    required this.label,
    this.onTap,
    required this.above,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width:70,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6)),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap!();
        },
        child: Container(
          decoration: BoxDecoration(
              color: above? Colors.white:Colors.transparent,
              borderRadius: BorderRadius.circular(15)
          ),
          height: 40,
          width: 100,
          child: Icon(
            icon,
            color: above
                ? AppCubit.get(context).primaryColor
                : Colors.white,
          ),
        ),
      ),
    );
  }
}
