import 'dart:async';
import 'package:dart_frog/dart_frog.dart';

import '../helper/redis_utils.dart';

Future<void> onRequest(RequestContext context) async {
  final params = context.request.uri.queryParameters;
  final universityName = params['universityName'];

  await RedisUtils().incrementScore(universityName);
}
