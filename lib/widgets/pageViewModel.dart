import 'package:flutter/material.dart';

class PageViewModel extends StatelessWidget {
  final String title;
  final Widget bodyWidget;
  final Widget image;

  // ignore: require_trailing_commas
  const PageViewModel(
      {required this.title, required this.bodyWidget, required this.image,});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: image,
            ),
            const SizedBox(
              height: 64,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
              child:Text(
                title,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            bodyWidget
          ],
        ),
      ),
    );
  }
}
