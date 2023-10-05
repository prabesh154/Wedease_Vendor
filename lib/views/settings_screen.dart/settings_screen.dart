import 'package:wedeaseseller/const/lists.dart';
import 'package:wedeaseseller/controllers/auth_controller.dart';
import 'package:wedeaseseller/controllers/setting_controller.dart';
import 'package:wedeaseseller/services/store_services.dart';
import 'package:wedeaseseller/views/auth_screen/login_screen.dart';
import 'package:wedeaseseller/views/messages-screen/messages_screen.dart';
import 'package:wedeaseseller/views/settings_screen.dart/edit_profilescreen.dart';
import 'package:wedeaseseller/views/vendor_screen/vendor_setting_screen.dart';
import 'package:wedeaseseller/views/widgets/loading_indicator.dart';
//import 'package:wedeaseseller/views/widgets/appbar_widget.dart';
import 'package:wedeaseseller/views/widgets/normal_text.dart';

import '../../const/const.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SettingController());
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 84, 153, 210),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: boldText(text: settings, size: 16.0),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => EditProfileScreen(
                      username: controller.snapshotData['vendor_name'],
                    ));
              },
              icon: const Icon(Icons.edit)),
          TextButton(
              onPressed: () async {
                await Get.find<AuthController>().signoutMethod(context);
                Get.offAll(() => const LoginScreen());
              },
              child: normalText(text: logout))
        ],
      ),
      body: FutureBuilder(
          future: StoreServices.getProfile(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //print(snapshot.data?.docs); // Log the retrieved documents
            if (!snapshot.hasData) {
              return loadingIndicator(circleColor: white);
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              // Handle the case where there is no data or the data list is empty.
              return Text('No data available.');
            } else {
              controller.snapshotData = snapshot.data!.docs[0];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      // leading: Image.asset(imgProduct)
                      //     .box
                      //     .roundedFull
                      //     .clip(Clip.antiAlias)
                      //     .make(),

                      leading: controller.snapshotData['imageUrl'] == ''
                          ? Image.asset(
                              imgProduct,
                              width: 100,
                              // fit: BoxFit.cover
                            ).box.roundedFull.clip(Clip.antiAlias).make()
                          : Image.network(controller.snapshotData['imageUrl'],
                                  width: 100, fit: BoxFit.cover)
                              .box
                              .roundedFull
                              .clip(Clip.antiAlias)
                              .make(),
                      title: boldText(
                          text: "${controller.snapshotData['vendor_name']}"),
                      subtitle: normalText(
                          text: "${controller.snapshotData['email']}"),
                    ),
                    const Divider(color: black),
                    10.heightBox,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: List.generate(
                          profileButtonsIcons.length,
                          (index) => ListTile(
                            onTap: () {
                              switch (index) {
                                case 0:
                                  Get.to(() => const VendorSettings());
                                  break;

                                case 1:
                                  Get.to(() => const MessagesScreen());
                                  break;
                                default:
                              }
                            },
                            leading:
                                Icon(profileButtonsIcons[index], color: white),
                            title:
                                normalText(text: profileButtonsTitles[index]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
