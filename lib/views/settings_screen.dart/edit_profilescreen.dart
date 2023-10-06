import 'dart:io';

import 'package:wedeaseseller/const/const.dart';
import 'package:wedeaseseller/controllers/setting_controller.dart';
import 'package:wedeaseseller/views/widgets/custom_textfield.dart';
import 'package:wedeaseseller/views/widgets/loading_indicator.dart';
import 'package:wedeaseseller/views/widgets/normal_text.dart';

class EditProfileScreen extends StatefulWidget {
  final String? username;

  const EditProfileScreen({
    Key? key,
    this.username,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var controller = Get.find<SettingController>();
  var profileController = Get.put(UserProfileController());

  @override
  void initState() {
    controller.nameController.text = widget.username!;
    clearPasswordFields();
    super.initState();
  }

  // Method to clear password fields
  void clearPasswordFields() {
    controller.oldpassController.clear();
    controller.newpassController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: purpleColor,
        appBar: AppBar(
          title: boldText(text: editProfile, size: 16.0),
          actions: [
            controller.isloading.value
                ? loadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);

                      // Image is not selected
                      if (controller.profileImgPath.value.isNotEmpty) {
                        await controller.uploadProfileImage();
                      } else {
                        controller.profileImageLink =
                            controller.snapshotData['imageUrl'];
                      }

                      // Check if both old password and new password are provided
                      if (controller.oldpassController.text.isNotEmpty &&
                          controller.newpassController.text.isNotEmpty) {
                        try {
                          // Change password in Firebase Authentication
                          User? user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            await user.updatePassword(
                                controller.newpassController.text);
                          }

                          // Update the password in your database
                          await controller.changeAuthPassword(
                            email: controller.snapshotData['email'],
                            password: controller.oldpassController.text,
                            newpassword: controller.newpassController.text,
                          );

                          // Update the profile with the new password and image link
                          await controller.updateProfile(
                            imgUrl: controller.profileImageLink,
                            name: controller.nameController.text,
                            password: controller.newpassController.text,
                          );

                          // Update the image link in UserProfileController
                          profileController
                              .updateProfileImage(controller.profileImageLink);

                          VxToast.show(context, msg: 'Updated Successfully');
                        } on FirebaseAuthException catch (error) {
                          print('Error changing password: $error');
                          String errorMessage =
                              'An error occurred while changing password';

                          // Check for specific error codes and provide custom error messages
                          switch (error.code) {
                            case 'requires-recent-login':
                              errorMessage =
                                  'Please re-login to change your password';
                              break;
                            case 'weak-password':
                              errorMessage = 'The new password is too weak';
                              break;
                            case 'user-mismatch':
                              errorMessage =
                                  'Authentication error, please re-login';
                              break;
                            case 'user-not-found':
                              errorMessage = 'User not found';
                              break;
                            case 'wrong-password':
                              errorMessage = 'Incorrect old password';
                              break;
                          }

                          VxToast.show(context, msg: errorMessage);
                        } catch (error) {
                          print('Error: $error');
                          VxToast.show(context,
                              msg: 'An error occurred while changing password');
                        }
                      } else {
                        // Handle the case where the user didn't provide both old and new passwords
                        // Here, you can display a message to inform the user that only the image was updated
                        await controller.updateProfile(
                          imgUrl: controller.profileImageLink,
                          name: controller.nameController.text,
                          password: controller.snapshotData['password'],
                        );

                        // Update the image link in UserProfileController
                        profileController
                            .updateProfileImage(controller.profileImageLink);

                        VxToast.show(context, msg: 'Profile image updated');
                      }

                      controller.isloading(false);
                    },
                    child: normalText(text: save, color: white))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Display profile image
                controller.snapshotData['imageUrl'] == '' &&
                        controller.profileImgPath.isEmpty
                    ? Image.asset(
                        imgProduct,
                        width: 100,
                        fit: BoxFit.cover,
                      ).box.roundedFull.clip(Clip.antiAlias).make()
                    : controller.snapshotData['imageUrl'] != '' &&
                            controller.profileImgPath.isEmpty
                        ? Image.network(controller.snapshotData['imageUrl'],
                                width: 100, fit: BoxFit.cover)
                            .box
                            .roundedFull
                            .clip(Clip.antiAlias)
                            .make()
                        : Image.file(
                            File(controller.profileImgPath.value),
                            width: 100,
                            fit: BoxFit.cover,
                          ).box.roundedFull.clip(Clip.antiAlias).make(),
                10.heightBox,
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: white),
                  onPressed: () {
                    controller.changeImage(context);
                  },
                  child: normalText(text: changeImage, color: fontGrey),
                ),
                10.heightBox,
                const Divider(color: white),
                customTextField(
                    label: name,
                    hint: "eg. Wedease devs",
                    controller: controller.nameController),
                30.heightBox,
                Align(
                    alignment: Alignment.centerLeft,
                    child: boldText(
                      text: "Change Password",
                    )),
                10.heightBox,
                customTextField(
                    obscureText: true,
                    label: password,
                    hint: passHint,
                    controller: controller.oldpassController),
                10.heightBox,
                customTextField(
                    obscureText: true,
                    label: confirmPass,
                    hint: passHint,
                    controller: controller.newpassController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
