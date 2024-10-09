import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomNoDataWidget extends StatefulWidget {
  const CustomNoDataWidget({Key? key}) : super(key: key);

  @override
  State<CustomNoDataWidget> createState() => _CustomNoDataWidgetState();
}

class _CustomNoDataWidgetState extends State<CustomNoDataWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/lottie_icons/no_data.json',
                height: 150, width: 130,fit: BoxFit.fill),
            Container(child: Text("No data found", style: TextStyle(color:Theme.of(context)
                .textTheme
                .displayLarge!
                .color!,),textAlign: TextAlign.center,)),

          ],
        ));
  }
}
