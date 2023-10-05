import 'package:intl/intl.dart' as intl;
import 'package:wedeaseseller/controllers/inquiry_controller.dart';
import 'package:wedeaseseller/services/store_services.dart';
import 'package:wedeaseseller/views/inquiry_screen/inquiry_details.dart';
import 'package:wedeaseseller/views/widgets/appbar_widget.dart';
import 'package:wedeaseseller/views/widgets/loading_indicator.dart';
import 'package:wedeaseseller/views/widgets/normal_text.dart';

import '../../const/const.dart';

class InquiryScreen extends StatelessWidget {
  const InquiryScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(InquiryController());
    return Scaffold(
        appBar: appbarWidget(inquiry),
        body: StreamBuilder(
            stream: StoreServices.getInquiry(currentUser!.uid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return loadingIndicator();
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                // Handle the case where there is no data or the data list is empty.
                return const Text('No data available.');
              } else {
                var data = snapshot.data!.docs;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: List.generate(data.length, (index) {
                        var time = data[index]['inquiry_date'];

                        // set values.

                        controller.confirmbooked.value =
                            data[index]['inquiry_confirmed'];
                        controller.onPayment.value =
                            data[index]['inquiry_on_payment'];
                        controller.onDelivered.value =
                            data[index]['inquiry_on_delivered'];

                        return Container(
                          decoration: const BoxDecoration(
                              backgroundBlendMode: BlendMode.src,
                              gradient:
                                  LinearGradient(colors: [white, fontGrey]),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          margin: const EdgeInsets.only(bottom: 4),
                          child: ListTile(
                            onTap: () {
                              Get.to(() =>
                                  InquiryDetailsScreen(data: data[index]));
                            },
                            title: boldText(
                                text: "${data[index]['s_name'] ?? ""} ",
                                color: purpleColor),
                            subtitle: Column(
                              children: [
                                5.heightBox,
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.account_circle,
                                      color: black,
                                    ),
                                    10.widthBox,
                                    boldText(
                                        text:
                                            // intl.DateFormat().add_yMd().format(
                                            data[index]["inquiry_name"],
                                        // ),
                                        color: fontGrey),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month,
                                      color: black,
                                    ),
                                    10.widthBox,
                                    boldText(
                                        text:
                                            // intl.DateFormat().add_yMd().format(
                                            time,
                                        // ),
                                        color: fontGrey),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: fontGrey,
                                    ),
                                    10.widthBox,
                                    boldText(
                                      text: controller.confirmbooked.value
                                          ? "Confirmed"
                                          : "Not confirmed",
                                      color: red,
                                    )
                                  ],
                                )
                              ],
                            ),
                            trailing: boldText(
                                text: "${data[index]['inquiry_code']}",
                                color: white,
                                size: 16.0),
                          ),
                        );
                      }),
                    ),
                  ),
                );
              }
            }));
  }
}
