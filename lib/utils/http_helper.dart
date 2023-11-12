import 'dart:collection';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:hotels_go/localizations/locale_keys.g.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:hotels_go/data/models/api_response.dart';
import 'package:hotels_go/utils/constants.dart';
import 'package:isolated_worker/js_isolated_worker.dart';
import 'connectivity_helper.dart';

final _noConnectionResponse = ApiResponse(message: LocaleKeys.noInternetConnection.tr().toUpperCase());
final _httpClient = http.Client();

class HttpHelper {
  static Future<ApiResponse> get(String path) async {

    /// For Web platform i use isolated worker to support concurrency/multithreading
    if(kIsWeb) {
      await JsIsolatedWorker().importScripts(['obfuscated_http_client.js']);
      final response =  await JsIsolatedWorker().run(
        functionName: 'get',
        arguments: "${ConstantStrings.baseApiUrl}$path",
      ) as LinkedHashMap<dynamic, dynamic>;
      final map = response.map((a, b) => MapEntry(a as String, b));
      return ApiResponse(
        message: LocaleKeys.dataRetrieved.tr(),
        data: map['jsonResponse']
      );
    }

    final isOnline = await ConnectivityHelper.check;

    if (!isOnline) {
      return _noConnectionResponse;
    }

    return await compute(httpGet, path);
  }
}

/// The API call function must be a top level function
/// to support concurrency/multithreading on mobile using compute()

Future<ApiResponse> httpGet(String path) async {
  try {
    final response = await _httpClient.get(
        Uri.parse("${ConstantStrings.baseApiUrl}$path"));

    return ApiResponse(
      message: LocaleKeys.dataRetrieved.tr(),
      data: jsonDecode(response.body)
    );
  } catch (e) {
    return ApiResponse(message: '$e');
  }
}