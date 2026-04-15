// ignore_for_file: depend_on_referenced_packages, unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_constants.dart';

class ApiClient extends GetxService {
  static ApiClient get instance => Get.find<ApiClient>();
  static var client = http.Client();

  static String baseUrl = ApiConstant.BASE_URL;
  static SharedPreferences? _prefs;
  static final String noInternetMessage = 'connection_to_api_server_failed'.tr;
  static int timeoutInSeconds = 30;
  static String? token;
  static Map<String, String>? _mainHeaders;

  /// Reloads token from [SharedPreferences] and rebuilds [_mainHeaders].
  /// Call before every request — token is saved after OTP/login but the cache
  /// must refresh or `Authorization` stays `Bearer ` (empty).
  ///
  /// **No token:** omit `Authorization` entirely. Sending `Bearer ` (empty) breaks
  /// public routes (login, forgot-password, etc.) — many servers return 401
  /// `bad_authorization_header`.
  static Future<void> loadPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    final t = _prefs?.getString(AppConstants.TOKEN) ?? '';
    token = t;
    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      if (t.isNotEmpty) 'Authorization': 'Bearer $t',
    };
  }

  static Map<String, String> _resolveHeaders(Map<String, String>? override) {
    if (override == null || override.isEmpty) {
      return Map<String, String>.from(_mainHeaders!);
    }
    return {..._mainHeaders!, ...override};
  }

  static Uri _buildUri(String path, Map<String, dynamic>? query) {
    final base = Uri.parse(baseUrl + path);
    if (query == null || query.isEmpty) return base;
    final q = <String, String>{...base.queryParameters};
    for (final e in query.entries) {
      final v = e.value;
      if (v == null) continue;
      q[e.key] = v is String ? v : v.toString();
    }
    return base.replace(queryParameters: q);
  }

  static Future<Response> getData(
    String uri, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    try {
      await loadPrefs();
      final h = _resolveHeaders(headers);
      final requestUri = _buildUri(uri, query);
      debugPrint('====> API Call: $requestUri\nHeader: $h');
      http.Response response = await client
          .get(requestUri, headers: h)
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint('------------${e.toString()}');
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  static Future<Response> postData(
    String uri,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    try {
      await loadPrefs();
      final h = _resolveHeaders(headers);
      debugPrint(
        '====> API Call: $uri\nHeader: $h \nBody: $body',
      );
      http.Response response = await client
          .post(
            Uri.parse(baseUrl + uri),
            body: jsonEncode(body),
            headers: h,
          )
          .timeout(Duration(seconds: timeoutInSeconds));

      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  static Future<Response> patchData(
    String uri,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    try {
      await loadPrefs();
      final h = _resolveHeaders(headers);
      debugPrint(
        '====> API Call: PATCH $uri\nHeader: $h \nBody: $body',
      );
      http.Response response = await client
          .patch(
            Uri.parse(baseUrl + uri),
            body: jsonEncode(body),
            headers: h,
          )
          .timeout(Duration(seconds: timeoutInSeconds));

      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  /// PATCH with `application/x-www-form-urlencoded` — use when JSON PATCH returns 415 on
  /// some library routes (DRF parsers).
  static Future<Response> patchUrlEncoded(
    String uri,
    Map<String, String> body, {
    Map<String, String>? headers,
  }) async {
    try {
      await loadPrefs();
      final h = _resolveHeaders({
        'Content-Type': 'application/x-www-form-urlencoded',
        ...?headers,
      });
      final encoded = body.entries
          .map(
            (e) =>
                '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}',
          )
          .join('&');
      debugPrint(
        '====> API Call: PATCH $uri (urlencoded)\nHeader: $h \nBody: $encoded',
      );
      http.Response response = await client
          .patch(
            Uri.parse(baseUrl + uri),
            body: encoded,
            headers: h,
          )
          .timeout(Duration(seconds: timeoutInSeconds));

      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  static Future<Response> postMultipartData(
    String uri,
    Map<String, String> body, {
    required List<MultipartBody> multipartBody,
    Map<String, String>? headers,
  }) async {
    try {
      await loadPrefs();
      final h = _resolveHeaders(headers);
      debugPrint('====> API Call: $uri\nHeader: $h');
      debugPrint('====> API Body: $body with ${multipartBody.length} picture');

      var request = http.MultipartRequest('POST', Uri.parse(baseUrl + uri));
      request.headers.addAll(h);
      for (MultipartBody element in multipartBody) {
        request.files.add(
          await http.MultipartFile.fromPath(element.key, element.file.path),
        );
      }
      request.fields.addAll(body);
      http.Response response = await http.Response.fromStream(
        await request.send(),
      );
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> putData(
    String uri,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    try {
      await loadPrefs();
      final h = _resolveHeaders(headers);
      debugPrint('====> API Call: $uri\nHeader: $h');
      debugPrint('====> API Body: $body');
      http.Response response = await http
          .put(
            Uri.parse(baseUrl + uri),
            body: jsonEncode(body),
            headers: h,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  static Future<Response> putMultipartData(
    String uri,
    Map<String, String> body, {
    required List<MultipartBody> multipartBody,
    Map<String, String>? headers,
  }) async {
    try {
      await loadPrefs();
      final h = _resolveHeaders(headers);
      debugPrint('====> API Call: $uri\nHeader: $h');
      debugPrint('====> API Body: $body with ${multipartBody.length} picture');
      var request = http.MultipartRequest('PUT', Uri.parse(baseUrl + uri));
      request.headers.addAll(h);
      for (MultipartBody element in multipartBody) {
        request.files.add(
          await http.MultipartFile.fromPath(element.key, element.file.path),
        );
      }
      request.fields.addAll(body);
      http.Response response = await http.Response.fromStream(
        await request.send(),
      );
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  static Future<Response> patchMultipartData(
    String uri,
    Map<String, String> body, {
    required List<MultipartBody> multipartBody,
    Map<String, String>? headers,
  }) async {
    try {
      await loadPrefs();
      final h = _resolveHeaders(headers);
      debugPrint('====> API Call: PATCH $uri\nHeader: $h');
      debugPrint('====> API Body: $body with ${multipartBody.length} picture');
      var request = http.MultipartRequest('PATCH', Uri.parse(baseUrl + uri));
      request.headers.addAll(h);
      for (MultipartBody element in multipartBody) {
        request.files.add(
          await http.MultipartFile.fromPath(element.key, element.file.path),
        );
      }
      request.fields.addAll(body);
      http.Response response = await http.Response.fromStream(
        await request.send(),
      );
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  static Future<Response> deleteData(
    String uri, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      await loadPrefs();
      final h = _resolveHeaders(headers);
      debugPrint('====> API Call: $uri\nHeader: $h');
      debugPrint('====> API Call: $uri\n Body: $body');
      http.Response response = await http
          .delete(
            Uri.parse(baseUrl + uri),
            headers: h,
            body: body,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  static Response handleResponse(http.Response response, String uri) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      debugPrint(e.toString());
    }
    Response response0 = Response(
      body: body ?? response.body,
      bodyString: response.body.toString(),
      request: Request(
        headers: response.request!.headers,
        method: response.request!.method,
        url: response.request!.url,
      ),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );
    if (response0.statusCode != 200 &&
        response0.body != null &&
        response0.body is! String) {
      response0 = Response(
        statusCode: response0.statusCode,
        body: response0.body,
        statusText: response0.statusText,
      );
    } else if (response0.statusCode != 200 && response0.body == null) {
      response0 = Response(statusCode: 0, statusText: noInternetMessage);
    }
    debugPrint(
      '====> API Response: [${response0.statusCode}] $uri\n${response0.body}',
    );
    return response0;
  }
}

class MultipartBody {
  String key;
  File file;
  MultipartBody(this.key, this.file);
}
