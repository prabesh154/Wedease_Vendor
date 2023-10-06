import 'package:wedeaseseller/const/const.dart';
import 'package:wedeaseseller/controllers/auth_controller.dart';
import 'package:wedeaseseller/views/home_screen/home.dart';
import 'package:wedeaseseller/views/widgets/normal_text.dart';
import 'package:wedeaseseller/views/widgets/our_button.dart';
import 'package:wedeaseseller/views/widgets/loading_indicator.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: purpleColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.heightBox,
              normalText(text: welcome, size: 18.0),
              10.heightBox,
              Row(
                children: [
                  boldText(
                      text: "WedEase Vendor App",
                      size: 20.0,
                      color: Colors.black),
                ],
              ),
              60.heightBox,
              const Center(
                child: Text(
                  'Login to Vendor account',
                  style: TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 20, color: white),
                ),
              ),
              40.heightBox,
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0), color: white),
                child: Obx(
                  () => Column(
                    children: [
                      10.heightBox,
                      TextFormField(
                        controller: controller.emailController,
                        decoration: const InputDecoration(
                          hintText: emailHint,
                          prefixIcon: Icon(
                            Icons.email,
                            color: purpleColor,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                      const Divider(
                        color: purpleColor,
                      ),
                      10.heightBox,
                      TextFormField(
                        obscureText: true,
                        controller: controller.passwordController,
                        decoration: const InputDecoration(
                          hintText: passHint,
                          prefixIcon: Icon(
                            Icons.lock,
                            color: purpleColor,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                      const Divider(
                        color: purpleColor,
                      ),
                      
                      30.heightBox,
                      SizedBox(
                        width: context.screenWidth - 100,
                        child: controller.isloading.value
                            ? loadingIndicator()
                            : ourButton(
                                title: login,
                                onPress: () async {
                                  controller.isloading(true);
                                  await controller
                                      .loginMethod(context: context)
                                      .then((value) {
                                    if (value != null) {
                                      VxToast.show(context, msg: "Logged in");
                                      controller.isloading(false);
                                      Get.offAll(() => const Home());
                                    } else {
                                      controller.isloading(false);
                                    }
                                  });
                                  print("Login button pressed");

                                  // Get.to(() => const Home());
                                }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
