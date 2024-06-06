import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../../bloc/cubit/app_cubit.dart';
import '../../bloc/cubit/app_states.dart';
import '../../core/network/local/DbHelper.dart';
import '../../models/order_model.dart';
import '../../theme/text_style.dart';

import '../../widgets/LoadingShimmer.dart';
import '../../widgets/dialog_widget.dart';
import '../../widgets/empty_widget.dart';


class OrderDetailsScreen extends StatelessWidget {
  Results? order;
  OrderDetailsScreen(this.order);
  List<String> options = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        Size size = MediaQuery.of(context).size;
        for(int i =0;i<= order!.cartProducts!.length-1;i++){
          for(int v =0;v<= order!.cartProducts![i].options!.length -1;v++){
            options.add(order!.cartProducts![i].options![v].name!);
          }

        }
        AppCubit cubit = BlocProvider.of(context);
        return  Scaffold(
          appBar: AppBar(
            title: Text(
              "Order Details".tr(),
              style:textStyle(context,size: 14.sp,fontWeight: FontWeight.bold)
            ),
            actions:[
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 20.h,
                  width: 160.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color:AppCubit.get(context).themeMode == true  ? Colors.grey[800]: Colors.grey
                  ),
                  child: Text(order!.createdAt!.substring(0,16),style: textStyle(context,color: cubit.primaryColor,
                      size: 12.sp,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                ),
              ),
              SizedBox(width: 10,)
            ] ,
          ),

          body: 
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 70.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color:AppCubit.get(context).themeMode == true  ? Colors.grey[800]: Colors.grey
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          cartItem('Products'.tr(),order!.cartProducts!.length.toString(),context),
                          cartItem('Quantity'.tr(),order!.totalQuantity.toString(),context),
                          cartItem('Total'.tr(),order!.total! +  " ₪",context),

                        ],
                      ),
                    ),

                    SizedBox(height: 10.h,),
                    ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) => buildOrderDetailsScreen(
                          context: context,
                          cart:order!.cartProducts![index],
                          options: options

                        ),
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                        itemCount: order!.cartProducts!.length
                    ),


                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
Widget buildOrderDetailsScreen({
  required BuildContext context, required CartProducts cart,options

}) =>
    Row(
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
            child: Container(
              height: 128.h,
              decoration: BoxDecoration(
                color:  AppCubit.get(context).themeMode == true  ?Colors.grey[800]!.withOpacity(0.9) :Colors.grey.withOpacity(0.8),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                boxShadow: [

                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                cart.product!.title!,
                                style: textStyle(context,size: 14,fontWeight: FontWeight.bold),
                                textAlign: TextAlign.end,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                cart.total!+ " ₪",
                                style:textStyle(context,size: 14.sp),
                                textAlign: TextAlign.end,
                              ),
                             ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            cart.product!.description!,
                            style:textStyle(context,size: 9.sp),
                            textAlign: TextAlign.end,
                          ),
                         
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  width: 25.w,
                                  height: 25.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey,width: 1),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Text(cart.quantity.toString() ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    child: IconButton(
                                      onPressed: (){
                                        ShowDialog(context: context,
                                          gif: 'assets/gifs/options.gif',title: "Your Options".tr(),
                                          description:options.toString().replaceAll('[', '').replaceAll(']', '') ,sharedKey: "isTrans",
                                          okBut: true,
                                          okString: "Back".tr(), canString: 'Back'.tr(),
                                          canButton: ()=>Navigator.pop(context),
                                          okButton: ()=>Navigator.pop(context),
                                        );
                                      },
                                      icon: Icon( Icons.restaurant_menu,
                                        color: AppCubit.get(context).primaryColor,
                                        size: 20,),
                                    ),
                                  ),
                                  SizedBox(width: 10.w,),
                                  CircleAvatar(
                                    radius: 20,
                                    child: IconButton(
                                      onPressed: (){
                                        ShowDialog(context: context,
                                          gif: 'assets/gifs/notes.gif',title: "Your Notes".tr(),
                                          description: cart.notes ?? '',sharedKey: "isTrans",
                                          okBut: true,
                                          okString: "Back".tr(), canString: 'Back'.tr(),
                                          canButton: ()=>Navigator.pop(context),
                                          okButton: ()=>Navigator.pop(context),
                                        );
                                      },
                                      icon: Icon( Icons.note_alt_outlined,
                                        color: AppCubit.get(context).primaryColor,
                                        size: 20,),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),

      ],
    );

Widget cartItem(title,value,context){
  return Container(
    height: 60.h,
    width: 100.w,
    alignment: Alignment.center,
    child: ListTile(
      title: Text(title,textAlign: TextAlign.center,
      style: textStyle(context,size: 12.sp,fontWeight: FontWeight.bold),),
      subtitle: Text(value,textAlign: TextAlign.center,),
    ),
  );
}