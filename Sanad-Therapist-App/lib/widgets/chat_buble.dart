import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sanad_therapists/models/Message_model.dart';
import 'package:sanad_therapists/services/Time_format.dart';
import 'package:sanad_therapists/services/alert_service.dart';
import 'package:sanad_therapists/utils.dart';
import 'package:saver_gallery/saver_gallery.dart';
import '../services/database_service.dart';

// for showing single message details
class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Message_New message;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  AlertService? alertService;
  @override
  Widget build(BuildContext context) {
    bool isMe = DatabaseService.user.uid == widget.message.fromId;
    return InkWell(
        onLongPress: () {
          showBottomSheet(isMe);
        },
        child: isMe ? _greyMessage() : _blueMessage());
  }

  // sender or another user message
  Widget _blueMessage() {
    //update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      DatabaseService.updateMessageReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ? 10 : 5),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                color:Colors.grey[200],
                //making borders curved
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: widget.message.type == Type.text
                ?
                //show text
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Message content
                      Text(
                        widget.message.msg,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: MyColors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //message time
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                            Format_Time.getFormattedTime(
                                context: context, time: widget.message.sent),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: MyColors.black)),
                      ),
                    ],
                  )
                :
                //show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ), //todo :: download image state circle
          ),
        ),
      ],
    );
  }

  // our or user message
  Widget _greyMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        //message content
        Flexible(
          child: Container(
            padding:
                EdgeInsets.all(widget.message.type == Type.image ? 10 : 10),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                color: MyColors.skyBlue,
                //making borders curved
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10))),
            child: widget.message.type == Type.text
                ?
                //show text
                Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.message.msg,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: MyColors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            Format_Time.getFormattedTime(
                                context: context, time: widget.message.sent),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: MyColors.white),
                          ),
                          //for adding some space
                          const SizedBox(width: 10),
                          //double tick blue icon for message read
                          Icon(Icons.done_all_rounded,
                              color: widget.message.read.isNotEmpty
                                  ? MyColors.white
                                  : Colors.grey,
                              size: 20),
                        ],
                      ),
                    ],
                  )
                :
                //show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Future<bool> _saveNetworkImage(String path) async {
    try {
      var response = await Dio()
          .get(path, options: Options(responseType: ResponseType.bytes));
      final result = await SaverGallery.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        fileName: "media",
        skipIfExists: false,
      );
      log(result.toString());
      return true;
    } catch (e) {
      log('ErrorWhileSavingMedia: $e');
      return false;
    }
  }

  // bottom sheet for modifying message details
  void showBottomSheet(bool isMe) {
    showModalBottomSheet(
        backgroundColor: MyColors.lightgray,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              //black divider
              Container(
                height: 5,
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 150),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8)),
              ),
              widget.message.type == Type.text
                  ?
                  //copy option
                  _OptionItem(
                      icon: const Icon(Icons.copy_all_rounded,
                          color: MyColors.lightSkyBlue, size: 26),
                      name: 'Copy Text',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          //for hiding bottom sheet
                          Navigator.pop(context);
                          alertService!.showToast(
                            text: 'Text Copied!',
                          );
                        });
                      })
                  :
                  //save option
                  _OptionItem(
                      icon: const Icon(Icons.download_rounded,
                          color: MyColors.lightSkyBlue, size: 26),
                      name: 'Save Image',
                      onTap: () async {
                        try {
                          bool success =
                              await _saveNetworkImage(widget.message.msg);
                          Navigator.pop(context);
                          if (success) {
                            alertService!
                                .showToast(text: 'Image Successfully Saved!');
                          }
                        } catch (e) {
                          log('ErrorWhileSavingMedia: $e');
                        }
                      },
                    ),
              //separator or divider
              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: 5,
                  indent: 5,
                ),

              //delete option
              if (isMe)
                _OptionItem(
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: Colors.red, size: 26),
                    name: 'Delete Message',
                    onTap: () async {
                      await DatabaseService.deleteMessage(widget.message)
                          .then((value) {
                        //for hiding bottom sheet
                        Navigator.pop(context);
                      });
                    }),
              //separator or divider
              Divider(
                color: Colors.black54,
                endIndent: 10,
                indent: 10,
              ),
              //sent time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye_outlined,
                      color: MyColors.lightSkyBlue),
                  name:
                      'Sent At: ${Format_Time.getMessageTime(context: context, time: widget.message.sent)}',
                  onTap: () {}),
              //read time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye_outlined,
                      color: Colors.green),
                  name: widget.message.read.isEmpty
                      ? 'Read At: Not seen yet'
                      : 'Read At: ${Format_Time.getMessageTime(context: context, time: widget.message.read)}',
                  onTap: () {}),
            ],
          );
        });
  }

  //dialog for updating message content
  void showMessageUpdateDialog() {
    String updatedMsg = widget.message.msg;
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              //title
              title: Row(
                children: const [
                  Icon(
                    Icons.message,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text(' Update Message')
                ],
              ),
              //content
              content: TextFormField(
                initialValue: updatedMsg,
                maxLines: null,
                onChanged: (value) => updatedMsg = value,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )),
              ],
            ));
  }
}

//custom options card (for copy,  delete, etc.)
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('    $name',
                    style: Theme.of(context).textTheme.bodyMedium))
          ]),
        ));
  }
}
