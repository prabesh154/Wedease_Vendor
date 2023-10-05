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

//     List<dynamic> serviceImageUrls = data['s_imgs'];

// // Filter and cast the list to List<String> to get a list of image URLs
//     List<String> imageUrlList = serviceImageUrls.cast<String>().toList();

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
//                         await controller.uploadServices(context);

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
//               return SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       customTextField(
//                         hint: 'eg: ABC Party Palace',
//                         label: 'Service Name',
//                         // controller: controller.snameController.text =
//                         //     data['s_name']),
//                         initialValue:
//                             "${data['s_name']}", // Set the initial value here
//                       ),
//                       // initialValue: data['s_name'],
//                       // Set the initial value here

//                       10.heightBox,
//                       customTextField(
//                         // controller: "${data['s_name']}",
//                         initialValue:
//                             "${data['s_location']}", // Set the initial value here

//                         hint: 'eg: District or local bodies name',
//                         label: 'Location',
//                         // controller: controller.slocationController,
//                       ),
//                       10.heightBox,
//                       customTextField(
//                         hint:
//                             'eg: About facilities, inclusion, exclusion, etc.',
//                         label: 'Features',
//                         isDesc: true,
//                         initialValue: "${data['s_features']}",
//                         // controller: controller.sfeaturesController,
//                       ),
//                       10.heightBox,
//                       customTextField(
//                         hint: 'e.g. Rs. 1000',
//                         label: 'Rate/Price',
//                         initialValue: "${data['s_price']}",
//                         //  controller: controller.spriceController,
//                       ),
//                       10.heightBox,
//                       customTextField(
//                         hint: 'eg: About You and Your Service',
//                         label: 'Description',
//                         isDesc: true,
//                         // controller: controller.sdescriptionController,
//                         initialValue: "${data['s_description']}",
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
