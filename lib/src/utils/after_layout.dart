import 'package:flutter/material.dart';
import 'package:dev_utils/dev_utils.dart';

/// Callback after build widget is rendered
@Deprecated('Use afterBuildCreated() instead')
mixin AfterLayoutMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    makeNullable(WidgetsBinding.instance)!
        .addPostFrameCallback((_) => afterFirstLayout(context));
  }

  void afterFirstLayout(BuildContext context);

  @override
  void dispose() {
    super.dispose();
  }
}
