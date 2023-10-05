import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:wedeaseseller/controllers/inquiry_controller.dart';
import 'package:wedeaseseller/services/store_services.dart';
import 'package:wedeaseseller/utils.dart';
import 'package:wedeaseseller/views/services_screen/services_detail.dart';
import 'package:wedeaseseller/views/widgets/appbar_widget.dart';
import 'package:wedeaseseller/views/widgets/loading_indicator.dart';
import 'package:wedeaseseller/views/widgets/normal_text.dart';
import '../../const/const.dart';

class InquiryDetailsScreen extends StatefulWidget {
  final dynamic data;
  const InquiryDetailsScreen({this.data});

  @override
  State<InquiryDetailsScreen> createState() => _InquiryDetailsScreenState();
}

class _InquiryDetailsScreenState extends State<InquiryDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(InquiryController());

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text('Inquiry Details',
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: StoreServices.getServiceDetail(widget.data["s_name"]),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingIndicator();
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // Handle the case where there is no data or the data list is empty.
            return const Text('No data available.');
          } else {
            var data = snapshot.data!.docs[0];
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getRowData(
                        // data
                        [
                          "Inquirer Name : ",
                          "Email :",
                          "Phone number : ",
                          "Location : ",
                          "Message : ",
                        ],

                        //values

                        [
                          widget.data["inquiry_name"],
                          widget.data["inquiry_email"],
                          widget.data["inquiry_phone"],
                          widget.data["inquiry_location"],
                          widget.data["inquiry_message"]
                        ]

                        //
                        ),

                    // End of Inquiry info

                    // Start of Service info

                    ListTile(
                      onTap: () {
                        Get.to(() => ServiceDetails(
                              data: data,
                            ));
                      },
                      leading: Image.network(data['s_imgs'][0],
                          width: 100, fit: BoxFit.cover),
                      title:
                          boldText(text: "${data['s_name']}", color: fontGrey),
                      subtitle: Row(
                        children: [
                          normalText(
                              text: "${data['s_price']}", color: fontGrey),
                          10.widthBox,
                        ],
                      ),
                    ),

                    //
                    _confirmationWidget(controller, widget.data)
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  _confirmationWidget(controller, data) {
    //         // Your visibility widgets can be added here.
    //                         // if (!isConfirmed)
    return Column(children: [
      Visibility(
        visible: !controller.confirmbooked.value,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              controller.confirmbooked(true);
              controller.changeStatus(
                  title: "inquiry_confirmed",
                  status: true,
                  docID: data["inquiry_code"]);

              setState(() {});
            },
            child: const Text('Confirm Booking'),
          ),
        ),
      ),
      (controller.confirmbooked.value)
          ? Visibility(
              visible: controller.confirmbooked.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Service Status:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      normalText(
                          text: 'Payment Received:', size: 18.0, color: black),
                      //   Switch(
                      //     value: controller.onPayment.value,
                      //     onChanged: (value) {
                      //     controller.onPayment.value=value;
                      // controller.changeStatus(title:"inquiry_on_payment", status:value, docID:widget.widget..id);
                      //     },
                      //   ),
                      Switch(
                        value: controller.onPayment.value,
                        onChanged: (value) async {
                          controller.onPayment.value = value;
                          await controller.changeStatus(
                              title: "inquiry_on_payment",
                              status: value,
                              docID: data['inquiry_code']);
                          setState(() {});
                        },
                      )
                    ],
                  ),
                  Row(
                    children: [
                      normalText(
                          text: 'Service Delivered:', size: 18.0, color: black),
                      Switch(
                        value: controller.onDelivered.value,
                        onChanged: (value) {
                          controller.onDelivered.value = value;
                          controller.changeStatus(
                              title: "inquiry_on_delivered",
                              status: value,
                              docID: data['inquiry_code']);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          : const Text("")
    ]);
  }
}
