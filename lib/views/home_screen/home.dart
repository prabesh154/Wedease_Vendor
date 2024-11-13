import 'package:get/get.dart';
import 'package:wedeaseseller/controllers/home_controller.dart';
import 'package:wedeaseseller/views/inquiry_screen/inquiry_screen.dart';
import 'package:wedeaseseller/views/home_screen/home_screen.dart';
import 'package:wedeaseseller/views/settings_screen.dart/settings_screen.dart';
import 'package:wedeaseseller/views/services_screen/services_screen.dart';

import '../../const/const.dart';

class Home extends StatelessWidget {
  const Home({Key? key}); 

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());
    var navScreens = [
      const HomeScreen(),
      const ServicesScreen(),
      const InquiryScreen(),
      const SettingsScreen()
    ];

    var bottomNavbar = [
      const BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: darkGrey,
          ),
          label: dashboard),
      BottomNavigationBarItem(
          icon: Image.asset(
            icProducts,
            color: darkGrey,
            width: 24,
          ),
          label: services),
      BottomNavigationBarItem(
          icon: Image.asset(
            icOrders,
            color: darkGrey,
            width: 24,
          ),
          label: inquiry),
      const BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
            color: darkGrey,
          ),
          label: settings),
    ];
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: boldText(text: dashboard, color: fontGrey, size: 18.0),
      // ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
            onTap: (index) {
              controller.navIndex.value = index;
            },
            type: BottomNavigationBarType.fixed,
            currentIndex: controller.navIndex.value,
            selectedItemColor: purpleColor,
            unselectedItemColor: darkGrey,
            items: bottomNavbar),
      ),
      body: Column(
        children: [
          Obx(
            () => Expanded(
                child: navScreens.elementAt(controller.navIndex.value)),
          ),
        ],
      ),
    );
  }
}
