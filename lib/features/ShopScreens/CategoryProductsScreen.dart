import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/cubit/app_cubit.dart';
import '../../models/category_product_model.dart';
import '../../theme/text_style.dart';
import '../../widgets/hot_offer.dart';

class CategoryProductsScreen extends StatelessWidget {
  Results results;

  CategoryProductsScreen(this.results);

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          results.name!,
          style: textStyle(context, size: 20.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Container(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: results.products!.length,
          itemBuilder: (context, indexx) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildCatProduct(
                context: context,
                products: results.products![indexx],
              ),
            );
          },
        ),
      ),
    ));
  }
}
