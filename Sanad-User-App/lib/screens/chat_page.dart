import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:sanad/models/DoctorUser_Model.dart';
import 'package:sanad/models/Message_model.dart';
import 'package:sanad/services/database_service.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:sanad/services/share_preference.dart';
import 'package:sanad/utils.dart';
import 'package:sanad/widgets/chat_buble.dart';
import 'package:sanad/widgets/rating_dialog.dart';

class ChatPage extends StatefulWidget {
  final Doctor chatUser;
  const ChatPage({super.key, required this.chatUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatUser? currentUser, otherUser;
  List<Message_New> messagesList = [];
  bool _isUploading = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Call the method to check if 1 hour has passed as soon as the page is loaded
    _checkIfOneHourPassed();
  }

  void _checkIfOneHourPassed() {
    if (CashSaver.getData(key: widget.chatUser.id ) ?? false ) return; // If the dialog has already been shown, don't show it again

    final currentTime = DateTime.now();
    if (messagesList.isNotEmpty) {
      int messageTimestamp = int.parse(messagesList[0].sent);
      DateTime messageTime = DateTime.fromMillisecondsSinceEpoch(messageTimestamp);
      final difference = currentTime.difference(messageTime).inMinutes;
      // Show the dialog if 1 hour has passed since the first message
      if (difference >= 60) {
        // Display the rating dialog
        WidgetsBinding.instance.addPostFrameCallback((_) {
          RatingDialog.show(context,doctorId: widget.chatUser.id ); // Make sure to call the dialog in a safe manner
        });
        // Update the flag to prevent showing it again
          CashSaver.saveData(key: widget.chatUser.id,value: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatUser.name),
        backgroundColor: MyColors.lightCornflowerBlue,
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Container(
      color: MyColors.white,
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: DatabaseService.getAllMessages(widget.chatUser),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const SizedBox();

                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    messagesList = data
                        ?.map((e) => Message_New.fromJson(e.data()))
                        .toList() ?? [];

                    // Check if the first message is present and if 1 hour has passed
                    _checkIfOneHourPassed();

                    if (messagesList.isNotEmpty) {
                      return ListView.builder(
                        reverse: true,
                        itemCount: messagesList.length,
                        padding: const EdgeInsets.only(top: 10),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return MessageCard(message: messagesList[index]);
                        },
                      );
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/noMessages.jpg",
                              width: 200, // Set your desired width
                              height: 100, // Set your desired height
                            ),
                            Text('No messages',
                                style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                      );
                    }
                }
              },
            ),
          ),

          // Progress indicator for showing uploading
          if (_isUploading)
            const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: CircularProgressIndicator(strokeWidth: 2))),
          chatInput(context),
        ],
      ),
    );
  }

  // Chat input widget
  Widget chatInput(context) {
    return Container(
      color: MyColors.lightgray,
      child: Row(
        children: [
          // Take image from camera button
          IconButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                // Pick an image
                final XFile? image = await picker.pickImage(
                    source: ImageSource.camera, imageQuality: 70);
                if (image != null) {
                  log('Image Path: ${image.path}');
                  setState(() => _isUploading = true);
                  await DatabaseService.sendChatImage(
                      widget.chatUser, File(image.path));
                  setState(() => _isUploading = false);
                }
              },
              icon: Icon(Icons.camera_alt_rounded,
                  color: Theme.of(context).iconTheme.color, size: 26)),
          // Input field & buttons
          Expanded(
            child: Card(
              color: MyColors.lightCornflowerBlue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeApp.s30)),
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: TextField(
                          style: TextStyle(
                            color: MyColors.black,
                            backgroundColor: MyColors.lightCornflowerBlue,
                          ),
                          controller: controller,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          onTap: () {
                            // if (Cubit.showEmoji) setState(() => _showEmoji = !_showEmoji);
                          },
                          decoration: InputDecoration(
                              hintText: 'Type Something...',
                              hintStyle: TextStyle(
                                  color: Theme.of(context).iconTheme.color,
                                  fontSize: 12,
                                  overflow: TextOverflow.ellipsis),
                              border: InputBorder.none),
                        ),
                      )),

                  // Pick image from gallery button
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final List<XFile> images =
                        await picker.pickMultiImage(imageQuality: 70);
                        for (var i in images) {
                          log('Image Path: ${i.path}');
                          setState(() => _isUploading = true);
                          await DatabaseService.sendChatImage(
                              widget.chatUser, File(i.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      icon: Icon(Icons.image,
                          color: Theme.of(context).iconTheme.color, size: 26)),

                  const SizedBox(width: 10),

                ],
              ),
            ),
          ),
          SizedBox(width: 10),
          // Send message button
          MaterialButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                if (messagesList.isEmpty) {
                  // On first message (add user to my_therapist collection of chat user)
                  DatabaseService.sendFirstMessage(
                      widget.chatUser, controller.text, Type.text);
                } else {
                  // Simply send message
                  DatabaseService.sendMessage(
                      widget.chatUser, controller.text, Type.text);
                  controller.text = '';
                }
              }
              controller.clear();
            },
            minWidth: 0,
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Theme.of(context).primaryColor,
            child: Icon(Icons.send, color: MyColors.white, size: 20),
          )
        ],
      ),
    );
  }
}

