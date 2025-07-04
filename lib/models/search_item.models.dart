import 'package:identity_scanner/models/ap_document.model.dart';

class SearchItem {
  final String no;
  final String caseNo; // Contains HTML formatting with court level
  final String parties; // Contains HTML formatted party information
  final String keyWord; // Case summary and legal keywords
  final String dateOfAP; // Date as JSON format string
  final String dateOfResult; // Date as JSON format string
  final String judge; // Primary judge name
  final String corumJudge; // Panel of judges (HTML formatted)
  final String eJudgUniqueID; // Unique identifier for the case
  final List<APDocument> listOfAPDoc; // Associated judgment documents

  const SearchItem({
    required this.no,
    required this.caseNo,
    required this.parties,
    required this.keyWord,
    required this.dateOfAP,
    required this.dateOfResult,
    required this.judge,
    required this.corumJudge,
    required this.eJudgUniqueID,
    required this.listOfAPDoc,
  });

  factory SearchItem.fromJson(Map<String, dynamic> json) {
    return SearchItem(
      no: json['No'] ?? '',
      caseNo: json['CaseNo'] ?? '',
      parties: json['Parties'] ?? '',
      keyWord: json['KeyWord'] ?? '',
      dateOfAP: json['DateOfAP'] ?? '',
      dateOfResult: json['DateOfResult'] ?? '',
      judge: json['Judge'] ?? '',
      corumJudge: json['CorumJudge'] ?? '',
      eJudgUniqueID: json['eJudgUniqueID'] ?? '',
      listOfAPDoc:
          (json['ListOfAPDoc'] as List<dynamic>?)
              ?.map((doc) => APDocument.fromJson(doc))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'No': no,
      'CaseNo': caseNo,
      'Parties': parties,
      'KeyWord': keyWord,
      'DateOfAP': dateOfAP,
      'DateOfResult': dateOfResult,
      'Judge': judge,
      'CorumJudge': corumJudge,
      'eJudgUniqueID': eJudgUniqueID,
      'ListOfAPDoc': listOfAPDoc.map((doc) => doc.toJson()).toList(),
    };
  }

  DateTime? get parsedDateOfAP => _parseJsonDate(dateOfAP);
  DateTime? get parsedDateOfResult => _parseJsonDate(dateOfResult);

  /// Extract court level from case number - regex magic ✨
  String get courtLevel {
    if (caseNo.contains('Mahkamah Tinggi')) return 'Mahkamah Tinggi';
    if (caseNo.contains('Mahkamah Rayuan')) return 'Mahkamah Rayuan';
    if (caseNo.contains('Mahkamah Persekutuan')) return 'Mahkamah Persekutuan';
    if (caseNo.contains('Mahkamah Sesyen')) return 'Mahkamah Sesyen';
    return 'Unknown';
  }

  /// Check if this is a defamation case - pattern matching FTW! 🎯
  bool get isDefamationCase => keyWord.toLowerCase().contains('defamation');

  /// Check if this is a corruption case
  bool get isCorruptionCase =>
      keyWord.toLowerCase().contains('corruption') ||
      keyWord.toLowerCase().contains('rasuah') ||
      keyWord.toLowerCase().contains('sprm');

  static DateTime? _parseJsonDate(String dateString) {
    try {
      // Extract timestamp from JSON date format like "/Date(1748244837000)/"
      final regex = RegExp(r'\/Date\((\d+)\)\/');
      final match = regex.firstMatch(dateString);
      if (match != null) {
        final timestamp = int.parse(match.group(1)!);
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
    } catch (e) {
      // If parsing fails, return null
    }
    return null;
  }

  @override
  String toString() {
    return 'SearchItem(no: $no, caseNo: $caseNo, judge: $judge, courtLevel: $courtLevel)';
  }
}
