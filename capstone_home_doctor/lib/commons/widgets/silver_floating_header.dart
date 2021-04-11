import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SliverFloatingHeader extends SingleChildRenderObjectWidget {
  const SliverFloatingHeader({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  @override
  RenderSliverFloatingHeader createRenderObject(context) =>
      RenderSliverFloatingHeader();
}

class RenderSliverFloatingHeader extends RenderSliverSingleBoxAdapter {
  RenderSliverFloatingHeader({RenderBox child}) {
    this.child = child;
  }

  double _lastActualScrollOffset;
  double _effectiveScrollOffset = 0;
  double _childPosition;

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    child.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    final double maxExtent = childExtent;
    final double paintExtent = maxExtent - (_effectiveScrollOffset ?? 0.0);
    final double layoutExtent = maxExtent - constraints.scrollOffset;

    if (_lastActualScrollOffset != null &&
        (constraints.scrollOffset < _lastActualScrollOffset ||
            _effectiveScrollOffset < maxExtent)) {
      double delta = _lastActualScrollOffset - constraints.scrollOffset;
      final bool allowFloatingExpansion =
          constraints.userScrollDirection == ScrollDirection.forward;
      if (allowFloatingExpansion) {
        _effectiveScrollOffset = math.min(_effectiveScrollOffset, maxExtent);
      } else {
        delta = math.min(delta, 0);
      }
      _effectiveScrollOffset =
          (_effectiveScrollOffset - delta).clamp(0.0, constraints.scrollOffset);
    } else {
      _effectiveScrollOffset = constraints.scrollOffset;
    }
    excludeFromSemanticsScrolling =
        _effectiveScrollOffset <= constraints.scrollOffset;
    geometry = SliverGeometry(
      scrollExtent: maxExtent,
      paintOrigin: math.min(constraints.overlap, 0),
      paintExtent: paintExtent.clamp(0.0, constraints.remainingPaintExtent),
      layoutExtent: math.min(
        paintExtent.clamp(0.0, constraints.remainingPaintExtent),
        layoutExtent.clamp(0.0, constraints.remainingPaintExtent),
      ),
      maxPaintExtent: maxExtent,
      hasVisualOverflow: true,
    );
    _childPosition = math.min(0, paintExtent - childExtent);
    _lastActualScrollOffset = constraints.scrollOffset;
  }

  double get childExtent {
    if (child == null) {
      return 0;
    }
    assert(child.hasSize);
    assert(constraints.axis != null);
    switch (constraints.axis) {
      case Axis.vertical:
        return child.size.height;
      case Axis.horizontal:
        return child.size.width;
    }
    return null;
  }

  @override
  bool hitTestChildren(
    SliverHitTestResult result, {
    @required double mainAxisPosition,
    @required double crossAxisPosition,
  }) {
    assert(geometry.hitTestExtent > 0.0);

    return child != null &&
        hitTestBoxChild(
          BoxHitTestResult.wrap(result),
          child,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: crossAxisPosition,
        );
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    assert(child != null);
    assert(child == this.child);
    applyPaintTransformForBoxChild(child, transform);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null && geometry.visible) {
      assert(constraints.axisDirection != null);
      switch (applyGrowthDirectionToAxisDirection(
        constraints.axisDirection,
        constraints.growthDirection,
      )) {
        case AxisDirection.up:
          offset += Offset(
            0,
            geometry.paintExtent - childMainAxisPosition(child) - childExtent,
          );
          break;
        case AxisDirection.down:
          offset += Offset(0, childMainAxisPosition(child));
          break;
        case AxisDirection.left:
          offset += Offset(
            geometry.paintExtent - childMainAxisPosition(child) - childExtent,
            0,
          );
          break;
        case AxisDirection.right:
          offset += Offset(childMainAxisPosition(child), 0);
          break;
      }
      context.paintChild(child, offset);
    }
  }

  bool get excludeFromSemanticsScrolling => _excludeFromSemanticsScrolling;
  bool _excludeFromSemanticsScrolling = false;

  set excludeFromSemanticsScrolling(bool value) {
    if (_excludeFromSemanticsScrolling != value) {
      _excludeFromSemanticsScrolling = value;
      markNeedsSemanticsUpdate();
    }
  }

  @override
  double childMainAxisPosition(RenderBox child) {
    assert(child == this.child);
    return _childPosition;
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    if (_excludeFromSemanticsScrolling) {
      config.addTagForChildren(RenderViewport.excludeFromScrolling);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DoubleProperty('effective scroll offset', _effectiveScrollOffset),
      )
      ..add(
        DoubleProperty.lazy(
            'child position', () => childMainAxisPosition(child)),
      );
  }
}