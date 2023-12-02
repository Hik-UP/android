import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/screen/auth/login_page.dart';
import 'package:hikup/theme.dart';
import 'package:provider/provider.dart';
import 'package:onboarding/onboarding.dart';

class OnboardingScreen extends StatefulWidget {
  static String routeName = "/onBoarding";
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late int index;
  final onboardingPagesList = [
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            width: 0.0,
            color: Colors.black,
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 90.0,
                ),
                child: Image.asset('assets/images/map.png'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Explorez',
                    style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Utilisez notre carte interactive pour trouver un sentier près de chez vous',
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            width: 0.0,
            color: Colors.black,
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 90.0,
                ),
                child: Image.asset(
                  'assets/images/walkie-talkie.png',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Organisez',
                    style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Planifiez une date, invitez vos amis et laissez-vous guider pendant votre préparation',
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            width: 0.0,
            color: Colors.black,
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 90.0,
                ),
                child: Image.asset(
                  'assets/images/explorer.png',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Partez',
                    style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Découvrez les richesses de notre monde avec votre compagnon de voyage',
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    index = 0;
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return Scaffold(
      backgroundColor: BlackSecondary,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: BlackSecondary,
            statusBarIconBrightness: Brightness.dark),
      ),
      body: Onboarding(
        pages: onboardingPagesList,
        onPageChange: (int pageIndex) {
          index = pageIndex;
        },
        startPageIndex: 0,
        footerBuilder: (context, dragDistance, pagesLength, setIndex) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: background,
              border: Border.all(
                width: 0.0,
                color: background,
              ),
            ),
            child: ColoredBox(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(45.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIndicator(
                      netDragPercent: dragDistance,
                      pagesLength: pagesLength,
                      indicator: Indicator(
                        indicatorDesign: IndicatorDesign.line(
                          lineDesign: LineDesign(
                            lineType: DesignType.line_nonuniform,
                          ),
                        ),
                      ),
                    ),
                    index == pagesLength - 1
                        ? Material(
                            borderRadius: defaultProceedButtonBorderRadius,
                            color: Colors.white,
                            child: InkWell(
                              borderRadius: defaultProceedButtonBorderRadius,
                              onTap: () async {
                                appState.setIsFirstDownload(value: false);
                                Navigator.of(context)
                                    .pushNamed(LoginPage.routeName);
                              },
                              child: Padding(
                                padding: defaultProceedButtonPadding,
                                child: Text('Explorer',
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        letterSpacing: 1.0)),
                              ),
                            ),
                          )
                        : Material(
                            borderRadius: defaultSkipButtonBorderRadius,
                            color: defaultSkipButtonColor,
                            child: InkWell(
                              borderRadius: defaultSkipButtonBorderRadius,
                              onTap: () {
                                index = 2;
                                setIndex(2);
                              },
                              child: Padding(
                                padding: defaultSkipButtonPadding,
                                child: Text('Passer',
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        letterSpacing: 1.0)),
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
