import 'package:flutter_test/flutter_test.dart';

import 'package:identity_scanner/controller/get.controller.dart';
import 'package:identity_scanner/models/ejudgmentresponse.models.dart';

void main() {
  group('EjudgementService Integration Test', () {
    test(
      'returns valid EJudgmentResponse when search query is valid',
      () async {
        final service = EjudementService();

        final result = await service.getEJudgmentPortalSearchList(
          search: 'LIM GUAN ENG', // 📌 替换为你知道一定存在的关键字
          maxRetries: 1, // 🧪 避免卡太久
          delayBetweenRetries: 500,
        );

        expect(result, isA<EJudgmentResponse>());
        expect(result.data, isNotEmpty);
      },
    );

    test('throws Exception when search query is nonsense', () async {
      final service = EjudementService();

      expect(
        () => service.getEJudgmentPortalSearchList(
          search: 'XxX_NO_MATCH_FOUND_1234',
          maxRetries: 1,
          delayBetweenRetries: 500,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
