import 'package:wedeaseseller/const/const.dart';

class AuthController extends GetxController {
  var isloading = false.obs;
  //text controllers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  //login method
  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }

    return userCredential;
  }

  storeUserData(
      {required String vendor_name,
      required String password,
      required String email}) async {
    DocumentReference store =
        firestore.collection(vendorsCollection).doc(currentUser!.uid);
    store.set({
      'vendor_name': vendor_name,
      'password': password,
      'email': email,
      'imageUrl': '',
      'id': currentUser!.uid
    });
  }

  // Future<bool> checkAccountExists(String email) async {
  //   await Future.delayed(const Duration(seconds: 1));

  //   // Return a random result for demonstration purposes
  //   return Random.nextBool();
  // }

  //signout method

  signoutMethod(context) async {
    try {
      await auth.signOut();
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }
}
