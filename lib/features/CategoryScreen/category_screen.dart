
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/cubit/app_cubit.dart';
import '../../bloc/cubit/app_states.dart';
import '../loading.dart';
import '../../theme/text_style.dart';

import '../../core/network/local/DbHelper.dart';
import '../../widgets/LoadingShimmer.dart';
import '../../widgets/dialog_widget.dart';
import 'ProductList.dart';



class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>  with TickerProviderStateMixin {
  int _currentTabIndex = 0;
  int activeIndex= 44;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AppCubit()..getCategories()..getCatProducts(CacheHelper.getData(key: 'catId')),
      child: BlocConsumer<AppCubit, AppStates>(
          builder: (context, state) {
            var x = AppCubit.get(context);
            if(state is loadingCategoryStates || x.categoryModel == null ){
              return ListLoading();
            }

            else {

             return Scaffold(

                body:  Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        width: 88.w,
                        color:AppCubit.get(context).themeMode == false ?Colors.grey.shade200 : Colors.grey.shade700,
                        child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              Container(),
                          itemCount: x.categoryModel!.results!.length,
                          itemBuilder: (context, index) {
                            return x.categoryModel!.results![index].name == 'اضافات' ? Container(): InkWell(
                              onTap: () {
                                x.selectCat(index,x.categoryModel!.results![index].id!);
                              },
                              child: Container(
                                height: 50.h,
                                alignment: Alignment.center,
                                color:CacheHelper.getData(key: 'catInt') == x.categoryModel!.results![index].id  ? x.primaryColor : AppCubit.get(context).themeMode == false ?Colors.grey.shade200 : Colors.grey.shade700,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:    Text(
                                      x.categoryModel!.results![index].name!,
                                      style: textStyle(
                                        context,
                                        size: 12.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            width: 270.w,
                            height: MediaQuery.of(context).size.height-100,
                            child: HomeProductList(),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ) ;
            }
          },
        listener: (context, state) {
          if(state is SuccesGetDataStates){
            AppCubit.get(context).getArea(context);
            if(CacheHelper.getData(key: 'CityId') == null){


            }
          }
        },
      ),
    );
  }
}
