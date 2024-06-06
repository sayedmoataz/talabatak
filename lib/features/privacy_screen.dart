import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../theme/text_style.dart';


class InstructionsScreen extends StatefulWidget {


  @override
  State<InstructionsScreen> createState() => _InstructionsScreenState();
}

class _InstructionsScreenState extends State<InstructionsScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Privacy Policy".tr(),style:textStyle(
            context,
            fontWeight: FontWeight.bold,
            size: 18,
            spacing: 2.5
        )),

        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            children: [
              SizedBox(
                height: (MediaQuery.of(context).size.height * 10) / 812,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 150,
                    width: 150,
                  ),
                ],
              ),
              SizedBox(
                height: (MediaQuery.of(context).size.height * 50) / 812,
              ),
              Text(
                "About AppName App".tr(),
                style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 24),
              Text(
                "Who Are us ? ".tr(),
                style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "aboutUsDes".tr(),
                style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  SizedBox(height: 16),
                  Text(
                    "Changing Data safety".tr(),
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "dataSafetyDes".tr(),
                          style: Theme.of(context).textTheme.headline5!.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

             /* Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  SizedBox(height: 16),
                  Text(
                    "Jamali Developer contact:",
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Owner: Jamali Team \n\nDeveloper: Jamali (www.workPlus.com) \n\nJamali support: info@workPlus.com \n\n Jamali Website: www.workPlus.com",
                          style: Theme.of(context).textTheme.headline5!.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 42),*/

            ],
          ),
        ),
      ),
    );
  }
}
