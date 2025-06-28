// lib/core/widgets/common/app_bar.dart - FIXED
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_constants.dart';
import '../../constants/route_constants.dart';
import 'text_widget.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool? centerTitle;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.centerTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: CommonTextWidget(
        text: title,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: foregroundColor ?? AppConstants.white,
      ),
      backgroundColor: backgroundColor ?? AppConstants.black,
      foregroundColor: foregroundColor ?? AppConstants.white,
      elevation: elevation ?? 0,
      centerTitle: centerTitle ?? true,
      leading:
          leading ??
          (showBackButton
              ? IconButton(
                  onPressed: () {
                    // FIXED: Handle back button properly
                    if (title == "Create Account") {
                      context.go(RouteConstants.login);
                    } else if (Navigator.canPop(context)) {
                      context.pop();
                    } else {
                      if (title == "Verify OTP") {
                        context.go(RouteConstants.login);
                      } else {
                        context.go(RouteConstants.home);
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: AppConstants.white,
                  ),
                )
              : null),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
