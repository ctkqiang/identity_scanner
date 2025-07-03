class APDocument {
  final String? eJudgUniqueID;
  final String documentID;
  final String apDocName;
  final int apDocSeq;
  final String apPreparedBy;
  final bool isExpunged;
  final String decisionCategory;

  const APDocument({
    this.eJudgUniqueID,
    required this.documentID,
    required this.apDocName,
    required this.apDocSeq,
    required this.apPreparedBy,
    required this.isExpunged,
    required this.decisionCategory,
  });

  factory APDocument.fromJson(Map<String, dynamic> json) {
    return APDocument(
      eJudgUniqueID: json['eJudgUniqueID'],
      documentID: json['DocumentID'] ?? '',
      apDocName: json['APDocName'] ?? '',
      apDocSeq: json['APDocSeq'] ?? 0,
      apPreparedBy: json['APPreparedBy'] ?? '',
      isExpunged: json['IsExpunged'] ?? false,
      decisionCategory: json['DecisionCategory'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eJudgUniqueID': eJudgUniqueID,
      'DocumentID': documentID,
      'APDocName': apDocName,
      'APDocSeq': apDocSeq,
      'APPreparedBy': apPreparedBy,
      'IsExpunged': isExpunged,
      'DecisionCategory': decisionCategory,
    };
  }

  @override
  String toString() {
    return 'APDocument(documentID: $documentID, apDocName: $apDocName, decisionCategory: $decisionCategory)';
  }
}
