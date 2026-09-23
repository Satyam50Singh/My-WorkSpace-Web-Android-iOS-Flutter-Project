import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:my_worksphere_web/core/network/api_endpoints.dart';

enum Flavor { uat, prod }

class AppConfig {
  static const _channel = MethodChannel('com.example.my_worksphere_web/env');

  static Flavor _flavor = Flavor.uat;

  /// Returns the current active flavor.
  static Flavor get currentFlavor => _flavor;

  /// Returns true if current environment is production.
  static bool get isProd => _flavor == Flavor.prod;

  /// Returns true if current environment is UAT.
  static bool get isUat => _flavor == Flavor.uat;

  Future<void> configureAppFlavor() async {
    try {
      final String? env = await _channel.invokeMethod<String>('getEnvironment');
      debugPrint('Environment from native channel: $env');
      if (env != null && env.isNotEmpty) {
        setEnvironment(env);
      } else {
        setEnvironment('uat');
      }
    } catch (e) {
      debugPrint('Failed to get environment from native channel: $e. Falling back to UAT.');
      setEnvironment('uat');
    }
  }

  static void setEnvironment(String env) {
    switch (env.trim().toLowerCase()) {
      case 'prod':
      case 'production':
        setFlavor(Flavor.prod);
        break;
      case 'uat':
      default:
        setFlavor(Flavor.uat);
        break;
    }
  }

  static void setFlavor(Flavor flavor) {
    _flavor = flavor;
    switch (flavor) {
      case Flavor.prod:
        ApiEndpoints.baseUrl = ApiEndpoints.baseProdUrl;
        break;
      case Flavor.uat:
        ApiEndpoints.baseUrl = ApiEndpoints.baseUatUrl;
        break;
    }
    debugPrint('Configured Flavor: $_flavor, Base URL: ${ApiEndpoints.baseUrl}');
  }
}
