import 'package:flutter/material.dart';

class AppPageRoute<T> extends PageRouteBuilder<T> {
  AppPageRoute({required WidgetBuilder builder})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionDuration: const Duration(milliseconds: 320),
          reverseTransitionDuration: const Duration(milliseconds: 260),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curve = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
            final offsetTween = Tween<Offset>(begin: const Offset(0.0, 0.04), end: Offset.zero);
            return FadeTransition(
              opacity: curve,
              child: SlideTransition(position: offsetTween.animate(curve), child: child),
            );
          },
        );
}
