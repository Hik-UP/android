import "package:flutter/material.dart";
import "package:hikup/viewmodel/example_viewmodel.dart";
import "package:hikup/widget/base_view.dart";

class Example extends StatelessWidget {
  const Example({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<ExampleViewModel>(
      builder: (context, model, child) => const Text(
        "Je suis un example",
      ),
    );
  }
}
