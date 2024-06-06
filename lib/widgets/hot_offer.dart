import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/cubit/app_cubit.dart';
import '../models/product_model.dart';
import '../theme/text_style.dart';

import '../core/network/local/DbHelper.dart';
import '../features/CategoryScreen/product_details_screen.dart';
import '../models/category_product_model.dart';
import 'PopDialog.dart';
import 'default_cached_network_image.dart';

Widget buildHotOffers({
  required BuildContext context,
  required Products products,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen(
                        results: products,
                      )));
        },
        child: Container(
          width: 270.w,
          decoration: BoxDecoration(
            color: AppCubit.get(context).themeMode == false
                ? Colors.white
                : Colors.grey[700]!.withOpacity(0.8),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                color: AppCubit.get(context).themeMode == false
                    ? Colors.grey.shade200
                    : Colors.grey.shade900,
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Row(
            children: [
              Flexible(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        products.title!,
                        style: textStyle(context, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      /*      Text(
                        products.user!.vendor!.freeDeliveryLimit == null ? '': 'شحن مجاني لو الت',
                        style: textStyle(context,size: 9.sp),
                        textAlign: TextAlign.end,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),*/
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            products.showPrice != true
                                ? "As you want".tr()
                                : products.price! + " ₪",
                            style: textStyle(context,
                                size: 14.sp,
                                color: AppCubit.get(context).primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Text(
                                products.available == true
                                    ? "In Stock".tr()
                                    : "Out Of Stock".tr(),
                                style: textStyle(context,
                                    color: products.available == true
                                        ? AppCubit.get(context).primaryColor
                                        : Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                    size: 8.sp),
                              ),
                              Icon(
                                Icons.event_available,
                                color: products.available == true
                                    ? AppCubit.get(context).primaryColor
                                    : Colors.redAccent,
                                size: 12.sp,
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundImage: NetworkImage(
                                    products.user!.image ??
                                        'https://i.imgur.com/7vHILrC.jpeg'),
                              ),
                              const SizedBox(
                                width: 14,
                              ),
                              Text(
                                products.user!.name!,
                                style: textStyle(context,
                                    size: 10.sp, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8.5),
                      bottomRight: Radius.circular(12)),
                  child: SizedBox(
                    height: 150,
                    width: 100,
                    child: Image.network(
                      products.productImages![0].image!,
                      fit: BoxFit.fill,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

Widget buildGridProduct({
  required BuildContext context,
  required Products products,
}) =>
    InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                      results: products,
                    )));
      },
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                  height: 70.h,
                  width: 250.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12.r),
                        topLeft: Radius.circular(12.r)),
                    child: products.productImages![0].image!
                            .contains('https://talabatek.net/uploads/')
                        ? Image.network(
                            products.productImages![0].image ??
                                "https://i.imgur.com/7vHILrC.jpeg",
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            "https://talabatek.net/uploads/${products.productImages![0].image}",
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                  )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 0.6,
                        blurRadius: 0.6,
                        offset: const Offset(0, 0),
                      ),
                    ],
                    color: AppCubit.get(context).themeMode == false
                        ? Colors.white
                        : Colors.grey[800],
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          products.title!,
                          style: textStyle(context,
                              fontWeight: FontWeight.bold, size: 11.sp),
                          maxLines: 2,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                products.user!.image == null
                                    ? CircleAvatar(
                                        radius: 11,
                                        backgroundImage: NetworkImage(
                                          "https://i.imgur.com/7vHILrC.jpeg",
                                        ))
                                    : products.user!.image!.contains(
                                            'https://talabatek.net/uploads/')
                                        ? CircleAvatar(
                                            radius: 11,
                                            backgroundImage: NetworkImage(
                                              products.user!.image ??
                                                  "https://i.imgur.com/7vHILrC.jpeg",
                                            ),
                                          )
                                        : CircleAvatar(
                                            radius: 11,
                                            backgroundImage: NetworkImage(
                                              "https://talabatek.net/uploads/${products.user!.image}",
                                            ),
                                          ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  products.user!.name!.length > 20
                                      ? products.user!.name!.substring(0, 20) +
                                          '...'
                                      : products.user!.name!,
                                  style: textStyle(context,
                                      fontWeight: FontWeight.bold, size: 11.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.event_available,
                              color: products.available == true
                                  ? AppCubit.get(context).primaryColor
                                  : Colors.redAccent,
                              size: 16.sp,
                            ),
                            Text(
                              products.showPrice != true
                                  ? "As you want".tr()
                                  : " ₪ " + products.price!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontSize: 12),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
   /*       Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 12, right: 5),
                child: Container(
                  height: 35.h,
                  width: 35.w,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(25)),
                  child: IconButton(
                    onPressed: () {
                      CacheHelper.getData(key: "isLogged") == false
                          ? popDialog(
                              context: context,
                              title: 'Login First'.tr(),
                              content: 'Please Sign In First'.tr(),
                              boxColor: Colors.red)
                          : AppCubit.get(context)
                              .LikeProduct(products.id!, context);
                    },
                    icon: Icon(CacheHelper.getData(
                                key: "productLiked${products.id!}") ==
                            true
                        ? Icons.favorite
                        : Icons.favorite_border),
                    color: AppCubit.get(context).primaryColor,
                  ),
                ),
              )),*/
        ],
      ),
    );

