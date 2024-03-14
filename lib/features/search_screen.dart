
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/cubit/app_cubit.dart';
import '../bloc/cubit/app_states.dart';
import 'CategoryScreen/product_details_screen.dart';
import '../theme/text_style.dart';

import 'ShopScreens/shop_details_screen.dart';
import 'ShopScreens/shops_screens.dart';



class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var textController =TextEditingController();

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit, AppStates>(
    listener: (ctx, state) {},
    builder: (ctx, state) {
      return Scaffold(
        body: ListView(
          children: [
            AppCubit.get(context).Titlesearch(context,textController,),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Restaurants".tr(),style: textStyle(
                context,
                  size: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: AppCubit.get(context).primaryColor,

                  spacing: 1.5
              ),),
            ),
            ListView.separated(
              separatorBuilder: (context,index)=>Divider(),
              padding: const EdgeInsets.all(10),
              itemCount: AppCubit.get(ctx).shopSearch!.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InkWell(
                  onTap: (){
                    vendorCondition(AppCubit.get(ctx).shopSearch![index],context);

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppCubit.get(ctx).shopSearch![index].name!,
                        style: textStyle(
                            context,
                            size:12.sp,
                            fontWeight: FontWeight.bold
                        ),),
                      Image.network(AppCubit.get(ctx).shopSearch![index].image ?? 'https://i.imgur.com/7vHILrC.jpeg',width: 40,loadingBuilder: (BuildContext context, Widget child,
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
                      },)
                    ],
                  )
                ),
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            ),
          /*  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Categories".tr(),style: textStyle(
                context,
                  size: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: AppCubit.get(context).primaryColor,
                  spacing: 1.5
              ),),
            ),
            ListView.separated(
              separatorBuilder: (context,index)=>Divider(),
              padding: const EdgeInsets.all(10),
              itemCount: AppCubit.get(ctx).categorySearch!.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InkWell(
                  //onTap: ()=>Get.to(()=>AllProductsScreen(ProductCubit.get(context).categorySearch![index].id)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppCubit.get(ctx).categorySearch![index].name!,
                        style: textStyle(
                            context,
                            size:12.sp,
                            fontWeight: FontWeight.bold
                        ),),
                      Image.network(AppCubit.get(ctx).categorySearch![index].image ?? 'https://i.imgur.com/7vHILrC.jpeg',width: 40,)
                    ],
                  )
                ),
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            ),*/
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text("Products".tr(),style: textStyle(
                 context,
                   size: 17.sp,
                   fontWeight: FontWeight.bold,
                   color: AppCubit.get(context).primaryColor,
                 spacing: 1.5
               ),),
             ),
            ListView.separated(
              separatorBuilder: (context,index)=>Divider(),
              padding: const EdgeInsets.all(10),
              itemCount: AppCubit.get(ctx).productSearch!.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)
                    =>ProductDetailsScreen(results: AppCubit.get(ctx).productSearch![index],)));
                    },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppCubit.get(ctx).productSearch![index].title!,
                        style: textStyle(
                            context,
                            size:12.sp,
                            fontWeight: FontWeight.bold
                        ),),
                      Image.network(AppCubit.get(ctx).productSearch![index].productImages![0].image ?? 'https://i.imgur.com/7vHILrC.jpeg',width: 40,loadingBuilder: (BuildContext context, Widget child,
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
                      },)
                    ],
                  )
                ),
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            ),
          ],
        )
      );
    },
    );
  }
}
