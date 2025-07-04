// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  double _textScale = 1.0;
  bool _isBookmarked = false;

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
                  widget.caseNo,
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
                    // Case Information Card
                    Card(
                      elevation: 8,
                      shadowColor: Colors.indigo.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.white, Colors.indigo.shade50],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
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
                                    child: Icon(
                                      Icons.gavel,
                                      color: Colors.indigo.shade700,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Case Information',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.indigo.shade800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              _buildInfoRow(
                                'Case Number',
                                widget.caseNo,
                                Icons.tag,
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                'Parties',
                                widget.parties,
                                Icons.people,
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                'Judge',
                                widget.judge,
                                Icons.person,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Text Scale Controls
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

                    // Full Text Card
                    Card(
                      elevation: 4,
                      shadowColor: Colors.grey.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: SelectableText(
                          widget.fullText,
                          style: TextStyle(
                            fontSize: 16 * _textScale,
                            height: 1.6,
                            color: Colors.black87,
                            fontFamily: 'Georgia',
                          ),
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
    return Row(
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
    );
  }
}
