import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/widget/achievement_card.dart";

class StateAchievementCard extends StatelessWidget {
  final String label;
  final String state;
  const StateAchievementCard({
    super.key,
    required this.label,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xff1E1E1E),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          const Gap(3.0),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
              ),
              shape: BoxShape.circle,
              color: state == 'IN_PROGRESS' ? inProgressColor : finishColor,
            ),
          ),
          const Gap(8.0),
          Text(
            label,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 15.0,
              color: state == 'IN_PROGRESS' ? inProgressColor : finishColor,
            ),
          ),
          const Gap(10.0),
        ],
      ),
    );
  }
}
