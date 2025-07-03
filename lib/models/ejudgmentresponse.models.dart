import 'dart:convert';

import 'package:identity_scanner/models/ejudgmentportalsearchresult.models.dart';
import 'package:identity_scanner/models/search_item.models.dart';

class EJudgmentResponse {
  final EJudgmentPortalSearchResult data;

  const EJudgmentResponse({required this.data});

  factory EJudgmentResponse.fromJson(Map<String, dynamic> json) {
    return EJudgmentResponse(
      data: EJudgmentPortalSearchResult.fromJson(json['d'] ?? {}),
    );
  }

  /// Parse from JSON string - one-liner magic! ✨
  factory EJudgmentResponse.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return EJudgmentResponse.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {'d': data.toJson()};
  }

  /// Convert to JSON string
  String toJsonString() => jsonEncode(toJson());

  @override
  String toString() => 'EJudgmentResponse(data: $data)';
}

/// Utility enums for better type safety - because we're not savages! 💅

enum CourtLevel {
  mahkamahTinggi('Mahkamah Tinggi'),
  mahkamahRayuan('Mahkamah Rayuan'),
  mahkamahPersekutuan('Mahkamah Persekutuan'),
  mahkamahSesyen('Mahkamah Sesyen');

  const CourtLevel(this.displayName);
  final String displayName;
}

enum PartyRole {
  pemohon('PEMOHON'),
  responden('RESPONDEN'),
  plaintiff('PLAINTIFF'),
  defendant('DEFENDANT'),
  perayu('PERAYU');

  const PartyRole(this.displayName);
  final String displayName;
}

enum CaseCategory {
  defamation('Defamation'),
  corruption('Corruption'),
  civil('Civil'),
  criminal('Criminal'),
  constitutional('Constitutional'),
  administrative('Administrative');

  const CaseCategory(this.displayName);
  final String displayName;
}

/// Extension methods for extra functionality - because we're extra like that! 💁‍♀️
extension SearchItemExtensions on SearchItem {
  /// Get clean case number without HTML tags
  String get cleanCaseNo => caseNo.replaceAll(RegExp(r'<[^>]*>'), '');

  /// Get clean parties without HTML tags
  String get cleanParties => parties.replaceAll(RegExp(r'<[^>]*>'), '');

  /// Get clean judge list without HTML tags
  String get cleanCorumJudge => corumJudge.replaceAll(RegExp(r'<[^>]*>'), '');

  /// Check if case involves specific person
  bool involvesParty(String partyName) =>
      cleanParties.toLowerCase().contains(partyName.toLowerCase());
}
