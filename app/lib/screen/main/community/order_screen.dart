import 'package:flutter/material.dart';
import 'package:hikup/model/field_order.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/widget/no_community_message.dart';

class OrderScreen extends StatelessWidget {
  final List<FieldOrder> fieldOrderList;

  const OrderScreen({required this.fieldOrderList, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BlackPrimary,
      body: fieldOrderList.isEmpty
          ? const Center(
              child: SingleChildScrollView(
                child: NoCommunityMessage(
                  messageTitle: "",
                  messageDesc: "",
                ),
              ),
            )
          : ListView.builder(
              itemCount: fieldOrderList.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {},
                  splashColor: HOPA,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                fieldOrderList[index].field.imageAsset,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fieldOrderList[index].field.name,
                              style: HOPASTYLE,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              fieldOrderList[index].selectedDate,
                              style: HOPASTYLE,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: HOPA),
                          ),
                          child: Text(
                            "Annuler",
                            style: HOPASTYLE.copyWith(
                              fontWeight: FontWeight.w500,
                              color: HOPA,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
