import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sanad/generated/l10n.dart'; // Adjust import as per your localization setup
import 'package:sanad/models/DoctorUser_Model.dart';
import 'package:sanad/models/chatUser_model.dart';
import 'package:sanad/screens/Therapists/cubit/therapist_cubit.dart';
import 'package:sanad/screens/therapistInfo.dart';
import 'package:sanad/services/database_service.dart';
import 'package:sanad/services/navigation_service.dart';
import 'package:sanad/utils.dart';

class Therapists extends StatefulWidget {
  const Therapists({super.key});

  @override
  State<Therapists> createState() => _TherapistsState();
}

class _TherapistsState extends State<Therapists> {
  String searchQuery = '';
  final PageController _pageController = PageController();
  final PageStorageKey _pageStorageKey = PageStorageKey('therapists_page_view');
  late NavigationService _navigationService;
  final GetIt _getIt = GetIt.instance;
  @override
  void initState() {
    _navigationService = _getIt.get<NavigationService>();
    super.initState();
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
            SingleChildScrollView(
              child: Column(
                children: [
                  therapistFirstPart(),
                  const SizedBox(height: 20),
                  therapistSecondPart(),
                ],
              ),
    );
  }

  Widget therapistFirstPart() {
    return Container(
      color: MyColors.lightCornflowerBlue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Text(
              S.of(context).therapistsMainTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 7,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            S.of(context).therapistsMainDesc,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset("assets/images/watering.jfif", width: 250),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget therapistSecondPart() {
    return Container(
      color: MyColors.white,
      child: Column(
        children: [
          _buildSearchField(),
          const SizedBox(height: 10),
          therapistList(), // Call the therapist list here
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            searchQuery = value.toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: S.of(context).therapistSearchHint,
          hintStyle: const TextStyle(color: MyColors.white, fontSize: 12),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          filled: true,
          fillColor: MyColors.skyBlue,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          suffixIcon: const Icon(
            Icons.search,
            color: MyColors.white,
            size: 18,
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget therapistList() {
    return StreamBuilder<List<Doctor>>(
      stream: DatabaseService.getDoctors(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Unable to load data: ${snapshot.error}"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final therapists = snapshot.data!;

        return Column(
          children: [
            therapistListView(therapists),
            _buildDotsIndicator(therapists.length), // Pass length here
          ],
        );
      },
    );
  }

  Widget therapistListView(List<Doctor> therapists) {
    final filteredTherapists = therapists.where((therapist) {
      return therapist.name.toLowerCase().contains(searchQuery) ||
          therapist.specialist.toLowerCase().contains(searchQuery);
    }).toList();

    return BlocConsumer<TherapistCubit, TherapistState>(
      listener: (context, state) {
        // Retrieve the current page from the state
        context.read<TherapistCubit>().currentIndex = state is TherapistPageChanged ? state.currentPage : 0;
        log('${ context.read<TherapistCubit>().currentIndex}');
      },
      builder: (context, state) {
        return Container(
          height: 400,
          child: PageView.builder(
            key: _pageStorageKey, // Retain the PageView state
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: (filteredTherapists.length / 4).ceil(),
            onPageChanged: (index) {
              // Update the current page in TherapistCubit
              context.read<TherapistCubit>().changePage(index);
            },
            itemBuilder: (context, pageIndex) {
              final start = pageIndex * 4;
              final end = (start + 4 < filteredTherapists.length)
                  ? start + 4
                  : filteredTherapists.length;
              final pageTherapists = filteredTherapists.sublist(start, end);

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: List.generate(pageTherapists.length, (index) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 16,
                      child: _buildTherapistItem(pageTherapists[index]),
                    );
                  }),
                ),
              );
            },
          ),
        );
      },
    );
  }


  Widget _buildTherapistItem(Doctor therapist) {
    return InkWell(
      onTap: () {
        _navigationService.push(
          MaterialPageRoute(
            builder: (context) {
              return Therapistinfo(doctor: therapist,);
            },
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(therapist.image),
            ),
            const SizedBox(height: 8),
            Text(
              therapist.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            Text(
              therapist.specialist,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              width: 50,
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              decoration: BoxDecoration(
                border: Border.all(color: MyColors.skyBlue),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${therapist.rating}',
                    style: const TextStyle(fontSize: 11),
                  ),
                  Icon(
                    Icons.star_rounded,
                    color: MyColors.skyBlue,
                    size: 14,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDotsIndicator(int therapistCount) {
    final pageCount = (therapistCount / 4).ceil();

    return BlocBuilder<TherapistCubit, TherapistState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(pageCount, (index) {
            return Container(
              height: 8,
              width: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4,vertical: 18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.read<TherapistCubit>().currentIndex == index
                    ? MyColors.skyBlue
                    : const Color.fromARGB(255, 129, 129, 129),
              ),
            );
          }),
        );
      },
    );
  }

  BlocBuilder<TherapistCubit, TherapistState> buildDot(int index) {
    return BlocBuilder<TherapistCubit, TherapistState>(
  builder: (context, state) {
    return Container(
      height: 5,
      width: 5,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: context.read<TherapistCubit>().currentIndex == index
            ? MyColors.skyBlue
            : const Color.fromARGB(255, 129, 129, 129),
      ),
    );
  },
);
  }
}
