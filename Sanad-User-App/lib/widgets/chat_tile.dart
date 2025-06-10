import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:sanad/models/DoctorUser_Model.dart';
import 'package:sanad/models/chatUser_model.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final Doctor userProfile;
  final Function onTap;
  const ChatTile({super.key, required this.userProfile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: ListTile(
        // User profile picture
        leading: Stack(
          alignment: Alignment.bottomRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                width: 50,
                height: 50,
                imageUrl: userProfile.image,
                errorWidget: (context, url, error) => const CircleAvatar(
                  child: Icon(CupertinoIcons.person),
                ),
              ),
            ),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: userProfile.isOnline
                    ? Colors.green.shade400
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),

        // User name
        title: Text(
          userProfile.name,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
