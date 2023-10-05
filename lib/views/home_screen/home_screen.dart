import 'package:wedeaseseller/controllers/inquiry_controller.dart';
import 'package:wedeaseseller/services/store_services.dart';
import 'package:wedeaseseller/views/home_screen/slider_image.dart';
import 'package:wedeaseseller/views/services_screen/services_detail.dart';
import 'package:wedeaseseller/views/widgets/appbar_widget.dart';
import 'package:wedeaseseller/views/widgets/dashboard_button.dart';
import 'package:wedeaseseller/views/widgets/loading_indicator.dart';
import 'package:wedeaseseller/views/widgets/normal_text.dart';

import '../../const/const.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var inquiryController = Get.put(InquiryController());

    inquiryController.getInquiryAnalytics(currentUser!.uid);
    return Scaffold(
      appBar: appbarWidget(dashboard),
      body: StreamBuilder<QuerySnapshot>(
        stream: StoreServices.getServices(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator(circleColor: white);
          } else {
            var data = snapshot.data!.docs;
            data = data.sortedBy((a, b) =>
                a['s_wishlist'].length.compareTo(b['s_wishlist'].length));
            // if details have more information
            // data = data.sortedBy((a, b) =>
            //     b['s_wishlist'].length.compareTo(a['s_wishlist'].length));
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        children: [
                          dashboardButton(context,
                              title: dashboard,
                              count: "${data.length}" ?? '',
                              icon: icProducts),
                          10.widthBox,
                          dashboardButton(context,
                              title: inquiry,
                              count:
                                  "${inquiryController.inquiryAnalytics["total_inquires"]}" ??
                                      '',
                              icon: icOrders),
                          10.widthBox,
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: dashboardButton(context,
                                title: " Payments",
                                count:
                                    "${inquiryController.inquiryAnalytics["total_payment"]}" ??
                                        '',
                                icon: icOrders),
                          ),
                          10.widthBox,
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: dashboardButton(context,
                                title: "Delievered",
                                count:
                                    "${inquiryController.inquiryAnalytics["total_delivered"]}" ??
                                        '',
                                icon: icOrders),
                          ),
                        ],
                      ),
                    ),
                  ),
                  20.heightBox,

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     dashboardButton(context,
                  //         title: rating, count: '34', icon: icStar),
                  //     dashboardButton(context,
                  //         title: potentialSales, count: '94', icon: icOrders),
                  //   ],
                  // ),
                  10.heightBox,
                  const Divider(
                    thickness: 2,
                  ),
                  10.heightBox,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: boldText(
                        text: 'Featured Service', color: darkGrey, size: 18.0),
                  ),
                  20.heightBox,
                  Expanded(
                    // Wrap the ListView with Expanded
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: List.generate(
                          data.length,
                          (index) => data[index]['is_featured']

                              //const SizedBox()
                              ? ListTile(
                                  onTap: () {
                                    Get.to(() =>
                                        ServiceDetails(data: data[index]));
                                  },
                                  leading: Image.network(
                                      data[index]['s_imgs'][0],
                                      width: 100,
                                      fit: BoxFit.cover),
                                  title: boldText(
                                      text: "${data[index]['s_name']}",
                                      color: fontGrey),
                                  subtitle: normalText(
                                      text: "${data[index]['s_price']}",
                                      color: darkGrey),
                                )
                              : const SizedBox()),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
