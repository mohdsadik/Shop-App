import 'package:flutter/material.dart';
import 'products_overview_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => ProductsOverviewScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(
          'https://media.tenor.com/IL19yJpm-dcAAAAi/shop-shopping.gif'),
    );
  }
}
