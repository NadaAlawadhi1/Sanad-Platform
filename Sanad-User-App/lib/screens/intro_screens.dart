import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sanad/generated/l10n.dart';
import 'package:sanad/main.dart';
import 'package:sanad/utils.dart';

class Intropagescontent {
  String image;
  Intropagescontent({required this.image});
}

List<Intropagescontent> content = [
  Intropagescontent(image: "assets/images/intro1.png"),
  Intropagescontent(image: "assets/images/intro2.png"),
  Intropagescontent(image: "assets/images/intro3.png"),
];

class IntroviewScreens extends StatefulWidget {
  const IntroviewScreens({super.key});

  @override
  State<IntroviewScreens> createState() => _IntroviewscreensState();
}

class _IntroviewscreensState extends State<IntroviewScreens> {
  int currentindex = 0;

  // Create lists for titles and descriptions
  final List<String> titles = [
    'introTitle1',
    'introTitle2',
    'introTitle3',
  ];

  final List<String> descriptions = [
    'introDescription1',
    'introDescription2',
    'introDescription3',
  ];

  String getLocalizedTitle(BuildContext context, int index) {
    switch (index) {
      case 0:
        return S.of(context).introTitle1;
      case 1:
        return S.of(context).introTitle2;
      case 2:
        return S.of(context).introTitle3;
      default:
        return '';
    }
  }

  String getLocalizedDescription(BuildContext context, int index) {
    switch (index) {
      case 0:
        return S.of(context).introDescription1;
      case 1:
        return S.of(context).introDescription2;
      case 2:
        return S.of(context).introDescription3;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/language-solid.svg',
              color: MyColors.skyBlue,
              height: 50,
              width: 66,
            ),
            onPressed: () {
              Provider.of<LanguageProvider>(context, listen: false)
                  .toggleLanguage();
            }),
      ),
      body: PageView.builder(
        itemCount: content.length,
        onPageChanged: (int index) {
          setState(() {
            currentindex = index;
          });
        },
        itemBuilder: (_, i) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                content[i].image,
                width: 280,
                height: 280,
              ),
              const SizedBox(height: 20),
              Text(
                getLocalizedTitle(context, i),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                getLocalizedDescription(context, i),
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 45),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    content.length, (index) => buildDot(index, context)),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    S.of(context).makeAccountText,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/signin');
                    },
                    child: Text(
                      S.of(context).signInButton,
                      style: TextStyle(
                          fontWeight: FontWeight.w800, color: MyColors.skyBlue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 5,
      width: 5,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentindex == index
            ? MyColors.skyBlue
            : const Color.fromARGB(255, 129, 129, 129),
      ),
    );
  }
}
