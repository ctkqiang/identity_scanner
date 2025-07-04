// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' show parse;

class ShowFullPage extends StatefulWidget {
  final String caseNo;
  final String parties;
  final String judge;
  final String fullText;

  const ShowFullPage({
    super.key,
    required this.caseNo,
    required this.parties,
    required this.judge,
    required this.fullText,
  });

  @override
  State<ShowFullPage> createState() => _ShowFullPageState();
}

class _ShowFullPageState extends State<ShowFullPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  double _textScale = 1.0;
  bool _isBookmarked = false;

  String stripHtmlTags(String htmlString) {
    return parse(htmlString).documentElement?.text.trim() ?? '';
  }

  String cleanPartiesF(String text) {
    final pattern = RegExp(
      r'(PLAINTIF|DEFENDAN|PERAYU|RESPONDEN|PEMOHON)(.*?)(?=PLAINTIF|DEFENDAN|PERAYU|RESPONDEN|PEMOHON|$)',
      caseSensitive: false,
    );

    final buffer = StringBuffer();

    for (final match in pattern.allMatches(text)) {
      final role = match.group(1)?.toUpperCase();
      final name = match.group(2)?.trim();
      if (role != null && name != null && name.isNotEmpty) {
        buffer.writeln('$role: $name');
      }
    }

    return buffer.toString().trim();
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.indigo.shade600,
                    Colors.indigo.shade800,
                    Colors.deepPurple.shade700,
                  ],
                ),
              ),
              child: FlexibleSpaceBar(
                title: Text(
                  stripHtmlTags(widget.caseNo),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isBookmarked = !_isBookmarked;
                  });
                  HapticFeedback.lightImpact();
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionCard(
                      icon: Icons.gavel,
                      title: 'Case Information',
                      children: [
                        _buildInfoRow(
                          'Case Number',
                          stripHtmlTags(widget.caseNo),
                          Icons.tag,
                        ),
                        _buildInfoRow(
                          'Parties',
                          stripHtmlTags(cleanPartiesF(widget.parties)),
                          Icons.people,
                        ),
                        _buildInfoRow(
                          'Judge',
                          stripHtmlTags(widget.judge),
                          Icons.person,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.article, color: Colors.indigo.shade700),
                            const SizedBox(width: 8),
                            Text(
                              'Full Judgment Text',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo.shade800,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.text_decrease),
                              onPressed: () {
                                setState(() {
                                  _textScale = (_textScale - 0.1).clamp(
                                    0.8,
                                    1.4,
                                  );
                                });
                              },
                            ),
                            Text(
                              '${(_textScale * 100).round()}%',
                              style: const TextStyle(fontSize: 12),
                            ),
                            IconButton(
                              icon: const Icon(Icons.text_increase),
                              onPressed: () {
                                setState(() {
                                  _textScale = (_textScale + 0.1).clamp(
                                    0.8,
                                    1.4,
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSectionCard(
                      icon: Icons.description,
                      title: 'Judgment Text',
                      child: SelectableText(
                        stripHtmlTags(widget.fullText),
                        style: TextStyle(
                          fontSize: 16 * _textScale,
                          height: 1.6,
                          color: Colors.black87,
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.indigo.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    List<Widget>? children,
    Widget? child,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.indigo.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.indigo.shade700, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (children != null) ...children,
            if (child != null) child,
          ],
        ),
      ),
    );
  }
}
