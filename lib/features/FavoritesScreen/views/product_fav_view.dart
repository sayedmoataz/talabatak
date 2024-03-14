import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/cubit/app_cubit.dart';
import '../../../bloc/cubit/app_states.dart';
import '../../loading.dart';

import '../../../Router.dart';
import '../../../bloc/AuthCubit/auth_cubit.dart';
import '../../../widgets/LoadingShimmer.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/hot_offer.dart';

class FavProudctView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()
        ..getFavProducts(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {

        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);

          return  cubit.favProducts == null ? ListLoading() : cubit.favProducts!.results!.isEmpty
                  ? Center(child: EmptyWidget('There are no favorites yet!'.tr()))
                  : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:   GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio:1,
                      ),
                      itemCount: cubit.favProducts!.results!.length ,
                      itemBuilder: (context,index){
                        return buildGridProduct(
                          context: context,
                          products: cubit.favProducts!.results![index],

                        );
                      },
                    )
                  );
        },
      ),
    );
  }
}
