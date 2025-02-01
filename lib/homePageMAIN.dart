import 'package:flutter/material.dart';
import 'package:ingleswebsite/homePage.dart';
import 'package:ingleswebsite/homePage2.dart';

class homePageMAIN extends StatelessWidget {
  const homePageMAIN({super.key});

   @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (contexto, constraints) {
      return Scaffold(
        body: constraints.maxWidth > 1000
            ?  PreferredSize(
                preferredSize: Size(double.infinity, 72),
                child: HomePage(),
              )
            : PreferredSize(
                preferredSize: Size(double.infinity, 56),
                child: HomePage2()),
      );
    });
  }
}