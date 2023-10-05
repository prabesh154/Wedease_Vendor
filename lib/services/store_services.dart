import 'package:wedeaseseller/const/firebase_consts.dart';

class StoreServices {
  static getProfile(uid) {
    return firestore
        .collection(vendorsCollection)
        .where('id', isEqualTo: uid)
        .get();
  }

  static getMessages(uid) {
    return firestore
        .collection(chatsCollection)
        .where('toId', isEqualTo: uid)
        .snapshots();
  }

  static getInquiry(uid) {
    return firestore
        .collection(inquiryCollection)
        .where('vendor_id', isEqualTo: uid)
        .snapshots();
  }

  static getServices(uid) {
    print(uid);
    return firestore
        .collection(servicesCollection)
        .where('vendor_id', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static getServiceDetail(service_name) {
    return firestore
        .collection(servicesCollection)
        .where('s_name', isEqualTo: service_name)
        .snapshots();
  }

  static getPopularServices(uid) {
    return firestore
        .collection(servicesCollection)
        .where('vendor_id', isEqualTo: uid)
        .orderBy('s_wishlist'.length);
  }
}
