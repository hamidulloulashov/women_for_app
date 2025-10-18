import 'package:flutter/material.dart';
import 'package:women_for_app/core/utils/app_colors.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    this.title,
    this.actions,
  });

  final Widget? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: SoyaClipper(),
              child: Container(
                height: preferredSize.height * 0.55,
                decoration: BoxDecoration(
                  color: AppColors.greyShade.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ClipPath(
            clipper: WaveClipper(offset: 0),
            child: Container(
              height: preferredSize.height,
              decoration: BoxDecoration(
                color: AppColors.primary,
              ),
            ),
          ),
          SafeArea(
            child: AppBar(
              title: title,
              backgroundColor: Colors.transparent,
              actions: actions,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(190);
}

class WaveClipper extends CustomClipper<Path> {
  final double offset;

  WaveClipper({this.offset = 0});

  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height - 80 - offset);

    var firstControlPoint = Offset(
      size.width * 0.25,
      size.height - 73 - offset,
    );
    var firstEndPoint = Offset(size.width * 0.5, size.height - 73 - offset);

    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(
      size.width * 0.75,
      size.height - 73 - offset,
    );
    var secondEndPoint = Offset(size.width, size.height - 80 - offset);

    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class SoyaClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height,
      size.width,
      size.height * 0.3,
    );
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
