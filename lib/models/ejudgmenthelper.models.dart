import 'package:identity_scanner/models/ejudgmentportalsearchresult.models.dart';
import 'package:identity_scanner/models/ejudgmentresponse.models.dart';
import 'package:identity_scanner/models/search_item.models.dart';

class EJudgmentHelper {
  static EJudgmentResponse createSampleResponse() {
    return EJudgmentResponse(
      data: EJudgmentPortalSearchResult(
        type: 'EJudgmentWeb.BO.eJudgmentPortalSearchListResult',
        listOfSearchItem: [],
        recsPerPage: 20,
        totalRecord: 0,
        totalPage: 1,
      ),
    );
  }

  static List<SearchItem> searchByKeyword(
    List<SearchItem> items,
    String keyword,
  ) {
    final lowerKeyword = keyword.toLowerCase();
    return items
        .where(
          (item) =>
              item.keyWord.toLowerCase().contains(lowerKeyword) ||
              item.cleanParties.toLowerCase().contains(lowerKeyword) ||
              item.cleanCaseNo.toLowerCase().contains(lowerKeyword),
        )
        .toList();
  }
}
