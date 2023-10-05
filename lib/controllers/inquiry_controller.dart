import 'package:wedeaseseller/const/const.dart';

class InquiryController extends GetxController {
  var inquiry = [];
  var confirmbooked = false.obs;
  var onPayment = false.obs;
  var onDelivered = false.obs;

  Map<String, String> inquiryAnalytics = {};

  getInquiry(data) {
    for (var item in data['inquiry']) {
      if (item['vendor_id'] == currentUser!.uid) {
        inquiry.add(item);
      }
    }
  }

  getInquiryAnalytics(vendor_id) async {
    //also add count of inquiry
    await firestore
        .collection(inquiryCollection)
        .where('vendor_id', isEqualTo: vendor_id)
        .where("inquiry_confirmed", isEqualTo: true)
        .count()
        .get()
        .then((res) {
      debugPrint("response count ${res.count}");
      inquiryAnalytics["total_inquires"] = res.count.toString();
    });

    await firestore
        .collection(inquiryCollection)
        .where('vendor_id', isEqualTo: vendor_id)
        .where("inquiry_on_delivered", isEqualTo: true)
        .count()
        .get()
        .then((res) {
      debugPrint("Total delivered count ${res.count}");
      inquiryAnalytics["total_delivered"] = res.count.toString();
    });

    await firestore
        .collection(inquiryCollection)
        .where('vendor_id', isEqualTo: vendor_id)
        .where("inquiry_on_payment", isEqualTo: true)
        .count()
        .get()
        .then((res) {
      debugPrint("Total Payment count ${res.count}");
      inquiryAnalytics["total_payment"] = res.count.toString();
    });
  }

  changeStatus({title, status, docID}) async {
    var store = firestore.collection(inquiryCollection).doc(docID);
    await store.set({title: status}, SetOptions(merge: true));
  }
}
