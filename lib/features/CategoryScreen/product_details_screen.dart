import 'package:chips_choice/chips_choice.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/cubit/app_cubit.dart';
import '../../bloc/cubit/app_states.dart';
import '../../core/network/local/DbHelper.dart';
import '../../models/product_model.dart';
import '../../theme/text_style.dart';
import '../../widgets/PopDialog.dart';
import '../../widgets/button.dart';
import '../../widgets/default_cached_network_image.dart';
import '../../widgets/textFormWidget.dart';
import '../layout/bottomNavigation_layout.dart';
import '../search_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Products results;
  const ProductDetailsScreen({required this.results});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late Products results = widget.results;
  PageController pageController = PageController();
  List optPrice = [];
  List<Options> optId = [];
  List<String> items = [];
  List<String> names = [];

  double total = 0;
  var noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getProducts(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          Size size = MediaQuery.of(context).size;
          AppCubit cubit = BlocProvider.of(context);
          return Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: cubit.showCart == true
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 45.0.h),
                      child: Container(
                        width: 330,
                        child: FloatingActionButton.extended(
                            backgroundColor: cubit.primaryColor,
                            onPressed: () {
                              CacheHelper.saveIntData(key: 'homePath', value: 0)
                                  .then((value) => {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BottomNavigation()))
                                      });
                            },
                            label: Text(
                              'Click here to place your order'.tr(),
                              style: textStyle(context,
                                  size: 15.sp, fontWeight: FontWeight.bold),
                            )),
                      ),
                    )
                  : Container(),
              bottomNavigationBar: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 35.0, horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: defaultMaterialButton(
                          press: results.available == false
                              ? () {}
                              : results.user!.email == 'Phone'
                                  ? () async {
                                      await launchUrl(
                                          Uri.parse(
                                              'tel://${results.user!.phone}'),
                                          mode: LaunchMode.externalApplication);
                                    }
                                  : () {
                                      items = [];
                                      cubit.price = 0;
                                      names = [];
                                      cubit.price +=
                                          double.parse(results.price!);
                                      cubit.selectedquantity =
                                          ValueNotifier<int>(1);
                                      for (int i = 0;
                                          i <=
                                              results.optionsGroups!.length - 1;
                                          i++) {
                                        // print(CacheHelper.getData(key: results.optionsGroups![i].id.toString()));
                                        if (CacheHelper.getData(
                                                key: results
                                                    .optionsGroups![i].id
                                                    .toString()) !=
                                            null) {
                                          items.add(CacheHelper.getData(
                                              key: results.optionsGroups![i].id
                                                  .toString()));
                                        }
                                      }
                                      items.addAll(
                                          CacheHelper.getData(key: 'multi'));
                                      items.remove('');
                                      //print(items.toString());
                                      for (int i = 0;
                                          i <=
                                              results.optionsGroups!.length - 1;
                                          i++) {
                                        for (int v = 0;
                                            v <=
                                                results.optionsGroups![i]
                                                        .options!.length -
                                                    1;
                                            v++) {
                                          if (items.contains(results
                                              .optionsGroups![i].options![v].id
                                              .toString())) {
                                            // print(results.optionsGroups![i].options![v].name.toString());
                                            // print(results.optionsGroups![i].options![v].value.toString());
                                            cubit.price += double.parse(results
                                                .optionsGroups![i]
                                                .options![v]
                                                .value!);
                                            names.add(results.optionsGroups![i]
                                                .options![v].name!);
                                            print(cubit.price);
                                            print(names);
                                          }
                                        }
                                      }
                                      cubit.finPrice = cubit.price;
                                      CacheHelper.getData(key: "isLogged") ==
                                              false
                                          ? popDialog(
                                              context: context,
                                              title: 'Login First'.tr(),
                                              content:
                                                  'Please Sign In First'.tr(),
                                              boxColor: Colors.red)
                                          : showMaterialModalBottomSheet(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                              context: context,
                                              builder: (context) =>
                                                  StatefulBuilder(builder:
                                                      (BuildContext context,
                                                          StateSetter
                                                              setState) {
                                                return Container(
                                                  height: 460.h,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                        height: 150.h,
                                                        width: 320.w,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 2,
                                                                color: Colors
                                                                    .grey),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        child: TextFormGlobal(
                                                          maxlines: 25,
                                                          controller:
                                                              noteController,
                                                          validator: (value) {
                                                            return value!
                                                                    .isEmpty
                                                                ? "Enter your Notes"
                                                                    .tr()
                                                                : null;
                                                          },
                                                          text:
                                                              'your Notes'.tr(),
                                                          icon: Icons
                                                              .note_add_sharp,
                                                          obscure: false,
                                                          textInputType:
                                                              TextInputType
                                                                  .text,
                                                        ),
                                                      ),
                                                      ChipSection(
                                                          userList: names),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Container(
                                                          width: 200,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              IconButton(
                                                                icon: Icon(Icons
                                                                    .remove),
                                                                onPressed: () =>
                                                                    cubit.decreaseqty(
                                                                        context),
                                                              ),
                                                              ValueListenableBuilder(
                                                                  //TODO 2nd: listen playerPointsToAdd
                                                                  valueListenable:
                                                                      cubit
                                                                          .selectedquantity,
                                                                  builder:
                                                                      (context,
                                                                          value,
                                                                          widget) {
                                                                    return Text(
                                                                        value
                                                                            .toString());
                                                                  }),
                                                              IconButton(
                                                                  icon: Icon(
                                                                      Icons
                                                                          .add),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      cubit
                                                                          .selectedquantity
                                                                          .value += 1;
                                                                      cubit.finPrice +=
                                                                          cubit
                                                                              .price;
                                                                      print(cubit
                                                                          .finPrice);
                                                                    });
                                                                  }),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              if (CacheHelper
                                                                      .getData(
                                                                          key:
                                                                              "isLogged") ==
                                                                  false) {
                                                                popDialog(
                                                                    context:
                                                                        context,
                                                                    title:
                                                                        'Login First'
                                                                            .tr(),
                                                                    content:
                                                                        'Please Sign In First'
                                                                            .tr(),
                                                                    boxColor:
                                                                        Colors
                                                                            .red);
                                                              } else {
                                                                if (cubit
                                                                        .finPrice ==
                                                                    0.0) {
                                                                  popDialog(
                                                                      context:
                                                                          context,
                                                                      title: 'Please Select your Choice First'
                                                                          .tr(),
                                                                      content:
                                                                          'You Should select your choice'
                                                                              .tr(),
                                                                      boxColor:
                                                                          Colors
                                                                              .red);
                                                                } else {
                                                                  cubit.AddToCard(
                                                                      results
                                                                          .id,
                                                                      cubit
                                                                          .selectedquantity
                                                                          .value,
                                                                      noteController
                                                                          .text,
                                                                      items,
                                                                      context);
                                                                }
                                                              }
                                                            },
                                                            child: Container(
                                                              height: 50,
                                                              width: 260,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          10,
                                                                      right: 15,
                                                                      left: 15),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  color: cubit
                                                                      .primaryColor),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 10,
                                                                      bottom:
                                                                          10),
                                                              child: Center(
                                                                child: Text(
                                                                  "Continue"
                                                                      .tr(),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          17,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          ValueListenableBuilder(
                                                              //TODO 2nd: listen playerPointsToAdd
                                                              valueListenable: cubit
                                                                  .selectedquantity,
                                                              builder: (context,
                                                                  value,
                                                                  widget) {
                                                                return Text(
                                                                  (cubit.finPrice)
                                                                          .toString() +
                                                                      " ₪",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16.sp),
                                                                );
                                                              }),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }),
                                            );
                                    },
                          bgColor: cubit.primaryColor,
                          textColor: Colors.white,
                          context: context,
                          icon: results.available == false
                              ? Icons.remove_shopping_cart
                              : Icons.add_shopping_cart,
                          label: results.available == false
                              ? 'Product not available'.tr()
                              : results.user!.email == 'Phone'
                                  ? "Phone & Order".tr()
                                  : "Add to Cart".tr()),
                    ),
                    const SizedBox(
                      width: 28,
                    ),
                    Expanded(
                      child: defaultMaterialButton(
                          press: () {
                            CacheHelper.getData(key: "isLogged") == false
                                ? popDialog(
                                    context: context,
                                    title: 'Login First'.tr(),
                                    content: 'Please Sign In First'.tr(),
                                    boxColor: Colors.red)
                                : AppCubit.get(context)
                                    .LikeProduct(results.id!, context);
                          },
                          bgColor: Colors.redAccent,
                          textColor: Colors.white,
                          context: context,
                          icon: Icons.favorite,
                          label: "Add to Favourite".tr()),
                    ),
                  ],
                ),
              ),
              body: Container(
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              height: 35,
                              width: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.grey.withOpacity(0.4)),
                              child: Icon(
                                Icons.arrow_back,
                                color: cubit.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          widget.results.user!.name!,
                          style:
                              textStyle(context, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchScreen()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 35,
                              width: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.grey.withOpacity(0.4)),
                              child: Icon(
                                Icons.search,
                                color: cubit.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 270,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: SmoothPageIndicator(
                                controller: pageController,
                                count: results.productImages!.length,
                                effect: ExpandingDotsEffect(
                                  expansionFactor: 2,
                                  dotHeight: 6,
                                  dotWidth: 20,
                                ),
                              ),
                            ),
                          ),
                          PageView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: results.productImages!.length,
                            controller: pageController,
                            itemBuilder: (context, index) =>
                                buildProductDetailsImage(
                                    context: context,
                                    size: size,
                                    model: results.productImages![index]),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              color: cubit.themeMode == true
                                  ? Colors.grey[800]!.withOpacity(0.6)
                                  : Colors.grey.withOpacity(0.8),
                              child: Container(
                                height: 100,
                                width: 340,
                                child: ListTile(
                                  title: Text(
                                    results.title!,
                                    style: textStyle(context,
                                        fontWeight: FontWeight.bold,
                                        size: 18.sp),
                                    textAlign: TextAlign.center,
                                  ),
                                  subtitle: Text(
                                    results.description!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 14,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                          itemCount: results.optionsGroups!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8),
                                child: Container(
                                    padding: EdgeInsets.all(8),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: cubit.primaryColor),
                                        color: cubit.themeMode == true
                                            ? Colors.grey[800]
                                            : Colors.grey,
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Column(children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              results
                                                  .optionsGroups![index].name!,
                                              style: textStyle(
                                                context,
                                                size: 13.sp,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          Text(
                                              results.optionsGroups![index]
                                                          .type ==
                                                      'single'
                                                  ? "Single".tr()
                                                  : "Multi".tr(),
                                              style: textStyle(
                                                context,
                                                size: 10.sp,
                                                color: cubit.primaryColor,
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Container(
                                          height: 50,
                                          child: (results.optionsGroups![index]
                                                          .type ==
                                                      'multi' ||
                                                  results.optionsGroups![index]
                                                          .type ==
                                                      '')
                                              ? filterMulti(
                                                  CacheHelper.getListData(
                                                          key: 'multi') ??
                                                      [''], (val) {
                                                  setState(() {
                                                    CacheHelper
                                                        .saveListStringData(
                                                            key: 'multi',
                                                            value: val);
                                                    print(
                                                        CacheHelper.getListData(
                                                            key: 'multi'));
                                                  });
                                                },
                                                  results.optionsGroups![index]
                                                      .options!)
                                              : filterSingle(
                                                  (val) {
                                                    setState(() {
                                                      CacheHelper.saveStringData(
                                                          key: results
                                                              .optionsGroups![
                                                                  index]
                                                              .id
                                                              .toString(),
                                                          value: val);
                                                      print(CacheHelper.getData(
                                                          key: results
                                                              .optionsGroups![
                                                                  index]
                                                              .id
                                                              .toString()));
                                                      print(results
                                                          .optionsGroups![index]
                                                          .id
                                                          .toString());
                                                    });
                                                  },
                                                  CacheHelper.getData(
                                                      key: results
                                                          .optionsGroups![index]
                                                          .id
                                                          .toString()),
                                                  results.optionsGroups![index]
                                                      .options!,
                                                )),
                                    ])));
                          }),
                    ),
                    /*
                */
                  ],
                ),
              )

              /*results.optionsGroups![index].type == 'single' ? filterSingle(
                                                (val) {

                                            }  ,
                                            CacheHelper.getData(key: results.optionsGroups![index].name),optName,)
                                              :
                                          filterMulti( CacheHelper.getListData(key: 'listt'+results.optionsGroups![index].name!) ?? [''],
                                                  (val) {},
                                              optId
                                          )*/
              /*
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),*/
              );
        },
      ),
    );
  }
}

