// ignore_for_file: lines_longer_than_80_chars, avoid_dynamic_calls

import 'dart:async';
import 'package:dart_frog/dart_frog.dart';
import '../helper/redis_utils.dart';

Future<Response> onRequest(RequestContext context) async {
  final hasKeys = await RedisUtils().checkIfKeysExists();
  if (hasKeys) {
    return Response(body: 'Ready');
  }
  await RedisUtils().addInitialData();
  return Response(body: 'Added initial data');
}
