import "package:flutter/material.dart";
import "package:hikup/utils/constant.dart";

class ScaffoldWithCustomBg extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  const ScaffoldWithCustomBg({super.key, required this.child, this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  bgInventoryScreen,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: child,
          ),
        ));
  }
}
