import 'dart:io';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:upgrader/upgrader.dart';

import '../../utils/strings.dart';
import '../../utils/values.dart';
import 'home_controller.dart';
import 'home_page.dart';

final margin = EdgeInsets.symmetric(horizontal: AppPadding.p20);

class HomeScreen extends GetView<HomeScreenController> {
  HomeScreen({
    Key? key,
  }) : super(key: key);

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

  final List<Widget> _pages = <Widget>[
    HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    // Upgrader.clearSavedSettings();
    // TODO change back to appcast
    final appCastURL = '${AppStrings.baseUrl}/appcast.xml';
    final cfg = AppcastConfiguration(url: appCastURL, supportedOS: ['android']);

    final scaffold = Scaffold(
      body: Obx(() {
        controller.selectedPage;
        return _pages.elementAt(0);
      }),
      bottomNavigationBar: Obx(() => AppBottomNavBar(
            selectedIndex: controller.selectedPage,
            onTabChange: (index) {
              // only scroll to top when home is selected twice.
              if (controller.selectedPage == 0) {
                // _homeController.animateTo(
                //   0.0,
                //   duration: const Duration(milliseconds: 500),
                //   curve: Curves.easeOut,
                // );
              }
              controller.selectedPage = index;
            },
          )),
    );

    return UpgradeAlert(
      upgrader: Upgrader(
        appcastConfig: cfg,
        shouldPopScope: () => false,
        debugDisplayAlways: false,
        dialogStyle: Platform.isAndroid
            ? UpgradeDialogStyle.material
            : UpgradeDialogStyle.cupertino,
        minAppVersion: '1.0.18',
      ),
      child: Platform.isIOS
          ? GestureDetector(
              onHorizontalDragUpdate: (details) {
                // Set the sensitivity for your ios gesture anywhere between 10-50 is good

                int sensitivity = 30;

                if (details.delta.dx > sensitivity) {
                  _onWillPop();
                }
              },
              child: scaffold,
            )
          : WillPopScope(
              // This dosen't work on IOS
              onWillPop: _onWillPop,
              child: scaffold,
            ),
    );
  }

  Future<bool> _onWillPop() {
    if (controller.selectedPage == 0) return Future.value(true);
    controller.selectedPage = 0;
    return Future.value(false);
  }
}

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    Key? key,
    required this.onTabChange,
    required this.selectedIndex,
  }) : super(key: key);

  final void Function(int) onTabChange;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      // default Shaddow doesn't show
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(.1),
          )
        ],
      ),
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onTabChange,
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          // NavigationDestination(
          //   icon: ImageIcon2.asset('assets/icons/profile.png'),
          //   label: 'Account',
          // ),
        ],
      ),
    );
  }
}
