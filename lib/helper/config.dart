import 'package:flutter/material.dart';
import 'package:money_manager_3/custom_painter.dart';

class AppConfig {
  static Color appBackgroundColor = Color.fromARGB(255, 18, 73, 128);
  static Color appTitleColor = Color(0xFF242C3B);

  static double headerFontSize = 30.0;
  static double alertTitleFontSize = 22.0;
  static double alertContentFontSize = 14.0;
  static double fontSize = 17.0;
  static Color fontColor = Colors.white;
  static Color buttonSelectedColor = Color.fromARGB(144, 23, 96, 156);
  // icon
  static double iconSize = 25;
  static double iconSizeSmall = iconSize * 0.8;
  static Color iconColor = fontColor;
  // error
  static Color errorFontColor = Colors.red;
  static double errorFontSize = 12.0;
  // padding
  static double paddingSmall = 5;
  static double padding = 10;
  static double paddingLarge = 15;
  static double paddingXLarge = 20;
  static double padding2XLarge = 25;
  // border
  static double borderRadius = 10;
  static Color borderColor = Colors.grey;
  static Color borderColor2 = Color.fromARGB(255, 22, 61, 101);
  static Color focusedBorderColor = buttonSelectedColor;
  static double borderWidth = 1.5;
  static BorderRadius borderRadiusAll =
      BorderRadius.all(Radius.circular(AppConfig.borderRadius));
  // popup
  static double popupRadius = borderRadius;
  static Color popupBKColor = Color.fromARGB(255, 18, 73, 128);
  // radio button
  static Color activeColor = Colors.white;
  // tool tip
  static Color tooltipBackgroundColor = Colors.blue.withOpacity(0.9);

  static TextStyle fontStyle =
      TextStyle(fontSize: AppConfig.fontSize, color: AppConfig.fontColor);
  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    padding: EdgeInsets.zero,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConfig.borderRadius),
    ),
  );
  static ButtonStyle elevatedButtonSelectedStyle = ElevatedButton.styleFrom(
    padding: EdgeInsets.zero,
    backgroundColor: buttonSelectedColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConfig.borderRadius),
    ),
  );

  // animate from right to left
  static Route slideRote(Widget component) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => component,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide from right
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  static Widget backgroundWrapper(BuildContext context, Widget child) {
    return Stack(
      children: [
        CustomPaint(
          size: Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height,
          ),
          painter: DiagonalPainter(),
        ),
        Padding(
          padding: EdgeInsets.all(AppConfig.padding),
          child: child,
        ),
      ],
    );
  }

  // Nested network config
  static _NetworkConfig network = _NetworkConfig();
}

class _NetworkConfig {
  // PROD
  // final String baseUrl = "https://us-central1-money-manager-18108.cloudfunctions.net/api";
  // DEV
  final String baseUrl = "https://api-sauq2g43rq-uc.a.run.app/";
}
