import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/cubit/app_cubit.dart';
import '../../bloc/cubit/app_states.dart';
import '../../widgets/default_cached_network_image.dart';
import 'product_details_screen.dart';
import '../../theme/text_style.dart';
import '../../widgets/empty_widget.dart';

import '../../widgets/LoadingShimmer.dart';
import '../../widgets/shoppage_skeleton.dart';

class HomeProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        if (AppCubit.get(context).categoryProducts == null) {
          return ListLoading();
        } else {
          var cubit = AppCubit.get(context);
          return SafeArea(
            child: Container(
              child: (cubit.categoryProducts!.results != null ||
                      cubit.categoryProducts!.count != 0)
                  ? GridView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 140,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) => InkWell(
                            child: Column(
                              children: [
                                Card(
                                    elevation: 0,
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: DefaultCachedNetworkImage(
                                            imageUrl: cubit
                                                    .categoryProducts!
                                                    .results![index]
                                                    .productImages![0]
                                                    .image ??
                                                "https://i.imgur.com/7vHILrC.jpeg",
                                            fit: BoxFit.contain,
                                            height: 80,
                                            width: 200,
                                          ),
                                          //  Image.network(
                                          //   cubit
                                          //           .categoryProducts!
                                          //           .results![index]
                                          //           .productImages![0]
                                          //           .image ??
                                          //       'https://i.imgur.com/7vHILrC.jpeg',
                                          //   fit: BoxFit.contain,
                                          //   height: 80,
                                          //   width: 200,
                                          //   loadingBuilder:
                                          //       (BuildContext context,
                                          //           Widget child,
                                          //           ImageChunkEvent?
                                          //               loadingProgress) {
                                          //     if (loadingProgress == null)
                                          //       return child;
                                          //     return Center(
                                          //       child:
                                          //           CircularProgressIndicator(
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
                                          // )
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              cubit
                                                          .categoryProducts!
                                                          .results![index]
                                                          .title!
                                                          .length >
                                                      11
                                                  ? cubit
                                                          .categoryProducts!
                                                          .results![index]
                                                          .title!
                                                          .substring(0, 10) +
                                                      "..."
                                                  : cubit.categoryProducts!
                                                      .results![index].title!,
                                              style: textStyle(
                                                context,
                                                fontWeight: FontWeight.w500,
                                                size: 12.sp,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailsScreen(
                                            results: cubit.categoryProducts!
                                                .results![index],
                                          )));
                            },
                          ),
                      itemCount: cubit.categoryProducts!.results!.length)
                  : Center(
                      child: EmptyWidget(
                        'No Products Yet'.tr(),
                      ),
                    ),
            ),
          );
        }
      },
      listener: (context, state) {},
    );
  }
}
