import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:flutter/material.dart';

class SlideDots extends StatelessWidget {
  bool isActive;
  SlideDots(this.isActive);

  @override
  Widget build(BuildContext context) {
    return Material(
      //color: DefaultTheme.TRANSPARENT,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        // margin: const EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.only(left: 3, right: 3),
        // height: isActive ? 12 : 8,
        // width: isActive ? 12 : 8,
        width: 10, height: 10,
        decoration: isActive
            ? BoxDecoration(
                color: DefaultTheme.GREY_TOP_TAB_BAR,
                borderRadius: BorderRadius.circular(10))
            : BoxDecoration(
                border: Border.all(
                  color: DefaultTheme.GREY_TOP_TAB_BAR,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(10)),
        //  BoxDecoration(
        //   color: isActive ? Theme.of(context).primaryColor : Colors.grey,
        //   borderRadius: BorderRadius.all(Radius.circular(12)),
        // ),
      ),
    );
  }
}
