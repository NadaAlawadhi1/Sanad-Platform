import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanad_dashboared/models/DoctorUser_Model.dart';
import 'package:sanad_dashboared/models/Message_Model.dart';
import 'package:sanad_dashboared/models/application_doc.dart';
import 'package:sanad_dashboared/models/chatUser_model.dart';
import 'package:sanad_dashboared/models/complain_model.dart';
import 'package:sanad_dashboared/services/auth_service.dart';
import 'package:sanad_dashboared/services/notification_service.dart';




class DatabaseService {

  late AuthService _authService;
  CollectionReference? _userCollection;
  CollectionReference? _chatCollection;
  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

// Method to get the list of therapist IDs as a Stream
 static Stream<List<String>> getMyTherapistsId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_therapists')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((e) => e.id).toList());
  }

// Method to get all therapist details based on the therapist IDs
  static Stream<List<Doctor>> getAllMyTherapists(List<String> therapistsId) {
    // If the therapistsId is empty, avoid querying Firestore.
    if (therapistsId.isEmpty) {
      return Stream.value([]); // Return an empty list as a stream if no IDs are provided
    }

    return firestore
        .collection('therapists')
        .where('id', whereIn: therapistsId)
        .snapshots()
        .map((snapshot) {
      final therapistList = snapshot.docs
          .map((doc) => Doctor.fromMap(doc.data()))
          .toList();
      log("Therapist Data: ${jsonEncode(therapistList.map((doc) => doc.toMap()).toList())}");
      return therapistList;
    });
  }

  static Future<void> loadUserData() async {
    final docSnapshot = await firestore.collection('users').doc(user.uid).get();
    if (docSnapshot.exists) {
      me = ChatUser_NEW.fromMap(docSnapshot.data()!);
      log("User Data: ${me.toJson()}");
    } else {
      log("User document does not exist.");
    }
  }


  /// NEW Functions
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;
  // to return current user
  static User get user => auth.currentUser!;
  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;
  // for storing self information
  static ChatUser_NEW me = ChatUser_NEW(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      image: user.photoURL.toString(),
      createdAt: '',
      isOnline: false,
      lastActive: '',
      pushToken: '',
      role: '',
      specialist: '',
      rating: '');
  /// User Function
  // Function to create a new user in Firestore
  static Future<void> createUserInFirestore(
      String userId,
      String userName,
      String email,
      ) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser_NEW(
      id: userId,
      name: userName,
      email: email,
      image: '', // Placeholder image URL
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
      role: 'user',
      rating: '',
      specialist: ''
    );

    // Store the user in Firestore
    await firestore.collection('users').doc(userId).set(chatUser.toJson());
  }

  // useful for getting conversation id
  static String getConversationID(String id) =>
      user.uid.hashCode <= id.hashCode
          ? '${user.uid}_$id'
          : '${id}_${user.uid}';

  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      Doctor user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }
  // update profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    //getting image file extension
    final ext = file.path
        .split('.')
        .last;
    log('Extension: $ext');

    //storage file ref with path
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
  }


  //update read status of message
  static Future<void> updateMessageReadStatus(Message_New message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime
        .now()
        .millisecondsSinceEpoch
        .toString()});
  }



  //delete message
  static Future<void> deleteMessage(Message_New message) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .delete();

    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }

  /// other
  static Future<void> addNote({
    required String title,
    required String content,
    required int colorId,
  }) async {
    try {
      // Get the current timestamp for the note creation date
      final creationDate = DateTime.now().millisecondsSinceEpoch;

      // Add the note to the current user's `my_notes` collection
      await firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_notes')
          .add({
        "note_title": title,
        "creation_date": creationDate,
        "note_content": content,
        "color_id": colorId,
      });

      log("Note added successfully for user ${user.uid}");
    } catch (e) {
      log("Failed to add note: $e");
    }
  }

  static Stream<QuerySnapshot> fetchUserNotes() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_notes')
        .orderBy('creation_date', descending: true) // Order by date if needed
        .snapshots();
  }

  // Function to check if the username is already taken
  static Future<bool> checkIfEmailExists(String email) async {
    final querySnapshot = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      'push_token': me.pushToken,
    });
  }
