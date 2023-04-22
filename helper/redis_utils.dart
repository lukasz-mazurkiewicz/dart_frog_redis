// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types, avoid_dynamic_calls

import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dotenv/dotenv.dart';
import 'package:redis/redis.dart';

import 'university.dart';

String score = 'score';

class RedisUtils {
  final env = DotEnv(includePlatformEnvironment: true)..load();

  final connection = RedisConnection();

  String? toRedisKey(String s) {
    final key = s.toLowerCase().replaceAll(' ', '_');

    return 'university:$key';
  }

  Future<void> addInitialData() async {
    await connection.connect(env['IP'], int.parse(env['PORT']!)).then((Command command) {
      for (final university in universityList) {
        final key = RedisUtils().toRedisKey(university.name!);
        final data = [
          'name',
          university.name,
          'type',
          university.type,
          'score',
          university.score,
          'miasto',
          university.miasto,
        ];
        command.send_object(['HMSET', key, ...data]).then((response) {});
      }
    });
    await saveData();
  }

  Future<void> incrementScore(String? universityName) async {
    if (universityName != null) {
      await connection.connect(env['IP'], int.parse(env['PORT']!)).then((Command command) async {
        final key = 'university:$universityName';
        await command.send_object(['HINCRBY', key, score, '1']);
      });
    }
    await saveData();
  }

  Future<void> updateUniversityType(String? universityName, String? newType) async {
    if (universityName != null && newType != null) {
      await connection.connect(env['IP'], int.parse(env['PORT']!)).then((Command command) async {
        final key = 'university:$universityName';
        await command.send_object(['HSET', key, 'type', newType]);
      });
    }
    await saveData();
  }

  Future<void> updateCity(String? universityName, String? miasto) async {
    if (universityName != null && miasto != null) {
      await connection.connect(env['IP'], int.parse(env['PORT']!)).then((Command command) async {
        final key = 'university:$universityName';
        await command.send_object(['HSET', key, 'miasto', miasto]);
      });
    }
    await saveData();
  }

  Future<Response> getUniversities(RequestContext context) async {
    final List<University> universities = [];

    await connection.connect(env['IP'], int.parse(env['PORT']!)).then((Command command) async {
      final keysResponse = await command.send_object(['KEYS', 'university:*']);
      final keys = (keysResponse as List<dynamic>).cast<String>();
      for (final key in keys) {
        final data = await command.send_object(['HGETALL', key]);

        final university = University(
          name: data[1] as String?,
          type: data[3] as String?,
          score: int.tryParse(data[5] as String),
          miasto: data[7] as String?,
        );
        universities.add(university);
      }
    });
    final json = jsonEncode(universities);
    return Response(body: json, headers: {'Content-Type': 'application/json'});
  }

  Future<bool> checkIfKeysExists() async {
    final connection = RedisConnection();
    bool hasKeys = false;

    await connection.connect(env['IP'], int.parse(env['PORT']!)).then((Command command) async {
      final keysResponse = await command.send_object(['KEYS', 'university:*']) as List;
      if (keysResponse.isNotEmpty) {
        hasKeys = true;
      }
    });
    return hasKeys;
  }

  Future<void> saveData() async {
    final connection = RedisConnection();
    await connection.connect(env['IP'], int.parse(env['PORT']!)).then((Command command) async {
      await command.send_object(['BGSAVE']);
    });
  }
}
