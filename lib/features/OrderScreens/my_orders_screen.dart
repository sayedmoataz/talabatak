import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../../bloc/cubit/app_cubit.dart';
import '../../bloc/cubit/app_states.dart';
import '../../core/network/local/DbHelper.dart';
import 'order_details_screen.dart';
import '../../theme/text_style.dart';
import '../../widgets/LoadingShimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/order_model.dart';
import '../../widgets/dialog_widget.dart';
import '../../widgets/empty_widget.dart';


class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getOrders(),

      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          Size size = MediaQuery.of(context).size;
          AppCubit cubit = BlocProvider.of(context);
          return (cubit.orderModel ==null) ? VListLoading(scroll: Axis.vertical,)  : Scaffold(
            appBar: AppBar(
              title: Text(
                "Your Orders".tr(),
                style:textStyle(context,size: 20.sp,fontWeight: FontWeight.bold)
              ),
            ),

            body: (cubit.orderModel!.results!.isEmpty) ?
            Center(child: EmptyWidget('There are no orders yet!'.tr())):
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      SizedBox(height: 10.h,),
                      ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const ScrollPhysics(),
                          itemBuilder: (context, index) => buildMyOrdersScreen(
                            context: context,
                            order:cubit.orderModel!.results![index],

                          ),
                          separatorBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 130.0,vertical: 20),
                            child: Container(
                              height: 2.h,
                              width: 30.w,
                              decoration: BoxDecoration(
                                color: AppCubit.get(context).primaryColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                          itemCount: cubit.orderModel!.results!.length
                      ),


                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
Widget buildMyOrdersScreen({
  required BuildContext context, required Results order,

}) =>
    Container(
      height: 191.h,
      child: Column(
        children: [
          Expanded (
            flex: 8,
            child: Container(
              height: 126.h,
              decoration: BoxDecoration(
                color:  AppCubit.get(context).themeMode == true  ?Colors.grey[800]!.withOpacity(0.9) :Colors.grey.withOpacity(0.8),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 5.0, vertical: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            order.name ?? '',
                            style: textStyle(context,size: 14,fontWeight: FontWeight.bold),
                            textAlign: TextAlign.end,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          Text(
                            order.status ?? '',
                            style: textStyle(context,size: 11,fontWeight: FontWeight.bold,color:
                                order.status == 'not started' ? Colors.amber : order.status == 'started' ? Colors.green :
                                order.status == 'preparing' ? Colors.indigo : order.status == 'in the way' ? Colors.orange :order.status == 'complete' ? Colors.green : Colors.red),
                            textAlign: TextAlign.end,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                         ],
                      ),
                    ),
                    Text(
                      order.phone ??'',
                      style:textStyle(context,size: 10.sp),
                      textAlign: TextAlign.end,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        cartItem('Quantity'.tr(),order.totalQuantity.toString() + ' min'.tr(),context),
                        cartItem('Shipping'.tr(),order.shipping ?? '' +  " ₪",context),
                        cartItem('Total'.tr(),order.total ?? '' +  " ₪",context),

                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)
                          =>OrderDetailsScreen(order)));
                         },
                        child: Container(
                          width: 100.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color:AppCubit.get(context).themeMode == true  ? Colors.grey[700]: Colors.grey
                          ),
                          child: Text('Order Details'.tr(),style: textStyle(context,color: AppCubit.get(context).primaryColor,
                              size: 10.sp,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),

                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 5.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                            radius: 20,
                            child: IconButton(
                              onPressed: (){
                                ShowDialog(context: context,
                                  gif: 'assets/gifs/location.gif',title: "Your Location".tr(),
                                  description: order.address ?? '',sharedKey: "isTrans",
                                  okBut: false,
                                  okString: "In Map".tr(), canString: 'Back'.tr(),
                                  canButton: ()=>Navigator.pop(context),
                                  okButton: () async {
                                    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${order.location ?? ''}';

                                    await launch(googleUrl);

                                  },
                                );
                              },
                              icon: Icon( Icons.location_on_outlined,
                                color: AppCubit.get(context).primaryColor,
                                size: 20,),
                            ),
                          ),
              CircleAvatar(
                            radius: 20,
                            child: IconButton(
                              onPressed: (){
                                ShowDialog(context: context,
                                  gif: 'assets/gifs/notes.gif',title: "Your Notes".tr(),
                                  description: order.notes ?? '',sharedKey: "isTrans",
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
      ),
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