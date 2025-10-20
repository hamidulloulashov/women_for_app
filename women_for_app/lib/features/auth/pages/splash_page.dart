import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:women_for_app/core/utils/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
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

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      GoRouter.of(context).go("/login");
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
      backgroundColor: AppColors.greyShade,
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Ayol",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: AppColors.containerBlack,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Uchun",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w300,
                          color: AppColors.containerBlack,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
              
                  Positioned(
                    top: -40, 
                    right: 60, 
                    child: Image.asset(
                      "assets/splash_for.png",
                      width: 64,
                      height: 64,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 90),
                child: Text(
                  "ayollar uchun maxsus blog",
                  style: TextStyle(
                    fontSize: 8,
                    color: AppColors.containerBlack.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
