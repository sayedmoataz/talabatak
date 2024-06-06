import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../Router.dart';
import '../../core/network/local/DbHelper.dart';
import '../../core/network/remote/dio_helper.dart';
import '../../features/CategoryScreen/product_details_screen.dart';
import '../../features/FavoritesScreen/cart_screen.dart';
import '../../features/OrderScreens/order_screen.dart';
import '../../features/ShopScreens/shops_screens.dart';
import '../../features/layout/bottomNavigation_layout.dart';
import '../../features/setting_screen.dart';
import '../../main.dart';
import '../../models/area_model.dart';
import '../../models/cart_model.dart';
import '../../models/category_model.dart';
import '../../models/category_product_model.dart';
import '../../models/notification_model.dart';
import '../../models/order_model.dart';
import '../../models/product_model.dart';
import '../../models/slider_model.dart';
import '../../models/vendor_model.dart';
import '../../theme/text_style.dart';
import '../../widgets/PopDialog.dart';
import '../../widgets/empty_widget.dart';
import 'app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState()) {
    int? pcIndex = CacheHelper.getData(key: 'primaryColor');
    bool firstMode = CacheHelper.getData(key: "isLight") ?? true;
    themeMode = firstMode ?? true;
    primaryColorIndex = pcIndex ?? 0;
    primaryColor = defaultColors[primaryColorIndex];
  }

  static AppCubit get(context) => BlocProvider.of(context);

  //----------------------------------------------------------------------------
  //bottom Navigation Bar
  int bottomNavIndex = 0;

  List<String> screenTitles = [
    'Home'.tr(),
    'Ads'.tr(),
    'Service'.tr(),
    'Referrals'.tr(),
    'Settings'.tr(),
  ];

  List<Widget> screens = [
    // HomeScreen(),
    // CategoryScreen(),
    CartScreen(),
    ShopsScreen(),
    SettingsScreen()
  ];
  var val = "value";
  bool isChanged = false;

  genderChange(value) {
    isChanged = true;
    val = value.toString();
    emit(changeGenderState());
  }

  int gridView = 0;
  changeGrid() {
    gridView = ++gridView;
    if (gridView > 2) gridView = 0;
    CacheHelper.saveIntData(key: "gridView", value: gridView);
    print(gridView);
    emit(changeGridState());
  }

  void changeBottomNavIndex(int value) {
    bottomNavIndex = value;
    print(bottomNavIndex);

    emit(BottomNavChangedState());
  }

