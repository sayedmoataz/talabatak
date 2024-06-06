import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/text_style.dart';

import '../bloc/cubit/app_cubit.dart';
import '../theme/palette.dart';
class FAQsScreen extends StatelessWidget {

  final List<String> questions = [
    'How can I subscribe to a monthly plan?',
    'How can I withdraw my winnings?',
    'What is the payment method and minimum withdrawal limit?',
    'What guarantees my rights?',
    'What is the 10 dollar plan?',
    'What is the 50 dollar plan?',
    'Do I have to pay in dollars to participate?',
    'How long does it take for the profits to reach my wallet?',
    'How long does it take for the withdrawal process to reach my personal account?',
    'Can I change from one plan to another?',
  ];

  final List<String> answers = [
    'You can subscribe to any of the plans by communicating with the official on the company\'s WhatsApp.',
    'You can easily withdraw your winnings by going to the withdrawal page and selecting the amount to be withdrawn.',
    'We deliver and receive via your bank - usdt binance - dollar payeer. With a minimum withdrawal of just 10 dollar.',
    'Quick withdrawal is the best guarantee of your rights, we do not restrict you to a large amount of money to be able to withdraw.',
    'It is a plan that allows you to earn 5 dollar from each subscriber who is invited through your referral link or by writing your code upon registration.',
    'It is a plan that allows you to earn 60% of the package for each subscriber who is invited through your referral link.',
    'No, you can subscribe to any of the plans by paying the equivalent in Sudanese pounds. So it is 6,000 pounds for the 10 dollar plan, and 30,000 pounds for the 50 dollar plan.',
    'Earnings are provided automatically after the invitee subscribes directly.',
    'The withdrawal process usually only takes 10-30 minutes.',
    'Yes, you can change from a lower plan to a higher plan and this will not affect your earnings.',
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: ()=>Navigator.pop(context),
        ),

        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        children: [
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: [
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 2.0,vertical: 8),
               child: Text("FAQs".tr(),
                 style: textStyle(context,size: 18.w,fontWeight: FontWeight.bold,
                 ),),
             ),
             SizedBox(width: 100,),
             Image.asset('assets/images/logo.png',
             width: 80,)
           ],
         ),
          Container(
            height: 555.h,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              itemBuilder: (context, index) {
                if (index == questions.length) {
                  return SizedBox(
                    height: 30,
                  );
                }
                return CustomExpansionTile(
                  question: questions[index].tr(),
                  answer: answers[index].tr(),
                );
              },
              itemCount: questions.length + 1,
            ),
          )
        ],
      ),
    );
  }
}

class CustomExpansionTile extends StatefulWidget {
  final String question;
  final String answer;

  CustomExpansionTile({
    required this.question,
    required this.answer,
  });

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool? isExpanded;

  @override
  void initState() {
    isExpanded = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [

          Flexible(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ExpansionTile(
                backgroundColor: Colors.transparent,
                collapsedBackgroundColor: Colors.transparent,
                collapsedIconColor: Colors.grey,
                iconColor: Palette.amber900,
                collapsedTextColor:Colors.grey,
                textColor:Colors.white ,
                onExpansionChanged: (bool value) {
                  setState(() {
                    isExpanded = value;
                  });
                },

                title: Text(
                  widget.question,
                  style: textStyle(
                    context,
                    fontWeight: FontWeight.w600,
                    size: 13,
                    color:AppCubit.get(context).themeMode == true ? Colors.grey[300]: Colors.black54,

                  ),
                ),
                children: <Widget>[
                  ListTile(
                    title: Text(
                      widget.answer,
                      style: textStyle(
                        context,
                        size: 13,
                        color:AppCubit.get(context).themeMode == true ? Colors.grey[300]: Colors.black54,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}