/// Complains :
// Stream to get complaints from Firestore
  static Stream<List<Complaint>> fetchComplaints() {
    return FirebaseFirestore.instance
        .collection('complaints')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
        .map((doc) => Complaint.fromJson(doc.data() as Map<String, dynamic>))
        .toList())
        .handleError((error) {
      log("Error fetching complaints: $error");
      // Optionally, handle specific error types here
    });
  }

  /// Chat Functions
  // for adding an user to my user when first message is send
  static Future<void> sendFirstMessage(Doctor chatUser, String msg,
      Type type) async {
    await firestore
        .collection('users')
        .doc(DatabaseService.user.uid)
        .collection('my_therapists')
        .doc(chatUser.id)
        .set({}).then((value) => sendMessage(chatUser, msg, type));

    await firestore
        .collection('therapists')
        .doc(chatUser.id)
        .collection('my_patient')
        .doc(user.uid)
        .set({});


  }
     // for sending message
    static Future<void> sendMessage(Doctor chatUser, String msg,
        Type type) async {
      //message sending time (also used as id)
      final time = DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();

      //message to send
      final Message_New message = Message_New(
          toId: chatUser.id,
          msg: msg,
          read: '',
          type: type,
          fromId: user.uid,
          sent: time);

      final ref = firestore
          .collection('chats/${getConversationID(chatUser.id)}/messages/');
      await ref.doc(time).set(message.toJson()).then((value) =>
          NotificationHelper.sendNotification(
            title: me.name,
              body: msg,
              targetToken: chatUser.pushToken,
             mediaUrl: '',
          ));
    }


  //send chat image
  static Future<void> sendChatImage(Doctor chatUser, File file) async {
    //getting image file extension
    final ext = file.path
        .split('.')
        .last;

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime
            .now()
            .millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }

  // Doctor Functions:

  /// Function to create a new doctor profile in Firestore
  // Function to create a new doctor account
  static Future<String?> createDoctorAccount({
    required String name,
    required String email,
    required String password,
    required int yearOfExperience,
    required String bio,
    required String specialist,
    required String price,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      Doctor doctor = Doctor(
        id: userId,
        name: name,
        email: email,
        about: bio,
        yearOfExperience: yearOfExperience,
        rating: 1.5, // Default rating
        specialist: specialist,
        price: price,
        isOnline: false,
        lastActive: DateTime.now().toString(),
        role: 'doctor',
        image: '', // Optional image URL
        pushToken: '', // Optional push token
        reviews: [], // Optional reviews
      );

      await FirebaseFirestore.instance.collection('therapists').doc(userId).set(doctor.toMap());
      return null; // No errors
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'The email address is already in use by another account.';
      }
      return 'An error occurred: ${e.message}';
    } catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Deletes a therapist's profile and Firebase account
  static Future<String?> deleteTherapist(String therapistId) async {
    try {
      // Step 1: Delete the therapist profile from Firestore
      await FirebaseFirestore.instance.collection('therapists').doc(therapistId).delete();

      return 'Delete account successfully';
    } on FirebaseAuthException catch (e) {
      return 'Firebase Auth error: ${e.message}';
    } on FirebaseException catch (e) {
      return 'Firestore error: ${e.message}';
    } catch (e) {
      return 'Unexpected error: $e';
    }
  }

  static Future<String?> updateDoctorInfo({
    required String doctorId,
    String? name,
    String? email,
    String? bio,
    int? yearOfExperience,
    String? specialist,
    String? price,
    String? image,
  }) async {
    try {
      // Create a map with the fields to update (only include non-null values)
      Map<String, dynamic> updatedData = {};

      if (name != null) updatedData['name'] = name;
      if (email != null) updatedData['email'] = email;
      if (bio != null) updatedData['about'] = bio;
      if (yearOfExperience != null) updatedData['year_of_experience'] = yearOfExperience;
      if (specialist != null) updatedData['specialist'] = specialist;
      if (price != null) updatedData['price'] = price;
      if (image != null) updatedData['image'] = image;

      // Update the doctor information in Firestore
      await FirebaseFirestore.instance.collection('therapists').doc(doctorId).update(updatedData);

      return null; // No errors, update successful
    } on FirebaseAuthException catch (e) {
      return 'Firebase Auth error: ${e.message}';
    } on FirebaseException catch (e) {
      return 'Firestore error: ${e.message}';
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }
  // Fetch all doctors and users
  static Stream<int> getCollectionLengthStream(String collectionName) {
    return FirebaseFirestore.instance.collection(collectionName).snapshots().map((snapshot) => snapshot.size);
  }


  // Fetch all doctors
  static Stream<List<Doctor>> getDoctors() {
    return FirebaseFirestore.instance
        .collection('therapists')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        // Log the data for debugging
        log("Data: ${jsonEncode(doc.data())}");
        return Doctor.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  /// Function to add a review for a doctor
 static Future<void> addDoctorReview({
    required String doctorId,
    required String userName,
    required String comment,
  }) async {
    final review = {
      'name': userName,
      'comment': comment,
      'created_at': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    // Add the review to the doctor's reviews sub-collection
    await firestore.collection('therapists').doc(doctorId).collection('reviews').add(review);
  }

  /// Function to get all reviews for a specific doctor
  static Stream<List<Review>> getDoctorReviews(String doctorId) {
    return firestore
        .collection('therapists')
        .doc(doctorId)
        .collection('reviews')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Review.fromMap(doc.data()))
        .toList());
  }

  /// Function to get all Applications
  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchApplications() {
    try {
      // Return a stream of application snapshots from Firestore
      return FirebaseFirestore.instance.collection('applications').snapshots();
    } catch (e) {
      log("Failed to fetch applications: $e");
      // Return an empty stream in case of an error
      return const Stream.empty();
    }
  }



}
