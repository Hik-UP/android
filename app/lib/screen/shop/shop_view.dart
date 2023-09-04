import 'package:flutter/material.dart';
import 'package:hikup/widget/custom_app_bar.dart';

class ShopView extends StatelessWidget {
  const ShopView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(label: 'Boutique'),
      body: Column(
        children: [
          Text('Shop'),
        ],
      ),
    );
  }
}
