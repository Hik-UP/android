import 'package:flutter/widgets.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/viewmodel/base_model.dart';
import 'package:provider/provider.dart';

class BaseView<T extends BaseModel> extends StatelessWidget {
  final Widget Function(BuildContext context, T value, Widget? child)? builder;

  const BaseView({this.builder, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) => locator<T>(),
      child: Consumer<T>(builder: builder!),
    );
  }
}
