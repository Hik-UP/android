import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/widget/header.dart';
import 'package:hikup/widget/trail_card.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/viewmodel/search_viewmodel.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:hikup/widget/category_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String trailsFilter = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return BaseView<SearchViewModel>(builder: (context, model, child) {
      if (model.trailsList.isEmpty) {
        model.trails(appState: appState);
      }
      TextEditingController controller = TextEditingController();
      /* controller.addListener(() {
        final String value = controller.text.toLowerCase();
        controller.value = controller.value.copyWith(
          text: value,
          selection: TextSelection(
              baseOffset: value.length, extentOffset: value.length),
          composing: TextRange.empty,
        );
      });*/

      return Scaffold(
        backgroundColor: BlackSecondary,
        appBar: const Header(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(8.0),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.92,
                  child: SearchBar(
                    controller: controller,
                    backgroundColor: MaterialStateProperty.all(BlackPrimary),
                    hintText: "Rechercher un sentier",
                    shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
                      (Set<MaterialState> states) {
                        return const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        );
                      },
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        //controller.text = value;
                        model.searchFilterTrails(filter: value);
                        print(value);
                      });
                      //controller.
                    },
                    hintStyle: MaterialStateProperty.all(
                        const TextStyle(color: Colors.grey)),
                    textStyle: MaterialStateProperty.all(
                        const TextStyle(color: Colors.grey)),
                    padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    leading: const Icon(Icons.search, color: Colors.grey),
                  )),
              const Gap(32.0),
              // RECOMMENDED FIELDS
              model.filterTrailsList.isNotEmpty
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      primary: false,
                      itemCount: model.filterTrailsList.length,
                      itemBuilder: (context, index) => TrailCard(
                        field: model.filterTrailsList[index],
                      ),
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Gap(10.0),
                        Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ),
              const Gap(80.0),
            ],
          ),
        ),
      );
    });
  }
}
