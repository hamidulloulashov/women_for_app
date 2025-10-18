import 'dart:async';
import 'package:flutter/material.dart';
import 'package:women_for_app/core/utils/app_colors.dart';
import 'package:women_for_app/features/auth/pages/login_page.dart';
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPage();
}

class _SplashPage extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Ayol",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, fontStyle: FontStyle.italic, color: AppColors.containerBlack),
                      ),
                    SizedBox(width: 5,),
                         Text(
                        "Uchun",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: AppColors.containerBlack),
                      ),

                    ],
                  ),
                     Text(
                        "ayollar uchun maxsus blog",
                        style: TextStyle(fontSize: 10, color: AppColors.containerBlack),
                      ),
            ],
          ),
        
        ),
      ),
    );
  }
}
