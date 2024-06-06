import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';

import '../../bloc/cubit/app_cubit.dart';
import '../../bloc/cubit/app_states.dart';
import '../../core/network/local/DbHelper.dart';
import '../../models/vendor_model.dart';
import '../../theme/text_style.dart';
import '../../widgets/PopDialog.dart';
import '../../widgets/default_cached_network_image.dart';
import '../../widgets/hot_offer.dart';
import '../loading.dart';
import '../search_screen.dart';
import 'CategoryProductsScreen.dart';

class ShopDetailsScreen extends StatefulWidget {
  final int vendorId;
  final Vendors results;
  final String cityPrice;
  const ShopDetailsScreen(
      {Key? key,
      required this.vendorId,
      required this.results,
      required this.cityPrice})
      : super(key: key);

  @override
  State<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen>
    with TickerProviderStateMixin {
  late int vendorId = widget.vendorId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..getVendorCategories(vendorId),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = BlocProvider.of(context);
          Size size = MediaQuery.of(context).size;
          return (cubit.vendorCat == null)
              ? LoadingScreen()
              : Scaffold(
                  body: ListView(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 250,
                            child: Stack(
                              children: [
                                DefaultCachedNetworkImage(
                                  imageUrl: widget.results.cover ??
                                      "https://i.imgur.com/7vHILrC.jpeg",
                                  fit: BoxFit.cover,
                                  width: 600,
                                  height: 200,
                                ),
                                // Image.network(
                                //   widget.results.cover ??
                                //       "https://i.imgur.com/7vHILrC.jpeg",
                                //   fit: BoxFit.cover,
                                //   width: 600,
                                //   height: 200,
                                //   loadingBuilder: (BuildContext context,
                                //       Widget child,
                                //       ImageChunkEvent? loadingProgress) {
                                //     if (loadingProgress == null) return child;
                                //     return Center(
                                //       child: CircularProgressIndicator(
                                //         value: loadingProgress
                                //                     .expectedTotalBytes !=
                                //                 null
                                //             ? loadingProgress
                                //                     .cumulativeBytesLoaded /
                                //                 loadingProgress
                                //                     .expectedTotalBytes!
                                //             : null,
                                //       ),
                                //     );
                                //   },
                                // ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0.h),
                                        child: Card(
                                          elevation: 1,
                                          color: cubit.primaryColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Container(
                                              width: 145.w,
                                              height: 35,
                                              alignment: Alignment.center,
                                              child: Text(
                                                "${"Delivery In".tr()} : " +
                                                    " ₪ " +
                                                    widget.cityPrice,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyle(context,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    size: 12.sp),
                                                textAlign: TextAlign.center,
                                              )),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Card(
                                          color: Colors.black,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(55)),
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: CircleAvatar(
                                                  radius: 48,
                                                  backgroundImage: NetworkImage(
                                                      widget.results.image ??
                                                          "https://i.imgur.com/7vHILrC.jpeg"),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 10,
                                                right: 6,
                                                child: Container(
                                                  height: 15,
                                                  width: 15,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: widget.results
                                                                  .status ==
                                                              'open'
                                                          ? AppCubit.get(
                                                                  context)
                                                              .primaryColor
                                                          : widget.results
                                                                      .status ==
                                                                  'close'
                                                              ? Colors.red
                                                              : Colors.amber),
                                                ),
                                              )
                                            ],
                                          )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0.h),
                                        child: Card(
                                          elevation: 1,
                                          color: cubit.primaryColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Container(
                                              width: 100,
                                              height: 35,
                                              alignment: Alignment.center,
                                              child: Text(
                                                widget.results.deliveryTime! +
                                                    ' ' +
                                                    "minute".tr(),
                                                style: textStyle(context,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    size: 13.sp),
                                                textAlign: TextAlign.center,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SearchScreen()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Colors.grey.withOpacity(0.5)),
                                    child: Icon(
                                      Icons.search,
                                      color: cubit.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Colors.grey.withOpacity(0.8)),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Share.share(
                                  "${widget.results.name} \n ${widget.results.description!} \n كل ذلك في تطبيق طلباتك \n https://play.google.com/store/apps/details?id=com.talabatek.app");
                            },
                            child: Container(
                              height: 40.h,
                              width: 40.w,
                              decoration: BoxDecoration(
                                  color: AppCubit.get(context).themeMode == true
                                      ? Colors.grey.shade800.withOpacity(0.5)
                                      : Colors.grey.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(Icons.share),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                widget.results.description!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: textStyle(context, size: 12.sp),
                              ),
                            ),
                          ),
                  /*        InkWell(
                            onTap: () {
                              CacheHelper.getData(key: "isLogged") == false
                                  ? popDialog(
                                      context: context,
                                      title: 'Login First'.tr(),
                                      content: 'Please Sign In First'.tr(),
                                      boxColor: Colors.red)
                                  : AppCubit.get(context)
                                      .LikeShop(widget.results.id!, context);
                            },
                            child: Container(
                              height: 40.h,
                              width: 40.w,
                              decoration: BoxDecoration(
                                  color: AppCubit.get(context).themeMode == true
                                      ? Colors.grey.shade800.withOpacity(0.5)
                                      : Colors.grey.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(CacheHelper.getData(
                                          key:
                                              "vendorLiked${widget.results.id}") ==
                                      true
                                  ? Icons.favorite
                                  : Icons.favorite_border),
                            ),
                          )*/
                        ],
                      ),
                      Container(
                        height: cubit.vendorCat!.results!.length * 200.h,
                        child: ListView.builder(
                            itemCount: cubit.vendorCat!.results!.length,
                            physics: ScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 10.h),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: AppCubit.get(context).themeMode ==
                                              false
                                          ? Colors.grey[200]
                                          : Colors.grey[800],
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                CategoryProductsScreen(cubit
                                                                        .vendorCat!
                                                                        .results![
                                                                    index])));
                                                  },
                                                  child: Text(
                                                    'View All'.tr(),
                                                    style: textStyle(context,
                                                        size: 11.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            cubit.primaryColor),
                                                  )),
                                            ),
                                            Text(
                                                cubit.vendorCat!.results![index]
                                                    .name!,
                                                style: textStyle(
                                                  context,
                                                  size: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 150,
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          physics: const ScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1,
                                            mainAxisSpacing: 5,
                                            crossAxisSpacing: 5,
                                            childAspectRatio: 0.8,
                                          ),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: cubit.vendorCat!
                                              .results![index].products!.length,
                                          itemBuilder: (context, indexx) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: buildCatProduct(
                                                context: context,
                                                products: cubit
                                                    .vendorCat!
                                                    .results![index]
                                                    .products![indexx],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
