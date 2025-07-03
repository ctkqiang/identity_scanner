import 'package:identity_scanner/models/search_item.models.dart';

class EJudgmentPortalSearchResult {
  final String type;
  final List<SearchItem> listOfSearchItem;
  final int recsPerPage;
  final int totalRecord;
  final int totalPage;

  const EJudgmentPortalSearchResult({
    required this.type,
    required this.listOfSearchItem,
    required this.recsPerPage,
    required this.totalRecord,
    required this.totalPage,
  });

  factory EJudgmentPortalSearchResult.fromJson(Map<String, dynamic> json) {
    return EJudgmentPortalSearchResult(
      type: json['__type'] ?? '',
      listOfSearchItem:
          (json['ListOfSearchItem'] as List<dynamic>?)
              ?.map((item) => SearchItem.fromJson(item))
              .toList() ??
          [],
      recsPerPage: json['RECS_PER_PAGE'] ?? 0,
      totalRecord: json['TOTAL_RECORD'] ?? 0,
      totalPage: json['TOTAL_PAGE'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '__type': type,
      'ListOfSearchItem': listOfSearchItem
          .map((item) => item.toJson())
          .toList(),
      'RECS_PER_PAGE': recsPerPage,
      'TOTAL_RECORD': totalRecord,
      'TOTAL_PAGE': totalPage,
    };
  }

  /// Get cases by court level - filter like a boss! 🎯
  List<SearchItem> getCasesByCourtLevel(String courtLevel) {
    return listOfSearchItem
        .where((item) => item.courtLevel == courtLevel)
        .toList();
  }

  /// Get defamation cases only
  List<SearchItem> get defamationCases =>
      listOfSearchItem.where((item) => item.isDefamationCase).toList();

  /// Get corruption cases only
  List<SearchItem> get corruptionCases =>
      listOfSearchItem.where((item) => item.isCorruptionCase).toList();

  @override
  String toString() {
    return 'EJudgmentPortalSearchResult(totalRecord: $totalRecord, totalPage: $totalPage, itemCount: ${listOfSearchItem.length})';
  }
}
