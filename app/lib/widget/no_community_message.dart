import 'package:flutter/material.dart';

import '../theme.dart';

class NoCommunityMessage extends StatelessWidget {
  final String messageTitle;
  final String messageDesc;

  const NoCommunityMessage({
    required this.messageTitle,
    required this.messageDesc,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 16,
            ),
            //Image.asset(
            //"assets/images/no_transaction_illustration.png",
            //width: 150,
            //),
            const SizedBox(
              height: 8,
            ),
            Text(
              messageTitle,
              style: HOPASTYLE.copyWith(color: HOPA),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              messageDesc,
              style: HOPASTYLE,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 32.0,
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.search),
              label: Text(
                "",
                style: buttonTextStyle.copyWith(color: HOPA),
              ),
            )
          ],
        ),
      ),
    );
  }
}
