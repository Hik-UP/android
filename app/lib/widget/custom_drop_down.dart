import "package:flutter/material.dart";
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/widget/custom_text_field.dart';

class CustomDropDown extends StatelessWidget {
  final TextEditingController inputController;
  final String hintText;
  final List<String> content;
  final Function() onTap;
  final bool isVisible;
  final Function(String value) getSelectedGender;
  const CustomDropDown({
    super.key,
    this.hintText = "",
    required this.content,
    required this.onTap,
    required this.isVisible,
    required this.inputController,
    required this.getSelectedGender,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: inputController,
          hintText: hintText,
          readOnly: true,
          suffixIcon: InkWell(
            onTap: onTap,
            child: const Icon(
              Icons.arrow_drop_down,
            ),
          ),
        ),
        Visibility(
          visible: isVisible,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(2.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    8.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: content
                        .map(
                          (e) => InkWell(
                            onTap: () {
                              inputController.text = e;
                              getSelectedGender(e);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      e,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible:
                                      content.indexOf(e) != content.length - 1,
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Divider(),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
