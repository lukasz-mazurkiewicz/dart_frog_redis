import 'package:dart_frog/dart_frog.dart';

import '../helper/redis_utils.dart';

Future<Response> onRequest(RequestContext context) async {
  return RedisUtils().getUniversities(context);
}
