import 'package:flutter/material.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/utils/constant.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int defaultSelectedIndex;
  final List<String> selectedItemIcon;
  final List<String> unselectedItemIcon;
  final List<String> label;
  final Function(int) onChange;

  const CustomBottomNavBar(
      {this.defaultSelectedIndex = 0,
      required this.selectedItemIcon,
      required this.unselectedItemIcon,
      required this.label,
      required this.onChange,
      Key? key})
      : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;
  List<String> _selectedItemIcon = [];
  List<String> _unselectedItemIcon = [];
  List<String> _label = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.defaultSelectedIndex;
    _selectedItemIcon = widget.selectedItemIcon;
    _unselectedItemIcon = widget.unselectedItemIcon;
    _label = widget.label;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> navBarItems = [];

    for (int i = 0; i < screens.length; i++) {
      navBarItems.add(Expanded(
        child: bottomNavBarItem(
            _selectedItemIcon[i], _unselectedItemIcon[i], _label[i], i),
      ));
    }
    return Container(
      decoration: BoxDecoration(
          color: BlackPrimary, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navBarItems,
      ),
    );
  }

  Widget bottomNavBarItem(activeIcon, inactiveIcon, label, index) {
    return GestureDetector(
      onTap: () {
        widget.onChange(index);
        setState(() {
          _selectedIndex = index;
        });
      },
      child: SizedBox(
        height: kBottomNavigationBarHeight,
        width: MediaQuery.of(context).size.width / _selectedItemIcon.length,
        child: _selectedIndex == index
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    activeIcon,
                    width: 22,
                    height: 22,
                    color: GreenPrimary,
                  ),
                  Text(
                    label,
                    style: bottomNavTextStyle,
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    inactiveIcon,
                    width: 22,
                    height: 22,
                    color: BlackTertiary,
                  ),
                ],
              ),
      ),
    );
  }
}
