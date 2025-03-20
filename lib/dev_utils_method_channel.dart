import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dev_utils_platform_interface.dart';

/// An implementation of [NbUtilsPlatform] that uses method channels.
class MethodChannelNbUtils extends NbUtilsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dev_utils');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
