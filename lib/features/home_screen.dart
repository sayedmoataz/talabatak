import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/cubit/app_cubit.dart';
import '../bloc/cubit/app_states.dart';
import '../theme/text_style.dart';
import '../widgets/LoadingShimmer.dart';
import '../widgets/hot_offer.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()
        ..getNumbersAnim(context)
        ..getSlider()
        ..getProducts()
        ..getFeaturedProducts()
        ..getBestSellerProducts(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, Object? state) {},
        builder: (BuildContext context, state) {
          AppCubit cubit = AppCubit.get(context);
          return (cubit.sliderModel == null || cubit.productModel == null)
              ? CardColumnScreen()
              : Scaffold(
                  body: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchScreen()));
                          },
                          child: Card(
                            elevation: 1,
                            color: AppCubit.get(context).themeMode == true
                                ? Colors.grey[800]
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.search),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Search...".tr(),
                                      style: textStyle(context,
                                          size: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey),
                                    )
                                  ],
                                )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: CarouselSlider(
                          options: CarouselOptions(
                            onPageChanged: (index, reason) {
                              cubit.changeSliderIndex(index);
                            },
                            autoPlay: true,
                            aspectRatio: 2.2,
                            viewportFraction: 0.9,
                            enlargeCenterPage: true,
                          ),
                          items: List.generate(
                            cubit.sliderModel!.results!.length,
                            (int index) => Container(
                                width: MediaQuery.of(context).size.width,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.network(
                                    cubit.sliderModel!.results![index].image!,
                                    fit: BoxFit.fill,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Image.network(
                                          "https://i.imgur.com/kBOeCoM.png");
                                    },
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                )),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: cubit.sliderModel!.results!.map((url) {
                          int index = cubit.sliderModel!.results!.indexOf(url);
                          return Container(
                            width: 30.0,
                            height: 3.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: cubit.sliderIndex == index
                                  ? cubit.primaryColor
                                  : Colors.grey,
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        width: 320.w,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppCubit.get(context).primaryColor,
                                Colors.greenAccent
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            statistics(cubit.orders, ' ' + 'orders'.tr(),
                                Icons.control_point_duplicate, context),
                            statistics(cubit.products, ' ' + 'product'.tr(),
                                Icons.category_outlined, context),
                            statistics(cubit.customers, ' ' + 'user'.tr(),
                                Icons.people_alt_outlined, context),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8),
                        child: Column(
                          children: [
                            if (cubit.featuredProducts != null &&
                                cubit.featuredProducts!.results!.length !=
                                    0) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Featured Products".tr(),
                                      style: textStyle(context,
                                          fontWeight: FontWeight.bold,
                                          size: 17.sp)),
                                ],
                              ),
                              SizedBox(
                                height: 150,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount:
                                      cubit.featuredProducts!.results!.length,
                                  itemBuilder: (context, index) =>
                                      buildHotOffers(
                                    context: context,
                                    products:
                                        cubit.featuredProducts!.results![index],
                                  ),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    width: 12,
                                  ),
                                ),
                              ),
                            ],
                            if (cubit.bestSellerProducts != null &&
                                cubit.bestSellerProducts!.results!.length !=
                                    0) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Best Seller".tr(),
                                      style: textStyle(context,
                                          fontWeight: FontWeight.bold,
                                          size: 17.sp)),
                                ],
                              ),
                              SizedBox(
                                height: 150,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: 2,
                                  itemBuilder: (context, index) =>
                                      buildHotOffers(
                                    context: context,
                                    products: cubit
                                        .bestSellerProducts!.results![index],
                                  ),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    width: 12,
                                  ),
                                ),
                              ),
                            ],
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "All Products".tr(),
                                style: textStyle(context,
                                    fontWeight: FontWeight.bold, size: 17.sp),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1,
                              ),
                              itemCount: cubit.productModel!.results!.length,
                              itemBuilder: (context, index) {
                                return buildGridProduct(
                                  context: context,
                                  products: cubit.productModel!.results![index],
                                );
                              },
                            ),
                            SizedBox(
                              height: 60.h,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ));
        },
      ),
    );
  }

  Widget statistics(int val, title, icon, context) {
    return Container(
        width: 100.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              val.toString(),
              style:
                  textStyle(context, size: 15.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style:
                  textStyle(context, size: 11.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}
