import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../bloc/cubit/app_cubit.dart';
import '../../bloc/cubit/app_states.dart';
import '../../core/network/local/DbHelper.dart';
import '../../models/area_model.dart';
import '../../theme/text_style.dart';
import '../../widgets/PopDialog.dart';
import '../../widgets/button.dart';
import '../../widgets/textFormWidget.dart';
import '../FavoritesScreen/cart_screen.dart';
import '../layout/bottomNavigation_layout.dart';
import 'map_screen.dart';

class AddOrderScreen extends StatefulWidget {
  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final TextEditingController nameController = TextEditingController(
      text: CacheHelper.getData(key: 'orderName') ?? '');

  final TextEditingController phoneController = TextEditingController(
      text: CacheHelper.getData(key: 'phoneNumber') ?? '');

  final TextEditingController addressController =
      TextEditingController(text: CacheHelper.getData(key: 'addresMap') ?? '');

  final TextEditingController locationController = TextEditingController();

  final TextEditingController notesController =
      TextEditingController(text: CacheHelper.getData(key: 'orderNote') ?? '');

  int? areaId;
  bool buttonPressed = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        CacheHelper.saveIntData(key: 'homePath', value: 1).then((value) => {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => BottomNavigation()))
            });
        return Future.value(true);
      },
      child: BlocProvider(
        create: (context) => AppCubit()..getArea(context, screen: true),
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            return SafeArea(
                child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  "assets/images/fullLogo.png",
                                  width: 140.w,
                                  height: 70.h,
                                ),
                              ),
                              GradientText(
                                'Order Now'.tr(),
                                colors: [
                                  cubit.primaryColor,
                                  cubit.themeMode == true
                                      ? Colors.white
                                      : Colors.black,
                                ],
                                gradientType: GradientType.linear,
                                radius: 6,
                                style: textStyle(context,
                                    size: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    letterSpaceing: 1.5),
                              ),
                            ],
                          )),
                      SizedBox(height: 20.h),
                      Text(
                        'Make your order Now'.tr(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 15.h),
                      TextFormGlobal(
                        controller: nameController,
                        validator: (value) {
                          return value!.isEmpty ? "Enter your Name".tr() : null;
                        },
                        text: 'Your Name'.tr(),
                        obscure: false,
                        icon: Icons.person_outline,
                        textInputType: TextInputType.name,
                      ),

                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormGlobal(
                        controller: phoneController,
                        validator: (value) {
                          return value!.isEmpty
                              ? "Enter your Phone".tr()
                              : null;
                        },
                        text: 'Phone'.tr(),
                        icon: Icons.phone_android,
                        obscure: false,
                        textInputType: TextInputType.number,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      if (cubit.areaModel != null) ...[
                        Container(
                          decoration: BoxDecoration(
                              color: AppCubit.get(context).themeMode == true
                                  ? Colors.grey[800]
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 7,
                                )
                              ]),
                          child: ListTile(
                              leading: Icon(
                                Icons.local_shipping_outlined,
                                color: Colors.grey,
                              ),
                              title: DropdownButtonHideUnderline(
                                child: DropdownButton<Areas>(
                                    onChanged: (val) {
                                      cubit.areaChange(
                                          val!.name, val.id, context);
                                    },
                                    isDense: true,
                                    isExpanded: true,
                                    hint: Text(
                                      cubit.areaChanged
                                          ? cubit.areaNamee
                                          : CacheHelper.getData(
                                                  key: 'CityName') ??
                                              '',
                                      overflow: TextOverflow.ellipsis,
                                      style: textStyle(context,
                                          size: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                    ),
                                    iconSize: 22,
                                    dropdownColor:
                                        AppCubit.get(context).themeMode == true
                                            ? Colors.grey[800]
                                            : Colors.white,
                                    itemHeight: null,
                                    items: cubit.areaModel!.results!
                                        .map((Areas value) {
                                      return DropdownMenuItem<Areas>(
                                        value: value,
                                        child: Text(value.name!),
                                      );
                                    }).toList()),
                              )),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],

                      ButtonGlobal(
                          title: "Pick Address".tr(),
                          hight: 45,
                          callback: () {
                            CacheHelper.saveStringData(
                                key: 'orderName', value: nameController.text);
                            CacheHelper.saveStringData(
                                key: 'orderNote', value: notesController.text);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MapScreen()));
                          }),
                      SizedBox(
                        height: 10.h,
                      ),
                      if (CacheHelper.getData(key: 'addresMap') != null) ...[
                        TextFormGlobal(
                          controller: addressController,
                          validator: (value) {
                            return value!.isEmpty
                                ? "Enter your address".tr()
                                : null;
                          },
                          text: 'Address'.tr(),
                          obscure: false,
                          icon: Icons.home_outlined,
                          textInputType: TextInputType.name,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],

                      Container(
                        height: 150.h,
                        child: TextFormGlobal(
                          controller: notesController,
                          maxlines: 50,
                          validator: (value) {
                            return value!.isEmpty
                                ? "Enter your Notes".tr()
                                : null;
                          },
                          text: 'Order Notes'.tr(),
                          obscure: false,
                          icon: Icons.note_add_outlined,
                          textInputType: TextInputType.name,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.0.w),
                        child: state is loadingLikesStates
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: cubit.primaryColor,
                                ),
                              )
                            : ButtonGlobal(
                                title: "Order Now".tr(),
                                callback: buttonPressed
                                    ? null // Disable the button if it has already been pressed
                                    : () {
                                        if (validateData(context, cubit)) {
                                          buttonPressed = true;

                                          AppCubit.get(context).AddOrder(
                                              '1',
                                              addressController.text,
                                              nameController.text,
                                              phoneController.text,
                                              notesController.text,
                                              context);
                                        }
                                        setState(() {});
                                      }),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      //SocialLogin(),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                height: 70.h,
                width: 500,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25)),
                    color: AppCubit.get(context).themeMode == true
                        ? Colors.grey[800]
                        : Colors.grey),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    cartItem(
                        'Time'.tr(),
                        CacheHelper.getData(key: 'timeCost') +
                            " " +
                            'minute'.tr(),
                        context),
                    cartItem(
                        'Shipping'.tr(),
                        CacheHelper.getData(key: 'shippingCost') + " ₪",
                        context),
                    cartItem('Total'.tr(),
                        CacheHelper.getData(key: 'totalCost') + " ₪", context),
                  ],
                ),
              ),
            ));
          },
        ),
      ),
    );
  }

  bool validateData(context, AppCubit cubit) {
    if (nameController.text.isEmpty) {
      popDialog(
          context: context,
          title: "name is required".tr(),
          content: '',
          boxColor: Colors.red);

      return false;
    } else if (phoneController.text.isEmpty) {
      popDialog(
          context: context,
          title: "Phone is required".tr(),
          content: '',
          boxColor: Colors.red);

      return false;
    } else if (addressController.text.isEmpty) {
      popDialog(
          context: context,
          title: "Address is required".tr(),
          content: '',
          boxColor: Colors.red);

      return false;
    } else {
      return true;
    }
  }
}
