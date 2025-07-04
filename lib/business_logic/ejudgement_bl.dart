import 'package:identity_scanner/models/ejudgmentresponse.models.dart';

abstract class EJusgementLogic {
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

  String openCaseDocument(String documentId);
}
