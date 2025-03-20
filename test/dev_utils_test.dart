import 'package:flutter_test/flutter_test.dart';
import 'package:dev_utils/dev_utils.dart';
import 'package:dev_utils/dev_utils_platform_interface.dart';
import 'package:dev_utils/dev_utils_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNbUtilsPlatform
    with MockPlatformInterfaceMixin
    implements NbUtilsPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NbUtilsPlatform initialPlatform = NbUtilsPlatform.instance;

  test('$MethodChannelNbUtils is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNbUtils>());
  });

  test('getPlatformVersion', () async {
    NbUtils DevUtilsPlugin = NbUtils();
    MockNbUtilsPlatform fakePlatform = MockNbUtilsPlatform();
    NbUtilsPlatform.instance = fakePlatform;

    expect(await DevUtilsPlugin.getPlatformVersion(), '42');
  });
}
