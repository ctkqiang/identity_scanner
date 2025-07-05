import 'package:identity_scanner/models/ejudgmentresponse.models.dart';
import 'package:identity_scanner/models/scanner_annotation.dart';

abstract class EJusgementLogic {
  @IdentityScanner(description: 'getEJudgmentPortalSearchList', param: 1)
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
  });

  @IdentityScanner(description: 'openCaseDocument', param: 1)
  String openCaseDocument(String documentId);
}
