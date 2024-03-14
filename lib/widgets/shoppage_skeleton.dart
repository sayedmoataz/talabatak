import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../bloc/cubit/app_cubit.dart';

class SkeletonSingleCard1 extends StatelessWidget {
  const SkeletonSingleCard1(
      { required this.width, this.height = 18.0, this.child});

  final double? width, height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppCubit.get(context).themeMode == true  ? Colors.grey.shade700 : Colors.black,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.06),
            borderRadius: BorderRadius.circular(4.0)),
        child: child,
      ),
    );
  }
}

class SkeletonCardHorizonList1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SkeletonSingleCard1(width: size.width / 2, height: 18.0),
        ),
        SizedBox(height: size.height * 0.014),
        ListView.builder(
          itemCount: 20,
          shrinkWrap: true,
          clipBehavior: Clip.none,
          padding: EdgeInsets.zero,
          itemExtent: size.height * 0.165,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              // color: Colors.red,
              child: Row(
                children: [
                  SkeletonSingleCard1(
                      width: size.width / 3.96, height: size.height),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SkeletonSingleCard1(width: size.width / 3.5),
                          SizedBox(height: size.height * 0.016),
                          Row(
                            children: [
                              Expanded(
                                child: SkeletonSingleCard1(width: size.width),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.016),
                          Row(
                            children: [
                              Expanded(
                                child: SkeletonSingleCard1(width: size.width),
                              ),
                              SizedBox(width: size.width * 0.04),
                              Expanded(
                                child: SkeletonSingleCard1(width: size.width),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class SkeletonHorizon2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SkeletonSingleCard1(width: size.width / 1.5,height: 40),
          ),
          SizedBox(height: size.height * 0.016),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SkeletonSingleCard1(width: size.width / 1.1,height: 160),
          ),
          SizedBox(height: size.height * 0.016),


          SizedBox(
            width: double.infinity,
            height: 400,
            child: GridView.builder(
              itemCount: 16,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3
              ),
              clipBehavior: Clip.none,

              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(left: 10.0),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.10,
                        child: SkeletonSingleCard1(width: size.width),
                      ),
                      const SizedBox(height: 6.0),
                      SkeletonSingleCard1(width: size.width / 3.2),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
