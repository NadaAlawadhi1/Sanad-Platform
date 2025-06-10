import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sanad_therapists/models/DoctorUser_Model.dart';
import 'package:sanad_therapists/models/Message_model.dart';
import 'package:sanad_therapists/models/chatUser_model.dart';
import 'package:sanad_therapists/services/auth_service.dart';
import 'package:sanad_therapists/services/notification_service.dart';
import 'package:sanad_therapists/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  late AuthService _authService;
  CollectionReference? _userCollection;
  CollectionReference? _chatCollection;
  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

// Method to get the list of therapist IDs as a Stream
  static Stream<List<String>> getMyPatientsId() {
    return firestore
        .collection('therapists')
        .doc(user.uid)
        .collection('my_patient')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((e) => e.id).toList());
  }

// Method to get all therapist details based on the therapist IDs
  static Stream<List<Doctor>> getAllMyTherapists(List<String> therapistsId) {
    // If the therapistsId is empty, avoid querying Firestore.
    if (therapistsId.isEmpty) {
      return Stream.value(
          []); // Return an empty list as a stream if no IDs are provided
    }

    return firestore
        .collection('therapists')
        .where('id', whereIn: therapistsId)
        .snapshots()
        .map((snapshot) {
      final therapistList =
          snapshot.docs.map((doc) => Doctor.fromMap(doc.data())).toList();
      log("Therapist Data: ${jsonEncode(therapistList.map((doc) => doc.toMap()).toList())}");
      return therapistList;
    });
  }

  Future<bool> checkChatExist(String uid1, String uid2) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final result = await _chatCollection?.doc(chatID).get();

    if (result != null) {
      return result.exists;
    }
    return false;
  }

  static Future<void> loadUserData() async {
    final docSnapshot =
        await firestore.collection('therapists').doc(user.uid).get();
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
  );

  /// User Function

  // useful for getting conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser_NEW user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // update profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;
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
        .collection('therapists')
        .doc(user.uid)
        .update({'image': me.image});
  }

  //update read status of message
  static Future<void> updateMessageReadStatus(Message_New message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
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

  /// Complains
  static Future<void> addComplaint(String title, String description) async {
    final complaint = {
      'title': title,
      'image': me.image,
      'name': me.name,
      'description': description,
      'createdAt': Timestamp.now(),
    };

    await FirebaseFirestore.instance.collection('complaints').add(complaint);
  }

  /// other
  // for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore
        .collection('therapists')
        .doc(user.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = ChatUser_NEW.fromJson(user.data()!);
        //for setting user status to active
        DatabaseService.updateActiveStatus(true);
      } else {}
    });
  }

  static Future<void> addNote({
    required String title,
    required String content,
    required int colorId,
    DateTime? creationDate, // Optional parameter for creation date
  }) async {
    try {
      // Use the provided creationDate or fallback to the current timestamp
      final creationTimestamp =
          (creationDate ?? DateTime.now()).millisecondsSinceEpoch;

      // Add the note to the current user's `my_notes` collection
      await firestore
          .collection('therapists')
          .doc(user.uid)
          .collection('my_notes')
          .add({
        "note_title": title,
        "creation_date": creationTimestamp,
        "note_content": content,
        "color_id": colorId,
      });

      log("Note added successfully for user ${user.uid}");
    } catch (e) {
      log("Failed to add note: $e");
    }
  }

  static Future<String> uploadFileToCVFolder(String filePath) async {
    try {
      final file = File(filePath);
      final fileName = file.uri.pathSegments.last;
      final ref = FirebaseStorage.instance.ref().child('cv/$fileName');

      // Upload the file
      await ref.putFile(file);

      // Get the download URL
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception("Failed to upload file: $e");
    }
  }

  static Future<void> addApplication({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String gender,
    required String city,
    required String registrationStatus,
    required int experience,
    String? cvPath, // Add this parameter
  }) async {
    try {
      await firestore.collection('applications').add({
        "full_name": fullName,
        "email": email,
        "phone_number": phoneNumber,
        "gender": gender,
        "city": city,
        "registration_status": registrationStatus,
        "experience": experience,
        "cv_path": cvPath, // Save the CV path
        "application_date": DateTime.now().millisecondsSinceEpoch,
      });

      log("Application added successfully");
    } catch (e) {
      log("Failed to add application: $e");
    }
  }

  static Stream<QuerySnapshot> fetchtherapistsNotes() {
    return firestore
        .collection('therapists')
        .doc(user.uid)
        .collection('my_notes')
        .orderBy('creation_date', descending: true) // Order by date if needed
        .snapshots();
  }

  // Function to check if the username is already taken
  static Future<bool> checkIfEmailExists(String email) async {
    final querySnapshot = await firestore
        .collection('therapists')
        .where('email', isEqualTo: email)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('therapists').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  /// Chat Functions
  ///
  // for adding an user to my user when first message is send
  static Future<void> sendFirstMessage(
      ChatUser_NEW chatUser, String msg, Type type) async {
    await firestore
        .collection('therapists')
        .doc(DatabaseService.user.uid)
        .collection('my_patient')
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
  static Future<void> sendMessage(
      ChatUser_NEW chatUser, String msg, Type type) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

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
    await ref
        .doc(time)
        .set(message.toJson())
        .then((value) => NotificationHelper.sendNotification(
              title: me.name,
              body: msg,
              targetToken: chatUser.pushToken,
              mediaUrl: '',
            ));
  }

  //send chat image
  static Future<void> sendChatImage(ChatUser_NEW chatUser, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

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
    await firestore
        .collection('therapists')
        .doc(doctorId)
        .collection('reviews')
        .add(review);
  }

  /// Function to get all reviews for a specific doctor
  static Stream<List<Review>> getDoctorReviews(String doctorId) {
    return firestore
        .collection('therapists')
        .doc(doctorId)
        .collection('reviews')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Review.fromMap(doc.data())).toList());
  }
}
