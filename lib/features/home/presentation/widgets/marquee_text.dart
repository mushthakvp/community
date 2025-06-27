import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../providers/home_provider.dart';

class MarqueeText extends StatelessWidget {
  const MarqueeText({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        final marqueeText = provider.userDetails?.marquee;
        if (marqueeText == null || marqueeText.isEmpty) {
          return const SizedBox.shrink();
        }
        return Container(
          width: double.infinity,
          height: 45,
          margin: const EdgeInsets.only(top: 20, bottom: 10),
          decoration: BoxDecoration(
            color: AppConstants.appPrimaryColor,
            boxShadow: [
              BoxShadow(
                color: AppConstants.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 45,
                decoration: BoxDecoration(
                  color: AppConstants.black.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.campaign_outlined,
                  color: AppConstants.black,
                  size: 20,
                ),
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: 45,
                    child: Marquee(
                      text: marqueeText,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppConstants.black,
                        fontSize: 14,
                        height: 1.2,
                      ),
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      blankSpace: 50.0,
                      velocity: 80.0,
                      pauseAfterRound: const Duration(seconds: 2),
                      startPadding: 20.0,
                      accelerationDuration: const Duration(seconds: 1),
                      accelerationCurve: Curves.linear,
                      decelerationDuration: const Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeOut,
                      showFadingOnlyWhenScrolling: false,
                      fadingEdgeStartFraction: 0.1,
                      fadingEdgeEndFraction: 0.1,
                    ),
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 45,
                decoration: BoxDecoration(
                  color: AppConstants.black.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: AppConstants.black,
                  size: 20,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
