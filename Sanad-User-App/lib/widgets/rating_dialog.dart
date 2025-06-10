import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sanad/generated/l10n.dart';
import 'package:sanad/services/database_service.dart';
import 'package:sanad/utils.dart';

class RatingDialog {
  static void show(BuildContext context, {required doctorId}) {
    double _rating = 0.0;
    final TextEditingController _commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColors.lightCornflowerBlue,
          title: Text(S.of(context).rateTherapistTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 1),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: MyColors.white,
                    ),
                    onRatingUpdate: (rating) {
                      _rating = rating;
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: S.of(context).commentLabelText,
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                DatabaseService.addDoctorReview(
                    doctorId: doctorId,
                    userName: DatabaseService.me.name,
                    comment: _commentController.text);
                Navigator.of(context).pop();
              },
              child: Text(
                S.of(context).submitButtonText,
                style: TextStyle(color: MyColors.skyBlue),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                S.of(context).cancelButtonText,
                style: TextStyle(color: MyColors.skyBlue),
              ),
            ),
          ],
        );
      },
    );
  }
}
