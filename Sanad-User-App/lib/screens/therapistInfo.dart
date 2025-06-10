import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sanad/mainPage.dart';
import 'package:sanad/generated/l10n.dart';
import 'package:sanad/models/DoctorUser_Model.dart';
import 'package:sanad/screens/chat_page.dart';
import 'package:sanad/services/database_service.dart';
import 'package:sanad/services/navigation_service.dart';
import 'package:sanad/utils.dart';

class Therapistinfo extends StatefulWidget {
  final Doctor doctor;
  const Therapistinfo({super.key, required this.doctor});

  @override
  State<Therapistinfo> createState() => _TherapistinfoState();
}

class _TherapistinfoState extends State<Therapistinfo> {
  late NavigationService _navigationService;
  final GetIt _getIt = GetIt.instance;
  @override
  void initState() {
    _navigationService = _getIt.get<NavigationService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: MyColors.white,
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: _therapistProfile(),
              ),
              const SizedBox(height: 20), // Space between profile and reviews
              _reviewsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _therapistProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: MyColors.skyBlue,
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(widget.doctor.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 60,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: MyColors.lightCornflowerBlue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.doctor.rating}",
                          style: TextStyle(fontSize: 12),
                        ),
                        const Icon(
                          Icons.star_rounded,
                          color: MyColors.skyBlue,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.doctor.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 20,
                      width: 160,
                      decoration: BoxDecoration(
                        color: MyColors
                            .lightCornflowerBlue, // Set the background color
                        borderRadius: BorderRadius.circular(
                            4), // Slightly rounded corners
                      ),
                      child: Center(child: Text(widget.doctor.specialist)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 170, // Set your desired width here
                      child: ElevatedButton(
                        onPressed: () {
                          _navigationService.push(
                            MaterialPageRoute(
                              builder: (context) {
                                return ChatPage(chatUser: widget.doctor);
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.skyBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                6), // Slightly rounded corners
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Space between content
                          children: [
                            Text(
                              S.of(context).bookSessionButton,
                              style:
                                  TextStyle(color: Colors.white), // Text color
                            ),
                            const SizedBox(width: 20),
                            const Icon(
                              Icons.chat_bubble_rounded,
                              color: Colors.white, // Icon color
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          width: 350, // Set a fixed width for the container
          padding: const EdgeInsets.all(16.0), // Add padding around the content
          decoration: BoxDecoration(
            color: MyColors.lightCornflowerBlue, // Set background color
            borderRadius:
                BorderRadius.circular(8.0), // Optional: add rounded corners
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align text to the start
            children: [
              Text(
                '• Years of experience: ${widget.doctor.yearOfExperience}',
                style: const TextStyle(fontSize: 16), // Set font size for text
              ),
              const Text(
                '• Languages: العربية | English',
                style: TextStyle(fontSize: 16), // Set font size for text
              ),
              Text(
                '• Session: ${widget.doctor.price} YER / Hour',
                style: const TextStyle(fontSize: 16), // Set font size for text
              ),
              const SizedBox(height: 16), // Space after the last text
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          S.of(context).aboutTherapistText,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 8),
        Text(widget.doctor.about),
      ],
    );
  }

/////////////////////////////////////////////////////////////////////////////////////
  Widget _reviewsList() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(

        color: MyColors.lightCornflowerBlue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              S.of(context).reviewsText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: 150,
            child: const Divider(
              color: MyColors.lightSkyBlue, // Blue line color
              thickness: 1, // Thickness of the line
            ),
          ),
          const SizedBox(height: 16), // Space after the title
          StreamBuilder<List<Review>>(
            stream: DatabaseService.getDoctorReviews(widget.doctor.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Show a loading indicator
              } else if (snapshot.hasError) {
                return Text(
                    'Error: ${snapshot.error}'); // Display error message
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                    child: Text(S
                        .of(context)
                        .noReviewsMessage)); // Display when there are no reviews
              }

              // If data is available, use it in ListView
              List<Review> reviews = snapshot.data!;

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(review.comment),
                      const Divider(
                        color: MyColors.lightSkyBlue,
                        thickness: 1,
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
