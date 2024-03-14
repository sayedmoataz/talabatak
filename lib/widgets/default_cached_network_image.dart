import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class DefaultCachedNetworkImage extends StatelessWidget {
  final double? height;
  final double? width;
  final double? iconSize;
  final double? padding;
  final String imageUrl;
  final BoxFit? fit;

  const DefaultCachedNetworkImage(
      {Key? key,
      this.height,
      required this.imageUrl,
      this.width,
      required this.fit,
      this.iconSize,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imageUrl != ''
        ? CachedNetworkImage(
            fit: fit,
            width: width,
            height: height,
            imageUrl: imageUrl,
            // progressIndicatorBuilder: (context, url, downloadProgress) {
            //   return Padding(
            //     padding: EdgeInsets.all(padding ?? 50.sp),
            //     child: Center(
            //         child: DefaultLoadingIndicator(
            //       value: downloadProgress.downloaded.toDouble(),
            //     )),
            //   );
            // },

            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.grey[800]!,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Padding(
                padding: EdgeInsets.all(padding ?? 35.sp),
                child: Image.asset(
                  "assets/images/app_logo.jpeg",
                  height: iconSize ?? 75.sp,
                  color: Colors.grey,
                )),
          )
        : Padding(
            padding: EdgeInsets.all(padding ?? 35.sp),
            child: Image.asset(
              "assets/images/app_logo.jpeg",
              height: iconSize ?? 75.sp,
              color: Colors.grey,
            ),
          );
  }
}
