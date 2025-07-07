import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final FlutterToggleTab tabBar;

  StickyTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.height!;

  @override
  double get maxExtent => tabBar.height!;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.black, child: tabBar);
  }

  @override
  bool shouldRebuild(StickyTabBarDelegate oldDelegate) {
    return true;
  }
}
