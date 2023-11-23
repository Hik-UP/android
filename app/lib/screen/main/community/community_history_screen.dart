import 'package:flutter/material.dart';
import 'package:hikup/screen/main/community/order_screen.dart';
import 'package:hikup/screen/main/community/pages/Journals/home.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/utils/dummy_data.dart';

class CommunityHistoryScreen extends StatefulWidget {
  static String routeName = "/communityhistoryscreen";
  const CommunityHistoryScreen({super.key});

  @override
  State<CommunityHistoryScreen> createState() => _CommunityHistoryScreenState();
}

class _CommunityHistoryScreenState extends State<CommunityHistoryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BlackPrimary,
      appBar: AppBar(
        toolbarHeight: kTextTabBarHeight,
        title: Text(
          "Event",
          style: titleTextStyleWhite,
          //style: HOPASTYLE,
        ),
        backgroundColor: BlackSecondary,
        elevation: 0.0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: tabBarTextStyle,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(
              text: "Alone",
            ),
            Tab(
              text: "In group",
            ),
            //Tab(
            //text: "événement",
            //),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          OrderScreen(
            fieldOrderList: dummyUserOrderList,
          ),
          const ComePage(),
          //HistoryScreen(),
          //EventScreen(),
        ],
      ),
    );
  }
}
