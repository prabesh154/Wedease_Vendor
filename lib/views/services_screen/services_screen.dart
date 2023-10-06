import 'dart:math';

import 'package:wedeaseseller/const/lists.dart';
import 'package:wedeaseseller/controllers/services_controllers.dart';
import 'package:wedeaseseller/services/store_services.dart';
import 'package:wedeaseseller/views/services_screen/add_services.dart';
import 'package:wedeaseseller/views/services_screen/edit_service.dart';
import 'package:wedeaseseller/views/services_screen/services_detail.dart';
import 'package:wedeaseseller/views/widgets/appbar_widget.dart';
import 'package:wedeaseseller/views/widgets/loading_indicator.dart';
import 'package:wedeaseseller/views/widgets/normal_text.dart';

import '../../const/const.dart';

// ...

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ServicesController());

    // Track whether the user has already featured a service
    bool userHasFeaturedService = false;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          controller.getCategories();
          controller.populateCategoryList();
          Get.to(() => AddServices());
        },
        backgroundColor: purpleColor,
        child: const Icon(Icons.add),
      ),
      appBar: appbarWidget(services),
      body: StreamBuilder<QuerySnapshot>(
        stream: StoreServices.getServices(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator(circleColor: purpleColor);
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text('No data available.');
          } else {
            var data = snapshot.data!.docs;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(
                    data.length,
                    (index) {
                      // Check if the current service is featured by the user
                      bool isFeaturedByUser =
                          data[index]['featured_id'] == currentUser!.uid;

                      // Update the userHasFeaturedService flag
                      if (isFeaturedByUser) {
                        userHasFeaturedService = true;
                      }

                      return ListTile(
                        onTap: () {
                          Get.to(() => ServiceDetails(
                                data: data[index],
                              ));
                        },
                        leading: Image.network(data[index]['s_imgs'][0],
                            width: 100, fit: BoxFit.cover),
                        title: boldText(
                            text: "${data[index]['s_name']}", color: fontGrey),
                        subtitle: Row(
                          children: [
                            normalText(
                                text: "${data[index]['s_price']}",
                                color: fontGrey),
                            10.widthBox,
                            boldText(
                                text: isFeaturedByUser ? "Featured" : '',
                                color: green),
                          ],
                        ),
                        trailing: VxPopupMenu(
                          arrowSize: 0.0,
                          menuBuilder: () => Column(
                            children: List.generate(
                              popupMenuTitles.length,
                              (i) => Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      size: 40.0,
                                      popupMenuIcons[i],
                                      color: isFeaturedByUser && i == 0
                                          ? green
                                          : darkGrey,
                                    ),
                                    10.widthBox,
                                    normalText(
                                        text: isFeaturedByUser && i == 0
                                            ? "Remove Featured"
                                            : popupMenuTitles[i],
                                        color: darkGrey)
                                  ],
                                ).onTap(() async {
                                  switch (i) {
                                    case 0:
                                      if (isFeaturedByUser) {
                                        // User wants to remove the feature
                                        await controller
                                            .removeFeatured(data[index].id);
                                        // Reset the flag when a feature is removed
                                        userHasFeaturedService = false;
                                        VxToast.show(context, msg: "Removed");
                                      } else {
                                        if (!userHasFeaturedService) {
                                          // User can feature the service
                                          await controller
                                              .addFeatured(data[index].id);
                                          // Set the flag when a feature is added
                                          userHasFeaturedService = true;
                                          VxToast.show(context,
                                              msg: "Service Added");
                                        } else {
                                          // User has already featured a service
                                          VxToast.show(context,
                                              msg:
                                                  "Only one service can be featured");
                                        }
                                      }
                                      break;
                                    case 1:
                                      if (i == 1) {
                                        Get.to(() => EditService(
                                            data: data[
                                                index])); // Pass the service data to the EditServiceScreen
                                      }
                                      break;

                                    case 2:
                                      await controller
                                          .removeServices(data[index].id);
                                      VxToast.show(context,
                                          msg: "Service Removed");
                                      break;
                                    default:
                                  }
                                }),
                              ),
                            ),
                          ).box.white.rounded.width(200).make(),
                          clickType: VxClickType.singleClick,
                          child: const Icon(
                            Icons.more_vert_rounded,
                            size: 35.0,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
