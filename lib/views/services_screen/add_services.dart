import 'package:wedeaseseller/const/const.dart';
import 'package:wedeaseseller/controllers/services_controllers.dart';
import 'package:wedeaseseller/views/services_screen/components/service_category_dropdown.dart';
import 'package:wedeaseseller/views/services_screen/components/service_images.dart';
import 'package:wedeaseseller/views/widgets/custom_textfield.dart';
import 'package:wedeaseseller/views/widgets/loading_indicator.dart';
import 'package:wedeaseseller/views/widgets/normal_text.dart';

class AddServices extends StatelessWidget {
  const AddServices({super.key});

  // Validation function to check if the text fields are not empty
  bool isFormValid(ServicesController controller) {
    print("sname: ${controller.snameController.text}");
    print("slocation: ${controller.slocationController.text}");
    print("sfeatures: ${controller.sfeaturesController.text}");
    print("sdescription: ${controller.sdescriptionController.text}");
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

    // Set Subcategory to empty
    //controller.sImagesList.value = '' ;

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
                      // Check if the form is valid before saving
                      if (isFormValid(controller)) {
                        controller.isloading(true);

                        await controller.uploadImages();
                        await controller.uploadServices(context);

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
                10.heightBox,
                customTextField(
                  hint: 'eg: District or local bodies name',
                  label: 'Location',
                  controller: controller.slocationController,
                ),
                10.heightBox,
                customTextField(
                  hint: 'eg: About facilities, inclusion, exclusion, etc.',
                  label: 'Features',
                  isDesc: true,
                  controller: controller.sfeaturesController,
                ),
                10.heightBox,
                customTextField(
                  hint: 'e.g. Rs. 1000',
                  label: 'Rate/Price',
                  controller: controller.spriceController,
                ),
                10.heightBox,
                customTextField(
                  hint: 'eg: About You and Your Service',
                  label: 'Description',
                  isDesc: true,
                  controller: controller.sdescriptionController,
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




// // code having controller like vendorsetting
// edit service.dart code  that have controller


// import 'dart:ffi';
// import 'dart:io';

// import 'package:wedeaseseller/const/const.dart';
// import 'package:wedeaseseller/controllers/services_controllers.dart';
// import 'package:wedeaseseller/services/store_services.dart';
// import 'package:wedeaseseller/views/services_screen/components/service_category_dropdown.dart';
// import 'package:wedeaseseller/views/services_screen/components/service_images.dart';
// import 'package:wedeaseseller/views/widgets/custom_textfield.dart';
// import 'package:wedeaseseller/views/widgets/loading_indicator.dart';
// import 'package:wedeaseseller/views/widgets/normal_text.dart';
// import 'package:image_picker/image_picker.dart';

// class EditService extends StatelessWidget {
//   final data;
//   const EditService({Key? key, this.data}) : super(key: key);

//   // Validation function to check if the text fields are not empty
//   bool isFormValid(ServicesController controller) {
//     print("sname: ${controller.snameController.text}");
//     print("slocation: ${controller.slocationController.text}");
//     print("sfeatures: ${controller.sfeaturesController.text}");
//     print("sdescription: ${controller.sdescriptionController.text}");

//     return controller.snameController.text.isNotEmpty &&
//         controller.slocationController.text.isNotEmpty &&
//         controller.sfeaturesController.text.isNotEmpty &&
//         controller.spriceController.text.isNotEmpty &&
//         controller.sdescriptionController.text.isNotEmpty &&
//         controller.categoryvalue.value.isNotEmpty &&
//         controller.subcategoryvalue.value.isNotEmpty &&
//         controller.sImagesList.every((image) => image != null);
//   }

//   @override
//   Widget build(BuildContext context) {
//     var controller = Get.find<ServicesController>();
//     // List<String> serviceImageURLs = List<String>.from(data['s_imgs']);
//     // print("$serviceImageURLs");
//     TextEditingController snameController =
//         TextEditingController(text: data['s_name']);
//     TextEditingController slocationController =
//         TextEditingController(text: data['s_location']);
//     TextEditingController spriceController =
//         TextEditingController(text: data['s_price']);
//     TextEditingController sfeaturesController =
//         TextEditingController(text: data['s_features']);
//     TextEditingController sdescriptionController =
//         TextEditingController(text: data['s_description']);

//     List<dynamic> serviceImageUrls = data['s_imgs'];

// // Filter and cast the list to List<String> to get a list of image URLs
//     List<String> imageUrlList = serviceImageUrls.cast<String>().toList();
//     List<String> sImagesLinks =
//         []; // Initialize an empty list or assign it the appropriate value

// // Update your sImagesList with the retrieved image URLs
//     controller.sImagesList.assignAll(imageUrlList);
//     // controller.categoryvalue.value = data['s_category'];
//     //controller.subcategoryvalue.value = data['s_subcategory'];

//     controller.categoryvalue.value = ''; // Set Category to empty
//     controller.subcategoryvalue.value = ''; // Set Subcategory to empty

//     return Obx(
//       () => Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: const Icon(
//               Icons.arrow_back,
//               color: Colors.black,
//             ),
//             onPressed: () {
//               Get.back();
//             },
//           ),
//           title: const Text(
//             "Edit Services",
//             style: TextStyle(fontSize: 16.0, color: Colors.black),
//           ),
//           actions: [
//             controller.isloading(false)
//                 ? loadingIndicator(circleColor: Colors.black)
//                 : TextButton(
//                     onPressed: () async {
//                       // Check if the form is valid before saving
//                       if (isFormValid(controller)) {
//                         await controller.uploadImages();
//                         await controller.uploadServices(
//                           sName: controller.snameController.text,
//                           sPrice: controller.spriceController.text,
//                           sLocation: controller.slocationController.text,
//                           sFeatures: controller.sfeaturesController.text,
//                           sDescription: controller.sdescriptionController.text,
//                           sCategory: controller.categoryvalue.value,
//                           sSubcategory: controller.subcategoryvalue.value,
//                           sImgs: FieldValue.arrayUnion(sImagesLinks),
//                         );

//                         Get.back();
//                         VxToast.show(context, msg: "Updated Successfully");
//                       } else {
//                         // Show an error message or handle validation error
//                         // For example, you can show a SnackBar with an error message.
//                         Get.snackbar(
//                           "Error",
//                           "Please fill in all fields and select images.",
//                           snackPosition: SnackPosition.BOTTOM,
//                         );
//                       }
//                     },
//                     child: boldText(text: "Save", color: Colors.purple),
//                   ),
//           ],
//         ),
//         body: StreamBuilder<QuerySnapshot>(
//           stream: StoreServices.getServices(currentUser!.uid),
//           builder:
//               (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (!snapshot.hasData) {
//               return loadingIndicator(circleColor: purpleColor);
//             } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//               return const Text('No data available.');
//             } else {
//               controller.snapshotData = snapshot.data!.docs[0];
//               controller.snameController.text =
//                   controller.snapshotData['s_name'] ?? '';
//               controller.spriceController.text =
//                   controller.snapshotData['s_price'] ?? '';
//               controller.slocationController.text =
//                   controller.snapshotData['s_location'] ?? '';
//               controller.sfeaturesController.text =
//                   controller.snapshotData['s_features'] ?? '';
//               controller.sdescriptionController.text =
//                   controller.snapshotData['s_description'] ?? '';
//               controller.categoryvalue.value =
//                   controller.snapshotData['s_category'] ?? '';
//               controller.subcategoryvalue.value =
//                   controller.snapshotData['s_subcategory'] ?? '';

//               return SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       customTextField(
//                         hint: controller.snapshotData['s_name'],
//                         label: 'Service Name',
//                         controller: snameController,
//                       ),
//                       // initialValue: data['s_name'],
//                       // Set the initial value here

//                       10.heightBox,
//                       customTextField(
//                         controller: slocationController,

//                         hint: controller.snapshotData['s_location'],
//                         label: 'Location',
//                         // controller: controller.slocationController,
//                       ),
//                       10.heightBox,
//                       customTextField(
//                         hint: controller.snapshotData['s_features'],
//                         label: 'Features',
//                         controller: sfeaturesController,

//                         isDesc: true,
//                         //initialValue: "${data['s_features']}",
//                         // controller: controller.sfeaturesController,
//                       ),
//                       10.heightBox,
//                       customTextField(
//                         hint: controller.snapshotData['s_price'],
//                         label: 'Rate/Price',
//                         controller: spriceController,

//                         //  initialValue: "${data['s_price']}",
//                         //  controller: controller.spriceController,
//                       ),
//                       10.heightBox,
//                       customTextField(
//                         hint: controller.snapshotData['s_description'],
//                         label: 'Description',
//                         isDesc: true,
//                         controller: sdescriptionController,

//                         // controller: controller.sdescriptionController,
//                         //  initialValue: "${data['s_description']}",
//                       ),
//                       10.heightBox,
//                       serviceCategoryDropdown(
//                         "Category",
//                         controller.categoryList,
//                         controller.categoryvalue,
//                         controller,
//                         true,
//                       ),
//                       10.heightBox,
//                       serviceCategoryDropdown(
//                         "Subcategory",
//                         controller.subcategoryList,
//                         controller.subcategoryvalue,
//                         controller,
//                         true,
//                       ),
//                       10.heightBox,
//                       const Divider(
//                         color: Colors.black,
//                       ),
//                       boldText(text: "Choose Service Images"),
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Obx(
//                           () => Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: List.generate(
//                               controller.sImagesList
//                                   .length, // Use the length of sImagesList
//                               (index) {
//                                 final imageUrl = controller.sImagesList[index];
//                                 if (imageUrl != null) {
//                                   if (imageUrl.startsWith('http') ||
//                                       imageUrl.startsWith('https')) {
//                                     // Display images with valid URLs using Image.network
//                                     return Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: GestureDetector(
//                                         onTap: () async {
//                                           // Use image_picker to select a new image from the gallery
//                                           final newImageFile =
//                                               await ImagePicker().getImage(
//                                             source: ImageSource.gallery,
//                                           );
//                                           if (newImageFile != null) {
//                                             // Handle the new image file, e.g., update the URL or list
//                                             controller.sImagesList[index] =
//                                                 newImageFile.path;
//                                             print(
//                                                 "Updated image path: ${newImageFile.path}");
//                                           }
//                                         },
//                                         child: Image.network(
//                                           imageUrl,
//                                           width: 100,
//                                         ),
//                                       ),
//                                     );
//                                   } else {
//                                     // Display locally picked images using Image.file
//                                     return Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: GestureDetector(
//                                         onTap: () async {
//                                           // Use image_picker to select a new image from the gallery
//                                           final newImageFile =
//                                               await ImagePicker().getImage(
//                                             source: ImageSource.gallery,
//                                           );
//                                           if (newImageFile != null) {
//                                             // Handle the new image file, e.g., update the URL or list
//                                             controller.sImagesList[index] =
//                                                 newImageFile.path;
//                                             print(
//                                                 "Updated image path: ${newImageFile.path}");
//                                           }
//                                         },
//                                         child: Image.file(
//                                           File(imageUrl),
//                                           width: 100,
//                                         ),
//                                       ),
//                                     );
//                                   }
//                                 } else {
//                                   return Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: serviceImages(label: "${index + 1}")
//                                         .onTap(() {
//                                       controller.pickImage(index, context);
//                                     }),
//                                   );
//                                 }
//                               },
//                             ),
//                           ),
//                         ),
//                       ),

//                       // SingleChildScrollView(
//                       //   scrollDirection: Axis.horizontal,
//                       //   child: Row(
//                       //     children: serviceImageURLs.map((imageUrl) {
//                       //       return Container(
//                       //         margin: const EdgeInsets.all(
//                       //             8.0), // Add margin between images
//                       //         child: Image.network(imageUrl,
//                       //             width: 100,

//                       //             //  height: 100,
//                       //             fit: BoxFit.fill
//                       //             // You can adjust the fit as needed
//                       //             ),
//                       //       );
//                       //     }).toList(),
//                       //   ),
//                       // ),

//                       10.heightBox,
//                       normalText(
//                         text: "First Image will be display image",
//                         color: Colors.black,
//                       ),
//                       const Divider(
//                         color: Colors.black,
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
