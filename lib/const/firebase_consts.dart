// import 'package:wedeaseseller/const/const.dart';

// FirebaseAuth auth = FirebaseAuth.instance;
// FirebaseFirestore firestore = FirebaseFirestore.instance;
// User? currentUser = auth.currentUser;

// // Collections
// const vendorsCollection = 'seller_vendors';

// // productCollection as serviceCollection

// const servicesCollection = "services";

// // inquiry collection
// const inquiryCollection = 'inquiry';
// const chatsCollection = 'chats';
// const messagesCollection = 'messages';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
User? currentUser = auth.currentUser;

// Collections
const vendorsCollection = 'seller_vendors';
const servicesCollection = 'services';
const inquiryCollection = 'inquiry';
const chatsCollection = 'chats';
const messagesCollection = 'messages';

Future<void> createOrUpdateUserDocument() async {
  if (currentUser != null) {
    final DocumentReference userDocument =
        firestore.collection(vendorsCollection).doc(currentUser!.uid);

    // Check if the document already exists before creating or updating it
    final DocumentSnapshot documentSnapshot = await userDocument.get();
    if (!documentSnapshot.exists) {
      // If the document doesn't exist, create it with the UID as the "id" field
      await userDocument.set({
        'id': currentUser!.uid,
        // Other fields you want to include
      });
    }
  }
}

Future<void> signInWithEmailAndPassword(String email, String password) async {
  try {
    await auth.signInWithEmailAndPassword(email: email, password: password);

    // After successful login, create or update the Firestore document
    await createOrUpdateUserDocument();

    // Continue with your app's navigation or other logic
  } catch (e) {
    print('Error signing in: $e');
    // Handle authentication errors
  }
}

// Example usage:
// For registration, call createOrUpdateUserDocument() after user registration.
// For login, call signInWithEmailAndPassword() during login.
