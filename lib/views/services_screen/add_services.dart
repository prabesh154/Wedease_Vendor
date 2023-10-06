import 'package:wedeaseseller/const/const.dart';
import 'package:wedeaseseller/controllers/services_controllers.dart';
import 'package:wedeaseseller/views/services_screen/components/service_category_dropdown.dart';
import 'package:wedeaseseller/views/services_screen/components/service_images.dart';
import 'package:wedeaseseller/views/widgets/custom_textfield.dart';
import 'package:wedeaseseller/views/widgets/loading_indicator.dart';
import 'package:wedeaseseller/views/widgets/normal_text.dart';

class AddServices extends StatelessWidget {
  const AddServices({super.key});

  bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  bool isNumeric(String? value) {
    if (value == null) return false;
    return double.tryParse(value.trim()) != null;
  }

  // Validation function to check if the text fields are not empty
  bool isFormValid(ServicesController controller) {
    return controller.snameController.text.isNotEmpty &&
        controller.slocationController.text.isNotEmpty &&
        controller.sfeaturesController.text.isNotEmpty &&
        controller.spriceController.text.isNotEmpty &&
        controller.sdescriptionController.text.isNotEmpty &&
        controller.categoryvalue.value.isNotEmpty &&
        controller.subcategoryvalue.value.isNotEmpty &&
        controller.sImagesList.every((image) => image != null);
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ServicesController>();
    controller.categoryvalue.value = ''; // Set Category to empty
    controller.subcategoryvalue.value = '';
    controller.snameController.clear();
    controller.slocationController.clear();
    controller.sfeaturesController.clear();
    controller.spriceController.clear();
    controller.sdescriptionController.clear();

    controller.categoryvalue.value = '';
    controller.subcategoryvalue.value = '';

    controller.clearSelectedImages();
    Map<TextEditingController, String> errorMessages = {};

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text(
            "Add Services",
            style: TextStyle(fontSize: 16.0, color: Colors.black),
          ),
          actions: [
            controller.isloading()
                ? loadingIndicator(
                    circleColor: const Color.fromARGB(255, 17, 119, 215))
                : TextButton(
                    onPressed: () async {
                      var controller = Get.find<ServicesController>();

                      // Check if the form is valid before saving
                      if (!isNotEmpty(controller.snameController.text)) {
                        errorMessages[controller.snameController] =
                            "Service name cant be empty";
                      } else {
                        errorMessages.remove(controller.snameController);
                      }

                      if (!isNotEmpty(controller.slocationController.text)) {
                        errorMessages[controller.slocationController] =
                            "Location cant be empty";
                      } else {
                        errorMessages.remove(controller.slocationController);
                      }

                      if (!isNotEmpty(controller.sfeaturesController.text)) {
                        errorMessages[controller.sfeaturesController] =
                            "Features cant be empty";
                      } else {
                        errorMessages.remove(controller.sfeaturesController);
                      }

                      if (!isNumeric(controller.spriceController.text)) {
                        errorMessages[controller.spriceController] =
                            "Invalid Price Format";
                      } else {
                        errorMessages.remove(controller.spriceController);
                      }

                      if (!isNotEmpty(controller.sdescriptionController.text)) {
                        errorMessages[controller.sdescriptionController] =
                            "Description cant be empty";
                      } else {
                        errorMessages.remove(controller.sdescriptionController);
                      }

                      // Check if there are any error messages
                      if (errorMessages.isEmpty) {
                        controller.isloading(true);
                        if (isFormValid(controller)) {
                          controller.isloading(true);

                          await controller.uploadImages();
                          await controller.uploadServices(
                              controller.snameController.text,
                              controller.spriceController.text,
                              controller.slocationController.text,
                              controller.sfeaturesController.text,
                              controller.sdescriptionController.text,
                              controller.categoryvalue.value,
                              controller.subcategoryvalue.value,
                              FieldValue.arrayUnion(controller.sImagesLinks),
                              context);

                          // Clear the text fields after saving
                          controller.snameController.clear();
                          controller.slocationController.clear();
                          controller.sfeaturesController.clear();
                          controller.spriceController.clear();
                          controller.sdescriptionController.clear();

                          controller.categoryvalue.value = '';
                          controller.subcategoryvalue.value = '';

                          controller.clearSelectedImages();
                          controller.isloading(false);

                          Get.back();
                          VxToast.show(context, msg: "Updated Successfully");
                        } else {
                          Get.snackbar(
                            "Error",
                            "Please fill in all fields and select images.",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      } else {
                        Get.snackbar(
                          "Error",
                          "Please fill all fields & give correct format",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    child: boldText(text: "Save", color: Colors.purple),
                  ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                customTextField(
                  hint: 'eg: ABC Party Palace',
                  label: 'Service Name',
                  controller: controller.snameController,
                ),
                Text(
                  errorMessages[controller.slocationController] ?? '',
                  style: TextStyle(color: Colors.red),
                ),
                10.heightBox,
                customTextField(
                  hint: 'eg: District or local bodies name',
                  label: 'Location',
                  controller: controller.slocationController,
                ),
                Text(
                  errorMessages[controller.slocationController] ?? '',
                  style: TextStyle(color: Colors.red),
                ),
                10.heightBox,
                customTextField(
                  hint: 'eg: About facilities, inclusion, exclusion, etc.',
                  label: 'Features',
                  isDesc: true,
                  controller: controller.sfeaturesController,
                ),
                Text(
                  errorMessages[controller.sfeaturesController] ?? '',
                  style: TextStyle(color: Colors.red),
                ),
                10.heightBox,
                customTextField(
                  hint: 'e.g. Rs. 1000',
                  label: 'Rate/Price',
                  controller: controller.spriceController,
                ),
                Text(
                  errorMessages[controller.spriceController] ?? '',
                  style: TextStyle(color: Colors.red),
                ),
                10.heightBox,
                customTextField(
                  hint: 'eg: About You and Your Service',
                  label: 'Description',
                  isDesc: true,
                  controller: controller.sdescriptionController,
                ),
                Text(
                  errorMessages[controller.sdescriptionController] ?? '',
                  style: TextStyle(color: Colors.red),
                ),
                10.heightBox,
                serviceCategoryDropdown(
                  "Category",
                  controller.categoryList,
                  controller.categoryvalue,
                  controller,
                  true,
                ),
                10.heightBox,
                serviceCategoryDropdown(
                  "Subcategory",
                  controller.subcategoryList,
                  controller.subcategoryvalue,
                  controller,
                  true, // make dropdown to be selectable
                ),
                10.heightBox,
                const Divider(
                  color: Colors.black,
                ),
                boldText(text: "Choose Service Images"),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      controller.sImagesList.length,
                      (index) {
                        final image = controller.sImagesList[index];
                        return image != null
                            ? Image.file(
                                image, // Use the File object
                                width: 100,
                              ).onTap(() {
                                controller.pickImage(index, context);
                              })
                            : serviceImages(label: "${index + 1}").onTap(() {
                                controller.pickImage(index, context);
                              });
                      },
                    ),
                  ),
                ),
                10.heightBox,
                normalText(
                  text: "First Image will be display image",
                  color: Colors.black,
                ),
                const Divider(
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
