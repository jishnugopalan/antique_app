import 'package:antique_app/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.deepPurple,
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const HeadingText(
                text: "Register As",
                align: TextAlign.left,
                color: Colors.white),
            const SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                dev.log("Customer");
                Navigator.pushNamed(context, '/customer_registration');
              },
              child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  width: 100,
                  height: 100,
                  child: const Icon(
                    Icons.account_circle_sharp,
                    size: 80,
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            const SubHeadingText(
                text: "Customer", align: TextAlign.left, color: Colors.white),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                dev.log("Shops");
                Navigator.pushNamed(context, '/shop_registration');
              },
              child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  width: 100,
                  height: 100,
                  child: const Icon(
                    Icons.shop_2,
                    size: 80,
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            const SubHeadingText(
                text: "Shops", align: TextAlign.left, color: Colors.white)
          ]),
        ),
      ),
    );
  }
}
