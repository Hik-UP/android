import 'package:flutter/material.dart';
import 'package:hikup/screen/main/community/order_screen.dart';
import 'package:hikup/screen/main/community/pages/Journals/home.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/utils/dummy_data.dart';

class CommunityHistoryScreen extends StatefulWidget {
  const CommunityHistoryScreen({Key? key}) : super(key: key);

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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        toolbarHeight: kTextTabBarHeight,
        title: Text(
          "Communauté",
          style: titleTextStyle,
        ),
        backgroundColor: backgroundColor,
        elevation: 0.0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: tabBarTextStyle,
          labelColor: primaryColor500,
          unselectedLabelColor: darkBlue300,
          indicatorColor: primaryColor500,
          tabs: const [
            Tab(
              text: "ma randonnée",
            ),
            Tab(
              text: "en groupe",
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