Widget buildCatProduct({
  required BuildContext context,
  required Productss products,
}) =>
    InkWell(
      onTap: () {
        AppCubit.get(context).getProduct(products.id, context);
        /* Navigator.push(context, MaterialPageRoute(builder: (context)
        =>ProductDetailsScreen(results: products,)));*/
      },
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppCubit.get(context).themeMode == false
                  ? Colors.grey[200]
                  : Colors.grey[800],
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: products.productImages![0].image!
                      .contains('https://talabatek.net/uploads/')
                  ? DefaultCachedNetworkImage(
                      imageUrl: products.productImages![0].image ??
                          "https://i.imgur.com/7vHILrC.jpeg",
                      fit: BoxFit.cover,
                    )
                  // Image.network(
                  //     products.productImages![0].image ??
                  //         "https://i.imgur.com/7vHILrC.jpeg",
                  //     loadingBuilder: (BuildContext context, Widget child,
                  //         ImageChunkEvent? loadingProgress) {
                  //       if (loadingProgress == null) return child;
                  //       return Center(
                  //         child: CircularProgressIndicator(
                  //           value: loadingProgress.expectedTotalBytes != null
                  //               ? loadingProgress.cumulativeBytesLoaded /
                  //                   loadingProgress.expectedTotalBytes!
                  //               : null,
                  //         ),
                  //       );
                  //     },
                  //     fit: BoxFit.cover,
                  //   )
                  : DefaultCachedNetworkImage(
                      imageUrl:
                          "https://talabatek.net/uploads/${products.productImages![0].image}",
                      fit: BoxFit.cover,
                    ),
              // Image.network(
              //     "https://talabatek.net/uploads/${products.productImages![0].image}",
              //     fit: BoxFit.cover,
              //     loadingBuilder: (BuildContext context, Widget child,
              //         ImageChunkEvent? loadingProgress) {
              //       if (loadingProgress == null) return child;
              //       return Center(
              //         child: CircularProgressIndicator(
              //           value: loadingProgress.expectedTotalBytes != null
              //               ? loadingProgress.cumulativeBytesLoaded /
              //                   loadingProgress.expectedTotalBytes!
              //               : null,
              //         ),
              //       );
              //     },
              //   ),
            ),
          ),
          Positioned(
              top: 0,
              right: 0,
              child: Container(
                  height: 25.h,
                  width: 90.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppCubit.get(context).themeMode == false
                        ? Colors.grey[200]
                        : Colors.grey[700],
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15)),
                  ),
                  child: Text(
                    products.title!,
                    style: textStyle(context,
                        fontWeight: FontWeight.bold, size: 10),
                    textAlign: TextAlign.center,
                  ))),
          Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                  height: 25.h,
                  width: 90.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppCubit.get(context).themeMode == false
                        ? Colors.grey[200]
                        : Colors.grey[700],
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                  ),
                  child: Text(
                    products.showPrice != true
                        ? "As you want".tr()
                        : products.price! + " ₪ ",
                    style: textStyle(context,
                        fontWeight: FontWeight.bold, size: 10),
                    textAlign: TextAlign.center,
                  ))),
          /* Text( products.price! +" ₪ ",
            style: textStyle(context,fontWeight: FontWeight.bold,size: 10.sp,color: AppCubit.get(context).primaryColor),),
*/
        ],
      ),
    );
