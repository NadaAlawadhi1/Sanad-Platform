import "dart:developer";

import "package:flutter/material.dart";
import "package:sanad/generated/l10n.dart";
import "package:sanad/services/database_service.dart";
import "package:sanad/utils.dart";

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    DatabaseService.getSelfInfo();
    log('image ${DatabaseService.me.image}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          homeFirstPart(),
          homeSecondPart(),
        ],
      ),
    );
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Widget homeFirstPart() {
    return Container(
      color: MyColors.lightCornflowerBlue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Text(
              S.of(context).homeMainTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 7,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            S.of(context).homeMainDescription,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(
                right: 30, left: 30, top: 40, bottom: 110),
            child: Image.asset(
              "assets/images/idea.jfif",
            ),
          ),
        ],
      ),
    );
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Widget homeSecondPart() {
    return Container(
      color: MyColors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Text(
                S.of(context).why,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: MyColors.skyBlue),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: S.of(context).whyAnswer1,
                    ),
                    TextSpan(
                      text: S.of(context).whyAnswer2,
                      style: const TextStyle(color: MyColors.lightSkyBlue),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/lock.jfif",
                        fit: BoxFit.contain,
                      ),
                      Text(
                        S.of(context).reason1,
                        style: const TextStyle(
                          color: MyColors.skyBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        S.of(context).reasonDesc1,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/sofa.jfif",
                        fit: BoxFit.contain,
                      ),
                      Text(
                        S.of(context).reason2,
                        style: const TextStyle(
                          color: MyColors.skyBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        S.of(context).reasonDesc2,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Flexible(
              flex: 1,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 110, right: 125, bottom: 50),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/sunny.jpg",
                      fit: BoxFit.contain,
                    ),
                    Text(
                      S.of(context).reason3,
                      style: const TextStyle(
                        color: MyColors.skyBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      S.of(context).reasonDesc3,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
