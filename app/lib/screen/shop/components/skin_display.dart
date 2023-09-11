import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/screen/shop/components/skin_target.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/skin_display_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';

class SkinDisplay extends StatelessWidget {
  const SkinDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<SkinDisplayViewModel>(
      builder: (context, model, child) => SizedBox(
        child: InkWell(
          onTap: () => model.openDialog(),
          child: Card(
            color: const Color(0xff222222),
            elevation: 3,
            child: Column(
              children: [
                const Gap(3.0),
                const SkinTarget(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      coinIcon,
                      width: 16,
                      height: 16,
                      fit: BoxFit.fill,
                    ),
                    Text(
                      '10\$',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
