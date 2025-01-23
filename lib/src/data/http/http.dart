import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../domain/either.dart';
import 'verb.dart';

part 'failure.dart';
part 'parse_response_body.dart';
part 'print_log.dart';

class Http {
  final String _baseUrl;
  final String _apikey;
  final http.Client _client;

  Http(this._baseUrl, this._apikey, this._client);

  Future<Either<HttpFailure, R>> request<R>(
    HttpVerb httpVerb,
    String path, {
    required R Function(dynamic responseBody) onSuccess,
    Object? body = const {},
    Map<String, String> headers = const {},
    Map<String, String> queryParam = const {},
    bool useApiKey = false,
  }) async {
    Map<String, dynamic> logs = {};
    StackTrace? stackTrace;

    try {
      path = path.startsWith('http') ? path : '$_baseUrl$path';

      var uri = Uri.parse(path);

      if (useApiKey) {
        queryParam = {...queryParam};
      }

      headers = {
        'Content-Type': '	application/json;charset=utf-8',
        'Authorization': 'Bearer $_apikey',
        ...headers,
      };

      uri.replace(queryParameters: queryParam);

      logs = {
        'uri': uri.toString(),
        'headers': headers,
        'queryParam': queryParam,
        'body': body,
      };

      late http.Response response;
      body = jsonEncode(body);

      switch (httpVerb) {
        case HttpVerb.get:
          response = await _client.get(
            uri,
            headers: headers,
          );
        case HttpVerb.post:
          response = await _client.post(
            uri,
            body: body,
            headers: headers,
          );
        case HttpVerb.put:
          response = await _client.put(
            uri,
            body: body,
            headers: headers,
          );
        case HttpVerb.delete:
          response = await _client.delete(
            uri,
            body: body,
            headers: headers,
          );
      }

      logs = {
        ...logs,
        'response': _parseResponseBody(response.body),
        'statusCode': response.statusCode,
      };

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Either.right(
          onSuccess(
            _parseResponseBody(response.body),
          ),
        );
      }

      return Either.left(
        HttpFailure(
          statusCode: response.statusCode,
          exception: response,
        ),
      );
    } catch (e, s) {
      logs = {
        ...logs,
        'message': e.toString(),
        'exception': e.runtimeType.toString(),
      };
      stackTrace = s;

      if (e is SocketException || e is http.ClientException) {
        return Either.left(
          HttpFailure(
            exception: NetworkException(),
          ),
        );
      }

      return Either.left(
        HttpFailure(
          exception: e,
        ),
      );
    } finally {
      _printLog(logs, stackTrace);
    }
  }

  Future<Either<HttpFailure, R>> get<R>(
    String path, {
    required R Function(dynamic responseBody) onSuccess,
    Map<String, String> headers = const {},
    Map<String, String> queryParam = const {},
    bool useApiKey = true,
  }) async {
    return request(
      HttpVerb.get,
      path,
      useApiKey: useApiKey,
      headers: headers,
      queryParam: queryParam,
      onSuccess: onSuccess,
    );
  }

  Future<Either<HttpFailure, R>> post<R>(
    String path, {
    required R Function(dynamic responseBody) onSuccess,
    Map<String, String> body = const {},
    Map<String, String> headers = const {},
    Map<String, String> queryParam = const {},
    bool useApiKey = true,
  }) async {
    return request(
      HttpVerb.post,
      path,
      useApiKey: useApiKey,
      headers: headers,
      body: body,
      queryParam: queryParam,
      onSuccess: onSuccess,
    );
  }

  Future<Either<HttpFailure, R>> put<R>(
    String path, {
    required R Function(dynamic responseBody) onSuccess,
    Map<String, String> body = const {},
    Map<String, String> headers = const {},
    Map<String, String> queryParam = const {},
    bool useApiKey = true,
  }) async {
    return request(
      HttpVerb.put,
      path,
      useApiKey: useApiKey,
      headers: headers,
      body: body,
      queryParam: queryParam,
      onSuccess: onSuccess,
    );
  }

  Future<Either<HttpFailure, R>> delete<R>(
    String path, {
    required R Function(dynamic responseBody) onSuccess,
    Map<String, String> body = const {},
    Map<String, String> headers = const {},
    Map<String, String> queryParam = const {},
    bool useApiKey = true,
  }) async {
    return request(
      HttpVerb.delete,
      path,
      useApiKey: useApiKey,
      headers: headers,
      body: body,
      queryParam: queryParam,
      onSuccess: onSuccess,
    );
  }
}
