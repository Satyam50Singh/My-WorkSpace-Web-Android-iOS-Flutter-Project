import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'BASE_UAT_URL', obfuscate: true)
  static final String baseUatUrl = _Env.baseUatUrl;

  @EnviedField(varName: 'BASE_PROD_URL', obfuscate: true)
  static final String baseProdUrl = _Env.baseProdUrl;
}
