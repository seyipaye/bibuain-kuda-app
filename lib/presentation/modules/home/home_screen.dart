import 'dart:io';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:swift_pay_mobile/domain/app_shared_prefs.dart';
import 'package:swift_pay_mobile/presentation/utils/constants.dart';
import 'package:upgrader/upgrader.dart';

import '../../../core/app_routes.dart';
import '../../utils/strings.dart';
import '../../utils/values.dart';
import '../../widgets/pages/empty_page.dart';
import '../payment/pay/payment_screen.dart';
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
    PayPage(),
    EmptyPage(title: 'Empty'),
    EmptyPage(title: 'Empty'),
    EmptyPage(title: 'Empty'),
  ];

  void logout() {
    AppSharedPrefs.instance.clear();
    Get.offAllNamed(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      body: Obx(() => _pages.elementAt(controller.selectedPage)),
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

    return scaffold;
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
            icon: Icon(Icons.send),
            label: 'Pay',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Invest',
          ),
          NavigationDestination(
            icon: Icon(Icons.credit_card_rounded),
            label: 'Cards',
          ),
          NavigationDestination(
            icon: Icon(Icons.apps_rounded),
            label: 'More',
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
