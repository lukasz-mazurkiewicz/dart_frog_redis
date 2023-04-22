import 'package:dart_frog/dart_frog.dart';

import '../helper/redis_utils.dart';

Future<void> onRequest(RequestContext context) async {
  final params = context.request.uri.queryParameters;
  final universityName = params['universityName'];
  final city = params['miasto'];

  await RedisUtils().updateCity(universityName, city);
}
