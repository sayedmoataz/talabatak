import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import '../../bloc/cubit/app_cubit.dart';
import '../../bloc/cubit/app_states.dart';
import '../../core/network/local/DbHelper.dart';
import '../../models/cart_model.dart';
import '../../theme/text_style.dart';
import '../../widgets/LoadingShimmer.dart';
import '../../widgets/default_cached_network_image.dart';
import '../../widgets/empty_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getCart(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          Size size = MediaQuery.of(context).size;
          AppCubit cubit = BlocProvider.of(context);
          return (cubit.cartModel == null)
              ? CardColumnScreen()
              : (cubit.cartModel!.cart!.cartProducts!.isEmpty)
                  ? Center(child: EmptyWidget('There are no Cart yet!'.tr()))
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your Cart".tr(),
                            style: textStyle(context,
                                size: 20.sp, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Container(
                            height: 70.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: AppCubit.get(context).themeMode == true
                                    ? Colors.grey[800]
                                    : Colors.grey),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                cartItem(
                                    'Products'.tr(),
                                    cubit.cartModel!.cart!.cartProducts!.length
                                        .toString(),
                                    context),
                                cartItem(
                                    'Quantity'.tr(),
                                    cubit.cartModel!.cart!.totalQuantity
                                        .toString(),
                                    context),
                                cartItem(
                                    'Total'.tr(),
                                    cubit.cartModel!.cart!.total! + " ₪",
                                    context),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Expanded(
                            child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: const ScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    buildCartScreen(
                                      context: context,
                                      cart: cubit.cartModel!.cart!
                                          .cartProducts![index],
                                    ),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      height: 10,
                                    ),
                                itemCount: cubit
                                    .cartModel!.cart!.cartProducts!.length),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 0.h, top: 10.h),
                            child: Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {
                                  print(CacheHelper.getData(key: 'CityId'));
                                  cubit.CalculateShipping(
                                      CacheHelper.getData(key: 'CityId') ?? 1,
                                      context);
                                },
                                child: Container(
                                  height: 30.h,
                                  width: 220.w,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppCubit.get(context).themeMode ==
                                              true
                                          ? Colors.grey[800]
                                          : Colors.grey),
                                  child: Text(
                                    'Order Now'.tr(),
                                    style: textStyle(context,
                                        color: cubit.primaryColor,
                                        size: 16.sp,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
        },
      ),
    );
  }
}

Widget buildCartScreen({
  required BuildContext context,
  required CartProducts cart,
}) =>
    Row(
      children: [
        Expanded(
          flex: 9,
          child: Container(
            height: 110.h,
            decoration: BoxDecoration(
              color: AppCubit.get(context).themeMode == true
                  ? Colors.grey[800]!.withOpacity(0.9)
                  : Colors.grey.withOpacity(0.8),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              boxShadow: [],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cart.product!.title!,
                            style: textStyle(context,
                                size: 14, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.end,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        cart.total! + " ₪",
                        style: textStyle(context, size: 14.sp),
                        textAlign: TextAlign.end,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4),
                        child: Container(
                          width: 108,
                          height: 25.h,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.remove, size: 15),
                                  onPressed: () {
                                    if (cart.quantity! < 1) {
                                      showToast(
                                          "Quantity cannot be less than 1".tr(),
                                          context: context,
                                          backgroundColor: Colors.red);
                                    } else {
                                      AppCubit.get(context).updateCart(
                                        context,
                                        quantity: cart.quantity! - 1,
                                        id: cart.id!,
                                      );
                                    }
                                  }),
                              ValueListenableBuilder(
                                  //TODO 2nd: listen playerPointsToAdd
                                  valueListenable:
                                      ValueNotifier<int>(cart.quantity!),
                                  builder: (context, value, widget) {
                                    return Text(value.toString());
                                  }),
                              IconButton(
                                  icon: Icon(Icons.add, size: 15),
                                  onPressed: () {
                                    AppCubit.get(context).updateCart(
                                      context,
                                      quantity: cart.quantity! + 1,
                                      id: cart.id!,
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8.5),
                        bottomRight: Radius.circular(12)),
                    child: DefaultCachedNetworkImage(
                      imageUrl: cart.product!.productImages![0].image!,
                      width: 50,
                      height: 150,
                      fit: BoxFit.fill,
                    ),
                    // Image.network(
                    //   cart.product!.productImages![0].image!,
                    //   width: 50,
                    //   height: 150,
                    //   fit: BoxFit.fill,
                    //   loadingBuilder: (BuildContext context, Widget child,
                    //       ImageChunkEvent? loadingProgress) {
                    //     if (loadingProgress == null) return child;
                    //     return Center(
                    //       child: CircularProgressIndicator(
                    //         value: loadingProgress.expectedTotalBytes != null
                    //             ? loadingProgress.cumulativeBytesLoaded /
                    //                 loadingProgress.expectedTotalBytes!
                    //             : null,
                    //       ),
                    //     );
                    //   },
                    // ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
            flex: 1,
            child: CircleAvatar(
              radius: 15,
              child: IconButton(
                onPressed: () {
                  AppCubit.get(context).deleteFromCart(cart.id!, context);
                },
                icon: Icon(
                  Icons.delete_outline,
                  size: 15,
                ),
              ),
            )),
      ],
    );

Widget cartItem(title, value, context) {
  return Container(
    height: 60.h,
    width: 100.w,
    alignment: Alignment.center,
    child: ListTile(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: textStyle(context, size: 12.sp, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        value,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