class ProductDetailsModel {
  final String image;

  ProductDetailsModel({
    required this.image,
  });
}

Widget buildProductDetailsImage({
  required BuildContext context,
  required Size size,
  required ProductImages model,
}) =>
    Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 500,
        height: 200,
        child: DefaultCachedNetworkImage(
          imageUrl: model.image!,
          fit: BoxFit.contain,
        ),
        //  Image.network(
        //   model.image!,
        //   fit: BoxFit.contain,
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
    );
Widget filterSingle(onchanged, val, source) {
  return ChipsChoice<String>.single(
    value: val,
    onChanged: onchanged,
    choiceItems: C2Choice.listFrom<String, Options>(
      source: source,
      value: (index, item) => item.id.toString(),
      label: (index, item) => item.name.toString(),
    ),
  );
}

Widget filterMulti(tags, onChanged, options) {
  return ChipsChoice<String>.multiple(
    value: tags,
    onChanged: onChanged,
    choiceItems: C2Choice.listFrom<String, Options>(
      source: options!,
      value: (index, item) => item.id.toString(),
      label: (index, item) => item.name!,
    ),
  );
}

class ChipSection extends StatelessWidget {
  final List<String> userList;

  const ChipSection({Key? key, required this.userList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 3, crossAxisSpacing: 3),
        itemCount: userList.length,
        itemBuilder: (context, index) {
          return Chip(
            label: Text(userList[index]),
            onDeleted: null,
            deleteIcon: Icon(
              Icons.delete_outline,
              color: Colors.transparent,
            ),
          );
        },
      ),
    );
  }
}
