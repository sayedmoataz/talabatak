import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/cubit/app_cubit.dart';
import '../../../bloc/cubit/app_states.dart';
import '../../loading.dart';

import '../../../core/network/local/DbHelper.dart';
import '../../../theme/text_style.dart';
import '../../../widgets/LoadingShimmer.dart';
import '../../../widgets/empty_widget.dart';
import '../../ShopScreens/shop_details_screen.dart';
import '../../ShopScreens/shops_screens.dart';

class FavShopsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()
        ..getFavVendors(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {

        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);

          return  cubit.favVendors == null ? ListLoading() : cubit.favVendors!.results!.isEmpty
                  ? EmptyWidget('There are no favorites yet!'.tr())
                  : SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                      onTap: (){
                        cubit.changeGrid();
                      },
                      child: Padding(
                        padding:  EdgeInsets.symmetric(vertical: 10.0.h),
                        child: Card(
                          elevation: 1,
                          color: cubit.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: Container(
                              width: 200.w,
                              height: 40.h,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.change_circle_outlined,color: Colors.white,),
                                  Text('Change Design'.tr(),
                                    style: textStyle(context,fontWeight: FontWeight.bold,
                                        color: Colors.white,size: 16.sp),
                                    textAlign: TextAlign.center,),

                                ],
                              )
                          ),
                        ),
                      ),
                    ),
                    cubit.gridView == 0
                        ? AnimatedSwitcher(
                      key: ValueKey<int>(14),
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (Widget child,
                          Animation<double> animation) {
                        return FadeTransition(
                            child: child, opacity: animation);
                      },
                      child:  GridView.builder(
                        itemCount: cubit.favVendors!.results!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 150,
                          childAspectRatio: 1,
                          mainAxisSpacing: 22,),
                        itemBuilder: (context, index) =>
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0 ),
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Card(
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [

                                                ClipRRect(
                                                    borderRadius: BorderRadius.circular(12),
                                                    child: Image.network( cubit.favVendors!.results![index].image?? 'https://i.imgur.com/7vHILrC.jpeg' ,fit: BoxFit.cover,height: 80.h,width: 200,
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
                                                      },)),
                                               /* Align(
                                                    alignment: Alignment.topRight,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 12, right: 5),
                                                      child: Container(
                                                        height: 40,
                                                        width: 40,
                                                        alignment: Alignment.centerLeft,
                                                        decoration: BoxDecoration(
                                                            color: Colors.grey.withOpacity(0.8),
                                                            borderRadius: BorderRadius.circular(25)
                                                        ),
                                                        child: IconButton(
                                                          onPressed: (){
                                                            //AppCubit.get(context).LikeProduct(products.id!,context);

                                                          },
                                                          icon:Icon(CacheHelper.getData(key: "vendorLiked${cubit.favVendors!.results![index].id!}") == true ?Icons.favorite : Icons.favorite_border),
                                                        ),
                                                      ),
                                                    )),
*/

                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                              child: Text( cubit.favVendors!.results![index].name! ?? "",
                                                  style:textStyle(
                                                      context,
                                                      fontWeight: FontWeight.bold,
                                                      size: 14
                                                  )),
                                            ),
                                          ],
                                        )),

                                  ],

                                ),
                                onTap: () {
                               /*   Navigator.push(context, MaterialPageRoute(builder: (context)
                                  =>ShopDetailsScreen(vendorId: cubit.favVendors!.results![index].id!,results:cubit.favVendors!.results![index] ,)));
                               */ },
                              ),
                            ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                      ),
                    ) :
                    AnimatedSwitcher(
                      key: ValueKey<int>(14),
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (Widget child,
                          Animation<double> animation) {
                        return FadeTransition(
                            child: child, opacity: animation);
                      },
                      child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => buildShopsScreen(
                              context: context,
                              vendors: cubit.favVendors!.results![index]
                          ),
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 0,
                          ),
                          itemCount:
                          cubit.favVendors!.results!.length),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
