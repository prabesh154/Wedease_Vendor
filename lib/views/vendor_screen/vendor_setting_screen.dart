import 'package:wedeaseseller/const/const.dart';
import 'package:wedeaseseller/services/store_services.dart';
import 'package:wedeaseseller/views/widgets/custom_textfield.dart';
import 'package:wedeaseseller/views/widgets/loading_indicator.dart';
import 'package:wedeaseseller/views/widgets/normal_text.dart';
import 'package:wedeaseseller/controllers/setting_controller.dart';

class VendorSettings extends StatelessWidget {
  const VendorSettings({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SettingController());

    return Obx(
      () => Scaffold(
        backgroundColor: purpleColor,
        appBar: AppBar(
          title: boldText(text: vendorSetting, size: 16.0),
          actions: [
            controller.isloading(false)
                ? loadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);
                      await controller.updateVendor(
                        vendorName: controller.vendorNameController.text,
                        vendorAddress: controller.vendorAddressController.text,
                        vendorMobile: controller.vendorMobileController.text,
                        vendorDesc: controller.vendorDescController.text,
                      );
                      VxToast.show(context, msg: "Updated Successfully");
                      // Don't set isloading to true here, keep it as false.
                    },
                    child: normalText(text: save, color: white),
                  ),
          ],
        ),
        body: FutureBuilder(
          future: StoreServices.getProfile(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return loadingIndicator();
            } else {
              controller.snapshotData = snapshot.data!.docs[0];

              // Initialize text controllers with existing data, if available
              controller.vendorNameController.text =
                  controller.snapshotData['vendor_name'] ?? '';
              controller.vendorAddressController.text =
                  controller.snapshotData['vendor_address'] ?? '';
              controller.vendorMobileController.text =
                  controller.snapshotData['vendor_mobile'] ?? '';
              controller.vendorDescController.text =
                  controller.snapshotData['vendor_desc'] ?? '';

              return SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: boldText(
                        text: 'Name',
                        size: 18.0,
                      ),
                    ),
                    8.heightBox,
                    customTextField(
                      hint: controller.snapshotData['vendor_name'],
                      controller: controller.vendorNameController,
                    ),
                    10.heightBox,
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: boldText(
                        text: 'Address',
                        size: 18.0,
                      ),
                    ),
                    8.heightBox,
                    customTextField(
                      hint: controller.snapshotData['vendor_address'],
                      controller: controller.vendorAddressController,
                    ),
                    10.heightBox,
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: boldText(
                        text: 'Mobile Number',
                        size: 18.0,
                      ),
                    ),
                    8.heightBox,
                    customTextField(
                      hint: controller.snapshotData['vendor_mobile'],
                      controller: controller.vendorMobileController,
                    ),
                    10.heightBox,
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: boldText(
                        text: 'Your Info and Description',
                        size: 18.0,
                      ),
                    ),
                    8.heightBox,
                    customTextField(
                      isDesc: true,
                      hint: controller.snapshotData['vendor_desc'],
                      controller: controller.vendorDescController,
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