//------------------------------------------------------------------------------
// OnBoarding Screens
  int currentPageView = 0;

  void changeCurrentPageView(int value) {
    currentPageView = value;
    emit(OnBoardingPageViewChangedState());
  }

  int primaryColorIndex = 0;

  List defaultColors = [
    Colors.green,
    Colors.amber,
    Colors.teal,
    Colors.cyan,
    Colors.deepOrange,
    Colors.blue,
    Colors.pink,
    Colors.deepPurple,
    Colors.lime,
    Colors.indigo,
    Colors.orange,
    Colors.brown,
    Colors.blueGrey,
  ];
  dynamic primaryColor = Colors.amber;

  void changePrimaryColorIndex(int newIndex, dynamic color) async {
    primaryColorIndex = newIndex;
    primaryColor = color;
    emit(PrimaryColorIndexState());
    //////////////////
    await CacheHelper.saveIntData(
      key: 'primaryColor',
      value: primaryColorIndex,
    );
  }

  String appLanguage = 'ar'; // en --or-- ar
  int changingLanguage = 0;

  void changeAppLanguage(String newValue) {
    appLanguage = newValue;
    changingLanguage = 1;
    emit(ChangeAppLanguageState());
    ////////////////
    CacheHelper.saveStringData(
      key: 'appLanguage',
      value: appLanguage,
    ).then((value) async {
      changingLanguage = 0;
      emit(ChangeAppLanguageSuccessState());
    });
  }

  String methodValue = 'Service Payment Method'.tr();
  bool methodChanged = false;

  methodChange(value) {
    methodChanged = true;
    methodValue = value.toString();
    emit(changeItemState());
  }

  String currencyValue = "Enter Service Currency".tr();
  bool currecnyChanged = false;

  currencyChange(value) {
    currecnyChanged = true;
    currencyValue = value.toString();
    emit(changeItemState());
  }

  String PlatformValue = "Enter Service Platform".tr();
  bool PlatformChanged = false;

  PlatformChange(value) {
    PlatformChanged = true;
    PlatformValue = value.toString();
    emit(changeItemState());
  }

  int selectedCat = CacheHelper.getData(key: 'catInt') ?? 12;
  selectCat(value, id) {
    print(id);
    print(value);
    CacheHelper.saveIntData(key: 'catInt', value: id);
    getCatProducts(id);
    emit(changeItemState());
  }

  bool isTextExpanded = true;
  IconData textExpandedIcon = Icons.keyboard_arrow_up_rounded;

  void changeExpandedText() {
    isTextExpanded = !isTextExpanded;
    textExpandedIcon = isTextExpanded
        ? Icons.keyboard_arrow_up_rounded
        : Icons.keyboard_arrow_down_rounded;
    emit(changeItemState());
  }

  ProductModel? categoryProducts;
  getCatProducts(vendorId) async {
    emit(loadingCategoryStates());

    await DioHelper.getData(
      url: 'api/product?categoryId=${CacheHelper.getData(key: 'catInt')}',
    ).then((value) {
      if (value.statusCode == 200) {
        categoryProducts = ProductModel.fromJson(value.data);
        print(value.data);
        emit(SuccesCategoryStates());
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorCategoryStates());
    });
  }

  bool subCatChanged = false;
  List<dynamic>? subData;

  File? imgToMatch;

  void makeImageToMatchEqualNull() {
    imgToMatch = null;
    emit(RemoveMatchImageState());
  }

  Future getImageToMatch(ImageSource source) async {
    emit(PickImageForMatchCardLoadingState());
    try {
      final XFile? image = await ImagePicker().pickImage(source: source);

      if (image == null) {
        emit(PickImageForMatchCardErrorState());
        return;
      }

      final imgTemp = File(image.path);
      imgToMatch = imgTemp;
      emit(PickImageForMatchCardSuccessState());
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
      emit(PickImageForMatchCardErrorState());
    }
  }

  bool themeMode = true;
  Color textColor = Colors.black;

  void changeTheme() {
    themeMode ? themeMode = false : themeMode = true;

    CacheHelper.saveBoolData(key: "isLight", value: themeMode);
    emit(ThemeChangedState());
  }

  getFirstMode(mode) {
    CacheHelper.saveBoolData(key: "isLight", value: mode);
    themeMode = CacheHelper.getData(key: "isLight");
    emit(getFirstModeState());
  }

  void splashTimer() async {
    await Future.delayed(
        Duration(seconds: 5), () => emit(SplashscreenLoading()));
  }

  bool notification = true;

  checkNotificationSetting() async {
    final value = CacheHelper.getData(key: 'notification') ?? 1;
    if (value == 1) {
      notification = true;
      enableNotification = true;
      emit(UpdateNotificationStatus());
    } else {
      notification = false;
      enableNotification = false;
      emit(UpdateNotificationStatus());
    }
  }

  saveNotificationSetting(context, bool val) async {
    final value = val ? 1 : 0;
    CacheHelper.saveIntData(key: 'notification', value: value);
    if (value == 1) {
      notification = true;
      enableNotification = true;
      emit(UpdateNotificationStatus());
    } else {
      notification = false;
      enableNotification = false;
      emit(UpdateNotificationStatus());
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacementNamed(context, Routes.homeScreen);
    });
    emit(SaveNotificationStatus());
  }

  NotificationModel? notificationModel;

  Future<void> getNotification() async {
    await DioHelper.getData(
      url: 'api/user-notifications',
    ).then((value) {
      if (value.statusCode == 200) {
        notificationModel = NotificationModel.fromJson(value.data);

        emit(GetNotificationSuccessState());
      }
    }).catchError((e) {
      print('getNotification error is: ${e.toString()}');
      emit(GetNotificationSuccessState());
    });
  }

  int products = 0, orders = 0, customers = 0;
  getNumbers(context) async {
    emit(loadingCategoryStates());

    await DioHelper.getData(
      url: 'api/numbers',
    ).then((value) async {
      if (value.statusCode == 200) {
        print(value.data);
        CacheHelper.saveIntData(
            key: 'productsNum', value: value.data['products']);
        CacheHelper.saveIntData(key: 'ordersNum', value: value.data['orders']);
        CacheHelper.saveIntData(
            key: 'customersNum', value: value.data['customers']);

        emit(SuccesCategoryStates());
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorCategoryStates());
    });
  }

  getNumbersAnim(context) async {
    emit(loadingCategoryStates());
    products = CacheHelper.getData(key: 'productsNum');
    orders = CacheHelper.getData(key: 'ordersNum');
    customers = CacheHelper.getData(key: 'customersNum');

    emit(SuccesCategoryStates());
  }

  VendorModel? vendorModel;
  List<Categories>? categorySearch = [];
  List<Products>? productSearch = [];
  List<Vendors>? shopSearch = [];
  getVendors(context) async {
    emit(loadingCategoryStates());

    await DioHelper.getData(
      url: 'vendor/get-vendors',
    ).then((value) {
      if (value.statusCode == 200) {
        vendorModel = VendorModel.fromJson(value.data);
        for (var element in vendorModel!.results!) {
          shopSearch!.add(element);
          print(element.id);
        }
        emit(SuccesCategoryStates());
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorCategoryStates());
    });
  }

  CategoryModel? categoryModel;

  getCategories() async {
    emit(loadingCategoryStates());

    await DioHelper.getData(
      url: 'api/category',
    ).then((value) {
      if (value.statusCode == 200) {
        categoryModel = CategoryModel.fromJson(value.data);
        for (var element in categoryModel!.results!) {
          categorySearch!.add(element);
          print(element.id);
        }
        emit(SuccesCategoryStates());
        emit(SuccesGetDataStates());
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorCategoryStates());
    });
  }

  Titlesearch(
      BuildContext context, TextEditingController textEditingController) {
    return Container(
      height: 39,
      margin: EdgeInsets.only(left: 25, right: 25, top: 18),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]
              : Colors.grey[300]),
      child: Stack(
        children: <Widget>[
          TextFormField(
            controller: textEditingController,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 19, right: 50, bottom: 8),
                border: InputBorder.none,
                hintText: 'Search...'.tr(),
                hintStyle:
                    TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            onChanged: (val) {
              print(val);
              getSearch(val);
            },
          ),
          Positioned(
            top: 8,
            right: 9,
            child: Icon(
              Icons.search_rounded,
            ),
          )
        ],
      ),
    );
  }

  getSearch(String val) {
    productSearch = [];
    shopSearch = [];
    categorySearch = [];
    val = val.toLowerCase();
    print(val);
    productModel!.results!.forEach((e) {
      var name = e.title!.toLowerCase();
      if (name.contains(val)) {
        productSearch!.add(e);
      }
    });
    vendorModel!.results!.forEach((e) {
      var name = e.name!.toLowerCase();
      if (name.contains(val)) {
        shopSearch!.add(e);
      }
    });
    categoryModel!.results!.forEach((e) {
      var name = e.name!.toLowerCase();
      if (name.contains(val)) {
        categorySearch!.add(e);
      }
    });
    if (val.isEmpty) {
      vendorModel!.results!.forEach((e) {
        shopSearch!.add(e);
      });
      categoryModel!.results!.forEach((e) {
        categorySearch!.add(e);
      });
      productModel!.results!.forEach((e) {
        productSearch!.add(e);
      });
    }
    emit(getSearchState());
  }

  ProductModel? productModel;
  getProducts() async {
    emit(loadingCategoryStates());

    await DioHelper.getData(
      url: 'api/product',
    ).then((value) {
      if (value.statusCode == 200) {
        CacheHelper.saveListStringData(key: 'multi', value: ['']);

        productModel = ProductModel.fromJson(value.data);

        for (var element in productModel!.results!) {
          productSearch!.add(element);
          print(element.id);
        }
        emit(SuccesCategoryStates());
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorCategoryStates());
    });
  }

  Products? results;
  getProduct(id, context) async {
    emit(loadingCategoryStates());

    await DioHelper.getData(
      url: 'api/product/$id',
    ).then((value) {
      if (value.statusCode == 200) {
        results = Products.fromJson(value.data['product']);
        print(results!.title!);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                      results: results!,
                    )));

        emit(SuccesCategoryStates());
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorCategoryStates());
    });
  }

  CategoryProductModel? vendorCat;
  getVendorCategories(vendorId) async {
    emit(loadingCategoryStates());

    await DioHelper.getData(
      url: 'api/vendor-categories?vendorId=$vendorId',
    ).then((value) {
      if (value.statusCode == 200) {
        vendorCat = CategoryProductModel.fromJson(value.data);
        print(value.data);
        emit(SuccesCategoryStates());
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorCategoryStates());
    });
  }

  ProductModel? bestSellerProducts;
  getBestSellerProducts() async {
    emit(loadingCategoryStates());

    await DioHelper.getData(
      url: 'api/product?bestseller=true',
    ).then((value) {
      if (value.statusCode == 200) {
        bestSellerProducts = ProductModel.fromJson(value.data);
        // print(value.data);
        emit(SuccesCategoryStates());
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorCategoryStates());
    });
  }

  ProductModel? featuredProducts;
  getFeaturedProducts() async {
    emit(loadingCategoryStates());

    await DioHelper.getData(
      url: 'api/product?featured=true',
    ).then((value) {
      if (value.statusCode == 200) {
        featuredProducts = ProductModel.fromJson(value.data);
        // print(value.data);
        emit(SuccesCategoryStates());
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorCategoryStates());
    });
  }

  int? sliderIndex;

  changeSliderIndex(index) {
    sliderIndex = index;
    emit(GetSliderIndexState());
  }

  LikeProduct(slug, context) async {
    emit(loadingLikesStates());
    await DioHelper.postData(url: 'api/product-like', data: {
      "productId": slug,
    }).then((value) {
      if (value.statusCode == 200) {
        popDialog(
            context: context,
            title: value.data['message'],
            content: ''.tr(),
            boxColor: AppCubit.get(context).primaryColor);
        print(value.data);
        value.data.toString().contains('الاضافه')
            ? CacheHelper.saveBoolData(key: "productLiked$slug", value: true)
            : CacheHelper.saveBoolData(key: "productLiked$slug", value: false);
        emit(SuccesLikesStates());
      } else {
        print(value.data);
        showToast(
          "Something wrong happen".tr(),
          borderRadius: BorderRadius.circular(5),
          context: context,
          animation: StyledToastAnimation.scale,
          reverseAnimation: StyledToastAnimation.fade,
          animDuration: Duration(milliseconds: 600),
        );
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorLikesStates());
    });
  }

  LikeShop(slug, context) async {
    emit(loadingLikesStates());
    await DioHelper.postData(url: 'api/vendor-like', data: {
      "vendorId": slug,
    }).then((value) {
      if (value.statusCode == 200) {
        popDialog(
            context: context,
            title: value.data['message'],
            content: ''.tr(),
            boxColor: AppCubit.get(context).primaryColor);
        print(value.data);
        value.data.toString().contains('الاضافه')
            ? CacheHelper.saveBoolData(key: "vendorLiked$slug", value: true)
            : CacheHelper.saveBoolData(key: "vendorLiked$slug", value: false);
        emit(SuccesLikesStates());
      } else {
        print(value.data);
        showToast(
          "Something wrong happen".tr(),
          borderRadius: BorderRadius.circular(5),
          context: context,
          animation: StyledToastAnimation.scale,
          reverseAnimation: StyledToastAnimation.fade,
          animDuration: Duration(milliseconds: 600),
        );
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorLikesStates());
    });
  }

  List<dynamic> options = [];
  ProductModel? favProducts;
  getFavProducts() async {
    emit(loadingBlogStates());
    await DioHelper.getData(
      url: 'api/favourite-products',
    ).then((value) {
      if (value.statusCode == 200) {
        favProducts = ProductModel.fromJson(value.data);
        emit(SuccesBlogStates());
      }
    }).catchError((e) {
      print(e.toString());
      emit(ErrorBlogStates());
    });
  }

  var selectedquantity = ValueNotifier<int>(1);
  int quantityy = 1;
  double price = 0;
  double finPrice = 0;
  void increaseqty(pricee) {
    selectedquantity.value++;
    finPrice = price * selectedquantity.value;
    emit(getQuantityState());
  }

  void decreaseqty(context) {
    if (selectedquantity.value > 1) {
      selectedquantity.value--;
      finPrice -= price;

      emit(getQuantityState());
    } else {
      showToast("اقل كميه من الطلب هي 1",
          context: context, backgroundColor: Colors.red);
      emit(getQuantityState());
    }
  }

  Future deleteFromCart(productId, context) async {
    emit(loadingDeleteCartStates());
    await DioHelper.deleteData(
      url: 'api/cart/$productId',
    ).then((value) {
      print(productId);
      print(value.statusCode);
      /* popDialog(
          context: context,
          title: 'Product Deleted'.tr(),
          content: ''.tr(),
          boxColor: AppCubit.get(context).primaryColor
      );*/
      emit(SuccesDeleteCartStates());
      getCart();
    }).catchError((error) {
      print(error.toString());
      emit(ErrorDeleteCartStates());
    });
  }

  updateCart(context, {quantity, id}) async {
    emit(loadingUpdateCartStates());
    await DioHelper.putData(url: "api/cart/$id", data: {
      "quantity": quantity,
    }).then((value) {
      print(value.data);
      emit(SuccesCartStates());
      getCart();
    }).catchError((e) {
      showToast(
        "Something wrong happen",
        borderRadius: BorderRadius.circular(5),
        context: context,
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        animDuration: Duration(milliseconds: 600),
      );
      print(e.toString());
      emit(ErrorCartStates());
    });
  }

  VendorModel? favVendors;
  getFavVendors() async {
    emit(loadingBlogStates());
    await DioHelper.getData(
      url: 'api/favourite-vendors',
    ).then((value) {
      if (value.statusCode == 200) {
        favVendors = VendorModel.fromJson(value.data);
        emit(SuccesBlogStates());
      }
    }).catchError((e) {
      print(e.toString());
      emit(ErrorBlogStates());
    });
  }

  SliderModel? sliderModel;

  getSlider() async {
    emit(loadingImageStates());
    print('slider data');
    await DioHelper.getData(
      url: 'api/slider',
    ).then((value) {
      if (value.statusCode == 200 || value.statusCode == 201) {
        sliderModel = SliderModel.fromJson(value.data);

        print(value.data);
        emit(SuccesImageStates());
      } else {
        print(value.data);
      }
    }).catchError((e) {
      print(e.toString());
      emit(ErrorImageStates());
    });
  }

  AreaModel? areaModel;
  getArea(context, {bool screen = false}) {
    emit(loadingCommentsStates());
    DioHelper.getData(
      url: 'api/area',
    ).then((value) {
      if (value.statusCode == 200) {
        print(value.data);
        areaModel = AreaModel.fromJson(value.data);
        print(value.data);
        if (screen == false) {
          AreaUi(context);
        }
      }
      emit(SuccesaddCommentsStates());
    }).catchError((error) {
      print(error.toString());
      emit(ErroraddCommentsStates());
    });
  }

  AreaUi(context) {
    Scaffold.of(context).showBottomSheet(
      (context) => SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 200.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppCubit.get(context).themeMode == true
                ? Colors.grey[800]
                : Colors.white,
            borderRadius: BorderRadiusDirectional.only(
              topEnd: Radius.circular(20),
              topStart: Radius.circular(30),
            ),
          ),
          child: areaModel == null
              ? Center(child: EmptyWidget('No Delivery Area'.tr()))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).viewInsets.bottom == 0
                            ? MediaQuery.of(context).size.height - 220.h
                            : MediaQuery.of(context).size.height - 380.h,
                        width: MediaQuery.of(context).size.width,
                        child: areaModel!.results!.length == 0
                            ? Center(
                                child: EmptyWidget('No Delivery Area'.tr()))
                            : ListView(
                                children: [
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  Text(
                                    'Delivery To'.tr(),
                                    style: textStyle(context,
                                        fontWeight: FontWeight.bold,
                                        size: 14.sp),
                                    textAlign: TextAlign.center,
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.symmetric(vertical: 30),
                                    scrollDirection: Axis.vertical,
                                    itemCount: areaModel!.results!.length,
                                    itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: InkWell(
                                        onTap: () {
                                          CacheHelper.saveIntData(
                                              key: 'CityId',
                                              value: areaModel!
                                                  .results![index].id);
                                          CacheHelper.saveStringData(
                                              key: 'CityName',
                                              value: areaModel!
                                                  .results![index].name!);
                                          popDialog(
                                              context: context,
                                              title:
                                                  'Delivery Place Chosen'.tr(),
                                              content:
                                                  'Choose done successfully'
                                                      .tr(),
                                              boxColor: primaryColor);
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                  color: primaryColor,
                                                  width: 2)),
                                          child: Text(
                                            areaModel!.results![index].name!,
                                            style: textStyle(
                                              context,
                                              fontWeight: FontWeight.bold,
                                              size: 16.w,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  String areaNamee = '1';
  bool areaChanged = false;
  areaChange(name, id, context) {
    areaChanged = true;
    areaNamee = name.toString();
    CalculateShipping(id, context, status: true);
    emit(changeItemState());
  }

  CalculateShipping(areaId, context, {bool status = false}) async {
    emit(loadingLikesStates());
    await DioHelper.postData(url: 'api/shipping/', data: {
      "areaId": areaId,
    }).then((value) {
      if (value.statusCode == 200 || value.statusCode == 201) {
        print(value.data);
        CacheHelper.saveStringData(
            key: 'shippingCost', value: value.data['shipping'].toString());
        CacheHelper.saveStringData(
            key: 'totalCost', value: value.data['total'].toString());
        CacheHelper.saveStringData(
            key: 'timeCost', value: value.data['time'].toString());
        if (status == false) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddOrderScreen()));
        }

        emit(SuccesLikesStates());
      } else {
        popDialog(
            context: context,
            title: "Something wrong happen".tr(),
            content: value.data['message'],
            boxColor: Colors.red);
        print(value.data);
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorLikesStates());
    });
  }

  bool showCart = false;
  AddToCard(productId, quantity, notes, options, context) async {
    emit(loadingLikesStates());
    await DioHelper.postData(url: 'api/cart', data: {
      "productId": productId,
      "quantity": quantity,
      "notes": notes,
      "options": options
    }).then((value) {
      if (value.statusCode == 200 || value.statusCode == 201) {
        popDialog(
            context: context,
            title: 'Added to cart'.tr(),
            content: ''.tr(),
            boxColor: AppCubit.get(context).primaryColor);
        Navigator.pop(context);
        print(value.data);
        showCart = true;

        emit(SuccesLikesStates());
      } else {
        popDialog(
            context: context,
            title: "Something wrong happen".tr(),
            content: ''.tr(),
            boxColor: Colors.red);
        print(value.data);
        showToast(
          "Something wrong happen".tr(),
          borderRadius: BorderRadius.circular(5),
          context: context,
          animation: StyledToastAnimation.scale,
          reverseAnimation: StyledToastAnimation.fade,
          animDuration: Duration(milliseconds: 600),
        );
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorLikesStates());
    });
  }

  CartModel? cartModel;

  getCart() async {
    emit(loadingImageStates());
    await DioHelper.getData(
      url: 'api/cart',
    ).then((value) {
      if (value.statusCode == 200 || value.statusCode == 201) {
        print('cart data');
        print(value.data);
        cartModel = CartModel.fromJson(value.data);

        print(value.data);
        emit(SuccesImageStates());
      } else {
        print(value.data);
      }
    }).catchError((e) {
      print(e.toString());
      emit(ErrorImageStates());
    });
  }

  OrderModel? orderModel;

  getOrders() async {
    emit(loadingImageStates());
    await DioHelper.getData(
      url: 'api/user-orders',
    ).then((value) {
      if (value.statusCode == 200 || value.statusCode == 201) {
        print('order data');
        print(value.data);
        orderModel = OrderModel.fromJson(value.data);
        print(value.data);
        emit(SuccesImageStates());
      } else {
        print(value.data);
      }
    }).catchError((e) {
      print(e.toString());
      emit(ErrorImageStates());
    });
  }

  late List<Placemark> placemarks;
  String latitude = '00.00000';
  String longitude = '00.00000';
  late String adrees;


  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log( "من فضلك قم بتشغيل الموقع الجغرافي");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log("من فضلك قم بتشغيل الموقع الجغرافي");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      log("خدمات التطبيق تعمل من خلال تحديد الموقع الجغرافي");
    }

    await Geolocator.getCurrentPosition().then((value) async {
      latitude = value.latitude.toString();
      longitude = value.longitude.toString();
      placemarks =
      await placemarkFromCoordinates(value.latitude, value.longitude);
      adrees = "${placemarks[0].country.toString()} - ${placemarks[0].administrativeArea.toString()} - ${placemarks[0].subAdministrativeArea.toString()}";
      if (kDebugMode) {
        print(adrees);
      }
      if (kDebugMode) {
        print("latitude is $latitude\nlongitude is $longitude");
      }
      emit(HomeGetLocationState());
    }).catchError((e) {
      if (kDebugMode) {
        print("getCurrentLocation error is : $e");
      }
    });
  }

  AddOrder(areaId, address, name, phone, notes, context) async {
    print(areaNamee);
    emit(loadingLikesStates());
    log('----------------------------------------------------');
    log(areaNamee);
    log(address);
    log(name);
    log(phone);
    log(notes);
    log(CacheHelper.getData(key: 'langlot'));
    log('----------------------------------------------------');
    CacheHelper.saveStringData(key: 'orderName', value: name);
    await DioHelper.postData(url: 'api/order', data: {
      "areaId": areaNamee ?? 1,
      "address": CacheHelper.getData(key: 'CityName'),
      "name": name,
      "phone": phone,
      "notes": notes,
      "location": CacheHelper.getData(key: 'langlot'),
    }).then((value) {
      if (value.statusCode == 200 || value.statusCode == 201) {
        popDialog(
            context: context,
            title: 'Order Sent Successfully'.tr(),
            content: 'See the process in your orders'.tr(),
            boxColor: AppCubit.get(context).primaryColor);

        CacheHelper.saveIntData(key: 'homePath', value: 1).then((value) => {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => BottomNavigation()))
            });
        CacheHelper.saveStringData(key: 'orderName', value: '');
        CacheHelper.saveStringData(key: 'orderNote', value: '');

        print(value.data);

        emit(SuccesLikesStates());
      } else {
        popDialog(
            context: context,
            title: "Something wrong happen".tr(),
            content: ''.tr(),
            boxColor: Colors.red);
        print(value.data);
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorLikesStates());
    });
  }
}
