
import 'package:dream_tracker/pages/signUp.dart';
import 'package:flutter/material.dart';
import 'package:introduction_slider/introduction_slider.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 20);
  @override
  Widget build(BuildContext context) {
    return IntroductionSlider(
      items: [
        IntroductionSliderItem(
          logo: Image.asset(
            'assets/images/3.png',
            height: 300,
          ),
          title: Text(
            "Worried about your Financial Management? We Got You!",
            style: textStyle,
            textAlign: TextAlign.center,
          ),
          backgroundColor: const Color(0xFF9747FF),
        ),
        IntroductionSliderItem(
          logo: Image.asset(
            'assets/images/2.png',
            height: 300,
          ),
          title: Text(
            "Step into a world of financial clarity and control. Let [App Name] be your trusted guide to a brighter financial future.",
            style: textStyle,
            textAlign: TextAlign.center,
          ),
          backgroundColor: const Color(0xFF9747FF),
        ),
        IntroductionSliderItem(
          logo: Image.asset(
            'assets/images/5.png',
            height: 300,
          ),
          title: Text(
            "Experience the joy of mindful spending. [App Name] helps you make informed choices, ensuring your money aligns with your dreams.",
            style: textStyle,
            textAlign: TextAlign.center,
          ),
          backgroundColor: const Color(0xFF9747FF),
        ),
        IntroductionSliderItem(
          logo: Image.asset(
            'assets/images/1.png',
            height: 300,
          ),
          title: Text(
            "Experience the joy of mindful spending. [App Name] helps you make informed choices, ensuring your money aligns with your dreams.",
            style: textStyle,
            textAlign: TextAlign.center,
          ),
          backgroundColor: const Color(0xFF9747FF),
        ),
      ],
      done: const Done(
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 30,
        ),
        home: LoginScreen(),
      ),
      dotIndicator: const DotIndicator(
        selectedColor: Colors.white,
        size: 9,
        unselectedColor: Colors.pink,
      ),
      next: Next(
        child: Text(
          'Next',
          style: textStyle,
        ),
      ),
      back: Back(
        child: Text(
          'Back',
          style: textStyle,
        ),
      ),
    );
  }
}
