import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:identity_scanner/business_logic/ejudgement_bl.dart';
import 'package:identity_scanner/models/ejudgmentresponse.models.dart';

class EjudementService extends EJusgementLogic {
  // 私有构造函数
  EjudementService._();

  // 单例实例
  static final EjudementService _instance = EjudementService._();

  // 工厂构造函数，返回单例实例
  factory EjudementService() => _instance;

  static const String baseUrl = 'https://ejudgment.kehakiman.gov.my';
  static const String searchEndpoint =
      '/EJudgmentWeb/eJudgmentService.asmx/GetEJudgmentPortalSearchList';

  /// 获取eJudgment门户搜索列表
  ///
  /// 参数说明：
  /// - [search] 搜索关键词，例如人名 "LIM GUAN ENG"
  /// - [jurisdictionType] 管辖类型，默认为 "ALL"
  /// - [courtCategory] 法院类别，默认为空字符串
  /// - [court] 法院，默认为空字符串
  /// - [judgeName] 法官姓名，默认为空字符串
  /// - [caseType] 案件类型，默认为空字符串
  /// - [dateOfAPFrom] 申请日期起始，默认为null
  /// - [dateOfAPTo] 申请日期截止，默认为null
  /// - [dateOfResultFrom] 结果日期起始，默认为null
  /// - [dateOfResultTo] 结果日期截止，默认为null
  /// - [currPage] 当前页码，默认为1
  /// - [ordering] 排序方式，默认为 "DATE_OF_AP_DESC"
  /// - [maxRetries] 最大重试次数，默认为3
  /// - [delayBetweenRetries] 重试间隔时间（毫秒），默认为2000
  @override
  Future<EJudgmentResponse> getEJudgmentPortalSearchList({
    required String search,
    String jurisdictionType = 'ALL',
    String courtCategory = '',
    String court = '',
    String judgeName = '',
    String caseType = '',
    String? dateOfAPFrom,
    String? dateOfAPTo,
    String? dateOfResultFrom,
    String? dateOfResultTo,
    int currPage = 1,
    String ordering = 'DATE_OF_AP_DESC',
    int maxRetries = 3,
    int delayBetweenRetries = 3000,
  }) async {
    final url = Uri.parse('$baseUrl$searchEndpoint');

    final Map<String, dynamic> paramData = {
      "Param": {
        "CourtCategory": courtCategory,
        "Court": court,
        "JurisdictionType": jurisdictionType,
        "DateOfAPFrom": dateOfAPFrom,
        "DateOfAPTo": dateOfAPTo,
        "DateOfResultFrom": dateOfResultFrom,
        "DateOfResultTo": dateOfResultTo,
        "Search": search,
        "JudgeName": judgeName,
        "CaseType": caseType,
        "CurrPage": currPage,
        "Ordering": ordering,
      },
    };

    // 设置请求头
    final Map<String, String> headers = {
      'Accept': 'application/json, text/javascript, */*; q=0.01',
      'Accept-Language': 'zh-CN,zh;q=0.9',
      'Content-Type': 'application/json; charset=UTF-8',
      'Origin': baseUrl,
      'Referer':
          '$baseUrl/ejudgmentweb/searchpage.aspx?JurisdictionType=$jurisdictionType',
      'User-Agent':
          'Mozilla/5.0 (Linux; Android 13; SM-S908B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Mobile Safari/537.36',
      'X-Requested-With': 'XMLHttpRequest',
    };

    // 实现带重试机制的请求
    return _sendRequestWithRetry(
      url: url,
      headers: headers,
      body: jsonEncode(paramData),
      maxRetries: maxRetries,
      delayBetweenRetries: delayBetweenRetries,
    );
  }

  /// 带重试机制的请求发送方法
  ///
  /// 参数说明：
  /// - [url] 请求URL
  /// - [headers] 请求头
  /// - [body] 请求体
  /// - [maxRetries] 最大重试次数
  /// - [delayBetweenRetries] 重试间隔（毫秒）
  Future<EJudgmentResponse> _sendRequestWithRetry({
    required Uri url,
    required Map<String, String> headers,
    required String body,
    required int maxRetries,
    required int delayBetweenRetries,
  }) async {
    int attempts = 0;
    Exception? lastException;

    while (attempts < maxRetries) {
      try {
        // 发送POST请求
        final response = await http.post(url, headers: headers, body: body);

        // 检查响应状态
        if (response.statusCode == 200) {
          // 解析响应数据
          return EJudgmentResponse.fromJsonString(response.body);
        } else if (response.statusCode >= 500) {
          // 服务器错误，等待后重试
          lastException = Exception(
            '服务器错误，状态码: ${response.statusCode}，响应内容: ${response.body}，尝试重试...',
          );
          if (kDebugMode) {
            print('请求失败(尝试 ${attempts + 1}/$maxRetries): $lastException');
          }
        } else {
          // 其他错误，直接抛出异常
          throw Exception(
            '请求失败，状态码: ${response.statusCode}，响应内容: ${response.body}',
          );
        }
      } catch (e) {
        // 捕获网络异常
        lastException = Exception('请求异常: $e');
        if (kDebugMode) {
          print('请求异常(尝试 ${attempts + 1}/$maxRetries): $e');
        }
      }

      // 增加尝试次数
      attempts++;

      // 如果还有重试机会，则等待指定时间后重试
      if (attempts < maxRetries) {
        await Future.delayed(Duration(milliseconds: delayBetweenRetries));
      }
    }

    // 所有重试都失败，抛出最后一个异常
    throw lastException ?? Exception('请求失败，已达到最大重试次数');
  }

  /// 使用Dio库的替代实现（可选）
  /// 如果需要更高级的功能，如请求取消、拦截器等，可以使用此方法
  static Future<EJudgmentResponse> getEJudgmentPortalSearchListWithDio({
    required String search,
    String jurisdictionType = 'ALL',
    // ... 其他参数与上面相同
  }) async {
    // 此处实现Dio版本的请求
    // 如果需要，可以在后续添加
    throw UnimplementedError('Dio实现尚未完成');
  }

  @override
  String openCaseDocument(String documentId) {
    return "https://efs.kehakiman.gov.my/EFSWeb/DocDownloader.aspx?DocumentID=$documentId&Inline=true";
  }
}
