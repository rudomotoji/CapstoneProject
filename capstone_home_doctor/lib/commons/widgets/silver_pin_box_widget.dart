import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverPinnedBoxAdapter extends SingleChildRenderObjectWidget {
  const SliverPinnedBoxAdapter({
    Key key,
    Widget child,
    this.pinned = true,
  }) : super(key: key, child: child);

  final bool pinned;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderSliverPinnedBoxAdapter(pinned: pinned);
}

class _RenderSliverPinnedBoxAdapter extends RenderSliverSingleBoxAdapter {
  _RenderSliverPinnedBoxAdapter({RenderBox child, @required this.pinned})
      : super(child: child);

  /// If true, ✅ should stay pinned at the top of the list,
  /// ✅ but move back into it's original position when scrolling down
  ///
  /// If false, ✅ should move out of the list, ❌ but move back into it's original position
  /// when scrolling down
  ///
  /// ❌ You should be able to place a `pinned = false` sliver above a `pinned = true` sliver
  /// and have them never overlap
  ///
  /// ❌ Should not react to overscrolling on iOS
  final bool pinned;
  // double lastUpwardScrollOffset = 0;

  double previousScrollOffset = 0;
  double ratchetingScrollDistance = 0;

  @override
  void performLayout() {
    child.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    double childExtent = child.size.height;
    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);

    final dy = previousScrollOffset - constraints.scrollOffset;
    previousScrollOffset = constraints.scrollOffset;

    ratchetingScrollDistance =
        (ratchetingScrollDistance + dy).clamp(0.0, childExtent);

    if (pinned) {
      print(ratchetingScrollDistance);
    }

    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
      paintOrigin: pinned
          ? constraints.scrollOffset
          : max(
              0,
              constraints.scrollOffset - childExtent + ratchetingScrollDistance,
            ),
      visible: true,
    );

    setChildParentData(child, constraints, geometry);
  }
}
