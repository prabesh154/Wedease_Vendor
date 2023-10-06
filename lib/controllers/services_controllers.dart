import 'dart:io';
import 'package:path/path.dart';
import 'package:wedeaseseller/const/const.dart';
import 'package:wedeaseseller/controllers/home_controller.dart';
import 'package:wedeaseseller/models/category_model.dart';

class ServicesController extends GetxController {
  var isloading = false.obs;
  late QueryDocumentSnapshot snapshotData;

//text field controller

  var snameController = TextEditingController();

  var slocationController = TextEditingController();

  var sfeaturesController = TextEditingController();

  var spriceController = TextEditingController();
  var sdescriptionController = TextEditingController();

  var categoryList = <String>[].obs;
  var subcategoryList = <String>[].obs;

  List<Category> category = [];

  var sImagesList = RxList<dynamic>.generate(3, (index) => null);
  var sImagesLinks = [];
  var categoryvalue = ''.obs;
  var subcategoryvalue = ''.obs;
  var selectedColorIndex = ''.obs;

  getCategories() async {
    categoryList.clear();
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var cat = categoryModelFromJson(data);

    category = cat.categories;
  }

  populateCategoryList() {
    categoryList.clear();
    for (var item in category) {
      categoryList.add(item.name);
    }
  }

  populateSubcategory(cat) {
    subcategoryList.clear();

    var data = category.where((element) => element.name == cat).toList();

    for (var i = 0; i < data.first.subcategory.length; i++) {
      subcategoryList.add(data.first.subcategory[i]);
    }
  }

  // pickImage(index, context) async {
  //   try {
  //     final img = await ImagePicker()
  //         .pickImage(source: ImageSource.gallery, imageQuality: 100);
  //     if (img == null) {
  //       return "No Image";
  //     } else {
  //       sImagesList[index] = File(img.path);
  //     }
  //   } catch (e) {
  //     VxToast.show(context, msg: e.toString());
  //   }
  // }

  Future<File?> pickImage(int index, BuildContext context) async {
    try {
      final img = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      if (img == null) {
        return null; // Return null when no image is selected
      } else {
        sImagesList[index] = File(img.path);
        return sImagesList[index]; // Return the selected File
      }
    } catch (e) {
      VxToast.show(context, msg: e.toString());
      return null; // Return null in case of an error
    }
  }

  Future<void> uploadImages() async {
    sImagesLinks.clear();
    for (var item in sImagesList) {
      if (item is File) {
        // Make sure to check if it's a File before processing
        var filename = basename(item.path);
        var destination = 'images/seller_vendors/${currentUser!.uid}/$filename';
        Reference ref = FirebaseStorage.instance.ref().child(destination);
        await ref.putFile(item);
        var n = await ref.getDownloadURL();
        sImagesLinks.add(n);
      }
    }
  }

  // uploadImages() async {
  //   sImagesLinks.clear();
  //   for (var item in sImagesList) {
  //     if (item != null) {
  //       var filename = basename(item.path);
  //       var destination = 'images/seller_vendors/${currentUser!.uid}/$filename';
  //       Reference ref = FirebaseStorage.instance.ref().child(destination);
  //       await ref.putFile(item);
  //       var n = await ref.getDownloadURL();
  //       sImagesLinks.add(n);
  //     }
  //   }
  // }

  uploadServices(sName, sPrice, sFeatures, sLocation, sDescription, sCategory,
      sImgs, sSubcategory, context) async {
    var store = firestore.collection(servicesCollection).doc();
    await store.set({
      'featured_id': '',
      'is_featured': false,
      's_category': categoryvalue.value,
      's_description': sdescriptionController.text,
      's_features': sfeaturesController.text,
      's_imgs': FieldValue.arrayUnion(sImagesLinks),
      's_location': slocationController.text,
      's_name': snameController.text,
      's_price': spriceController.text,
      's_rating': "5.0",
      's_subcategory': subcategoryvalue.value,
      's_wishlist': FieldValue.arrayUnion([]),
      'vendor_id': currentUser!.uid,
      's_seller': Get.find<HomeController>().username,
    });
    isloading(false);
    VxToast.show(context, msg: "Services uploaded");
  }

  // uploadAddServices(context) async {
  //   var store = firestore.collection(servicesCollection).doc();
  //   await store.set({
  //     'featured_id': '',
  //     'is_featured': false,
  //     's_category': categoryvalue.value,
  //     's_description': sdescriptionController.text,
  //     's_features': sfeaturesController.text,
  //     's_imgs': FieldValue.arrayUnion(sImagesLinks),
  //     's_location': slocationController.text,
  //     's_name': snameController.text,
  //     's_price': spriceController.text,
  //     's_rating': "5.0",
  //     's_subcategory': subcategoryvalue.value,
  //     's_wishlist': FieldValue.arrayUnion([]),
  //     'vendor_id': currentUser!.uid,
  //     's_seller': Get.find<HomeController>().username,
  //   });
  //   isloading(false);
  //   VxToast.show(context, msg: "Services uploaded");
  // }

  addFeatured(docId) async {
    await firestore.collection(servicesCollection).doc(docId).set({
      'featured_id': currentUser!.uid,
      'is_featured': true,
    }, SetOptions(merge: true));
  }

  removeFeatured(docId) async {
    await firestore.collection(servicesCollection).doc(docId).set({
      'featured_id': '',
      'is_featured': false,
    }, SetOptions(merge: true));
  }

  removeServices(docId) async {
    await firestore.collection(servicesCollection).doc(docId).delete();
  }

  void clearSelectedImages() {
    for (int i = 0; i < sImagesList.length; i++) {
      sImagesList[i] = null;
    }
  }
}
