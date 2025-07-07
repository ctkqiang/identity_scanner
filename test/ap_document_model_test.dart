import 'package:flutter_test/flutter_test.dart';
import 'package:identity_scanner/models/ap_document.model.dart';

void main() {
  group('APDocument', () {
    test('fromJson creates a valid APDocument object', () {
      final Map<String, dynamic> json = {
        'eJudgUniqueID': 'unique123',
        'DocumentID': 'doc456',
        'APDocName': 'Test Document',
        'APDocSeq': 1,
        'APPreparedBy': 'Developer',
        'IsExpunged': false,
        'DecisionCategory': 'Civil',
      };

      final apDocument = APDocument.fromJson(json);

      expect(apDocument.eJudgUniqueID, 'unique123');
      expect(apDocument.documentID, 'doc456');
      expect(apDocument.apDocName, 'Test Document');
      expect(apDocument.apDocSeq, 1);
      expect(apDocument.apPreparedBy, 'Developer');
      expect(apDocument.isExpunged, false);
      expect(apDocument.decisionCategory, 'Civil');
    });

    test('fromJson handles null or missing values gracefully', () {
      final Map<String, dynamic> json = {
        'DocumentID': null,
        'APDocName': null,
        'APDocSeq': null,
        'APPreparedBy': null,
        'IsExpunged': null,
        'DecisionCategory': null,
      };

      final apDocument = APDocument.fromJson(json);

      expect(apDocument.eJudgUniqueID, isNull);
      expect(apDocument.documentID, '');
      expect(apDocument.apDocName, '');
      expect(apDocument.apDocSeq, 0);
      expect(apDocument.apPreparedBy, '');
      expect(apDocument.isExpunged, false);
      expect(apDocument.decisionCategory, '');
    });

    test('toJson converts APDocument object to a valid JSON map', () {
      const apDocument = APDocument(
        eJudgUniqueID: 'unique123',
        documentID: 'doc456',
        apDocName: 'Test Document',
        apDocSeq: 1,
        apPreparedBy: 'Developer',
        isExpunged: false,
        decisionCategory: 'Civil',
      );

      final json = apDocument.toJson();

      expect(json['eJudgUniqueID'], 'unique123');
      expect(json['DocumentID'], 'doc456');
      expect(json['APDocName'], 'Test Document');
      expect(json['APDocSeq'], 1);
      expect(json['APPreparedBy'], 'Developer');
      expect(json['IsExpunged'], false);
      expect(json['DecisionCategory'], 'Civil');
    });

    test('toString returns a correct string representation', () {
      const apDocument = APDocument(
        documentID: 'doc456',
        apDocName: 'Test Document',
        apDocSeq: 1,
        apPreparedBy: 'Developer',
        isExpunged: false,
        decisionCategory: 'Civil',
      );

      expect(
        apDocument.toString(),
        'APDocument(documentID: doc456, apDocName: Test Document, decisionCategory: Civil)',
      );
    });
  });
}
