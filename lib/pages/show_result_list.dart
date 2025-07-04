import 'package:flutter/material.dart';
import 'package:identity_scanner/controller/get.controller.dart';
import 'package:identity_scanner/models/ejudgmentresponse.models.dart';
import 'package:identity_scanner/models/search_item.models.dart';
import 'package:identity_scanner/pages/show_file.dart';
import 'package:identity_scanner/pages/show_full.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultListPage extends StatefulWidget {
  final EJudgmentResponse searchResult;

  const ResultListPage({super.key, required this.searchResult});

  @override
  State<ResultListPage> createState() => _ResultListPageState();
}

class _ResultListPageState extends State<ResultListPage> {
  late List<SearchItem> _filteredResults;
  String _filterCourtLevel = 'All';
  bool _showDefamationOnly = false;
  bool _showCorruptionOnly = false;

  void openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw '❌ Could not launch $url';
    }
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
    _filteredResults = widget.searchResult.data.listOfSearchItem;
  }

  void _applyFilters() {
    setState(() {
      _filteredResults = widget.searchResult.data.listOfSearchItem;

      // 应用法院级别筛选
      if (_filterCourtLevel != 'All') {
        _filteredResults = _filteredResults
            .where((item) => item.courtLevel == _filterCourtLevel)
            .toList();
      }

      // 应用案件类型筛选
      if (_showDefamationOnly) {
        _filteredResults = _filteredResults
            .where((item) => item.isDefamationCase)
            .toList();
      }

      if (_showCorruptionOnly) {
        _filteredResults = _filteredResults
            .where((item) => item.isCorruptionCase)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // 结果统计信息
          Container(
            color: Colors.indigo.shade50,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Found ${widget.searchResult.data.totalRecord} results',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Page 1 of ${widget.searchResult.data.totalPage}',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),

          // 筛选标签显示
          if (_filterCourtLevel != 'All' ||
              _showDefamationOnly ||
              _showCorruptionOnly)
            Container(
              color: Colors.grey.shade100,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Text(
                    'Filters: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  if (_filterCourtLevel != 'All')
                    _buildFilterChip(_filterCourtLevel),
                  if (_showDefamationOnly) _buildFilterChip('Defamation'),
                  if (_showCorruptionOnly) _buildFilterChip('Corruption'),
                ],
              ),
            ),

          // 结果列表
          Expanded(
            child: _filteredResults.isEmpty
                ? const Center(
                    child: Text(
                      'No results match your filters',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredResults.length,
                    itemBuilder: (context, index) {
                      final item = _filteredResults[index];
                      return _buildResultCard(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        backgroundColor: Colors.indigo.shade100,
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: () {
          setState(() {
            if (label == _filterCourtLevel) {
              _filterCourtLevel = 'All';
            } else if (label == 'Defamation') {
              _showDefamationOnly = false;
            } else if (label == 'Corruption') {
              _showCorruptionOnly = false;
            }
            _applyFilters();
          });
        },
      ),
    );
  }

  Widget _buildResultCard(SearchItem item) {
    // 清理HTML标签
    final cleanCaseNo = item.cleanCaseNo;
    final cleanParties = item.cleanParties;
    final cleanJudges = item.cleanCorumJudge;

    // 格式化日期
    final dateOfResult = item.parsedDateOfResult != null
        ? '${item.parsedDateOfResult!.day}/${item.parsedDateOfResult!.month}/${item.parsedDateOfResult!.year}'
        : 'N/A';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.all(16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 法院级别标签
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getCourtLevelColor(item.courtLevel),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                item.courtLevel,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // 案件编号
            Text(
              cleanCaseNo,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 13),

            // 当事人信息
            Text(
              cleanPartiesF(cleanParties),
              style: const TextStyle(fontSize: 14),
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 13),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(dateOfResult, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 16),
              const Icon(Icons.gavel, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.judge,
                  style: const TextStyle(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        children: [
          const Divider(),
          // 案件关键词
          if (item.keyWord.isNotEmpty) ...[
            const Text(
              'Keywords:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(item.keyWord),
            const SizedBox(height: 12),
          ],

          // 法官信息
          if (cleanJudges.isNotEmpty) ...[
            const Text(
              'Judges:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(cleanJudges),
            const SizedBox(height: 12),
          ],

          // 相关文档
          if (item.listOfAPDoc.isNotEmpty) ...[
            const Text(
              'Related Documents:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...item.listOfAPDoc.map(
              (doc) => GestureDetector(
                onTap: () {
                  EjudementService ejudementService = EjudementService();
                  String url = ejudementService.openCaseDocument(
                    doc.documentID,
                  );

                  openUrl(url);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.description,
                        size: 16,
                        color: Colors.indigo,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          doc.apDocName,
                          style: const TextStyle(
                            color: Colors.indigo,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],

          // 底部操作按钮
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // OutlinedButton.icon(
              //   icon: const Icon(Icons.share, size: 16),
              //   label: const Text('Share'),
              //   onPressed: () {

              //   },
              // ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.visibility, size: 16),
                label: const Text('View Full'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowFullPage(
                        caseNo: item.caseNo,
                        parties: item.parties,
                        judge: item.judge,
                        fullText: item.keyWord,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCourtLevelColor(String courtLevel) {
    switch (courtLevel) {
      case 'Mahkamah Persekutuan':
        return Colors.red.shade700;
      case 'Mahkamah Rayuan':
        return Colors.orange.shade700;
      case 'Mahkamah Tinggi':
        return Colors.blue.shade700;
      case 'Mahkamah Sesyen':
        return Colors.green.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filter Results'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Court Level',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildFilterOption('All', _filterCourtLevel, (value) {
                        setDialogState(() => _filterCourtLevel = value);
                      }),
                      _buildFilterOption(
                        'Mahkamah Persekutuan',
                        _filterCourtLevel,
                        (value) {
                          setDialogState(() => _filterCourtLevel = value);
                        },
                      ),
                      _buildFilterOption('Mahkamah Rayuan', _filterCourtLevel, (
                        value,
                      ) {
                        setDialogState(() => _filterCourtLevel = value);
                      }),
                      _buildFilterOption('Mahkamah Tinggi', _filterCourtLevel, (
                        value,
                      ) {
                        setDialogState(() => _filterCourtLevel = value);
                      }),
                      _buildFilterOption('Mahkamah Sesyen', _filterCourtLevel, (
                        value,
                      ) {
                        setDialogState(() => _filterCourtLevel = value);
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Case Type',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    title: const Text('Defamation Cases'),
                    value: _showDefamationOnly,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                    onChanged: (value) {
                      setDialogState(() {
                        _showDefamationOnly = value ?? false;
                        if (_showDefamationOnly) {
                          _showCorruptionOnly = false;
                        }
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Corruption Cases'),
                    value: _showCorruptionOnly,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                    onChanged: (value) {
                      setDialogState(() {
                        _showCorruptionOnly = value ?? false;
                        if (_showCorruptionOnly) {
                          _showDefamationOnly = false;
                        }
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Reset'),
                  onPressed: () {
                    setDialogState(() {
                      _filterCourtLevel = 'All';
                      _showDefamationOnly = false;
                      _showCorruptionOnly = false;
                    });
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _applyFilters();
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildFilterOption(
    String label,
    String groupValue,
    Function(String) onSelected,
  ) {
    final isSelected = label == groupValue;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.indigo.shade100,
      onSelected: (selected) {
        if (selected) {
          onSelected(label);
        }
      },
    );
  }
}
