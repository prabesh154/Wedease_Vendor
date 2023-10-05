import 'dart:io';

import 'package:wedeaseseller/const/const.dart';
import 'package:path/path.dart';

class SettingController extends GetxController {
  late QueryDocumentSnapshot snapshotData;
  // Map<String, dynamic> snapshotData = {};
  var profileImgPath = ''.obs;

  var profileImageLink = '';
  var isloading = false.obs;

  //textfield
  var nameController = TextEditingController();
  var oldpassController = TextEditingController();
  var newpassController = TextEditingController();

  //vendor setting controller
  var vendorNameController = TextEditingController();
  var vendorAddressController = TextEditingController();
  var vendorMobileController = TextEditingController();
  var vendorDescController = TextEditingController();

  changeImage(context) async {
    try {
      final img = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (img == null) return;

      // Check the file size of the selected image
      File selectedImage = File(img.path);
      int fileSizeInBytes = await selectedImage.length();
      int fileSizeInMB =
          fileSizeInBytes ~/ (1024 * 1024); // Convert bytes to MB

      // Set the maximum allowed file size in MB
      int maxAllowedFileSizeInMB = 4;

      if (fileSizeInMB > maxAllowedFileSizeInMB) {
        VxToast.show(
          context,
          msg:
              'Please select an image with a maximum file size of $maxAllowedFileSizeInMB MB',
        );
        return;
      }

      profileImgPath.value = img.path;
    } on PlatformException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadProfileImage() async {
    var filename = basename(profileImgPath.value);
    var destination = 'images/${currentUser!.uid}/$filename';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImgPath.value));
    profileImageLink = await ref.getDownloadURL();
  }

  updateProfile(
      {required String? name,
      required String? password,
      required String? imgUrl}) async {
    var store = firestore.collection(vendorsCollection).doc(currentUser!.uid);
    await store.set({
      'vendor_name': name,
      'password': password,
      'imageUrl': imgUrl,
    }, SetOptions(merge: true));
    isloading(false);
  }

  changeAuthPassword({email, password, newpassword}) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);

    await currentUser!.reauthenticateWithCredential(cred).then((value) {
      currentUser!.updatePassword(newpassword);
    }).catchError((error) {
      print(error.toString());
    });
  }

  updateVendor(
      {vendorName, vendorAddress, vendorMobile, vendorDesc, context}) async {
    var store = firestore.collection(vendorsCollection).doc(currentUser!.uid);
    await store.set({
      'vendor_name': vendorNameController.text,
      'vendor_address': vendorAddressController.text,
      'vendor_mobile': vendorMobileController.text,
      'vendor_desc': vendorDescController.text,
    }, SetOptions(merge: true));

    isloading(false);
  }
}

class UserProfileController extends GetxController {
  final RxString profileImageUrl = ''.obs;

  void updateProfileImage(String imageUrl) {
    profileImageUrl.value = imageUrl;
  }
}
