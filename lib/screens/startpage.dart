import 'package:flutter/material.dart';

class GettingStarted extends StatelessWidget {
  const GettingStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF339F74),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // const SizedBox(height: 60),
            const Text(
              "Welcome to Festival Hub!",
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/gettingStarted.png"),
                ),
              ),
            ),
            // const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                textAlign: TextAlign.center,
                "With Festival Hub, you can explore a world of festivals right at your fingertips. From discovering upcoming events and creating personalized schedules to connecting with friends and navigating festival grounds with ease, we’ve got everything you need to make the most of every festival.",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed('homePage');
              },
              child: Container(
                margin: const EdgeInsets.all(20),
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black38,
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Getting Started",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
