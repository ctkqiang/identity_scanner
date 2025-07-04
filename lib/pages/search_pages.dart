// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:identity_scanner/controller/get.controller.dart';
import 'package:identity_scanner/pages/show_result_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  // 法院级别选项
  final List<String> _courtLevels = [
    'ALL',
    'Mahkamah Tinggi',
    'Mahkamah Rayuan',
    'Mahkamah Persekutuan',
    'Mahkamah Sesyen',
  ];
  String _selectedCourtLevel = 'ALL';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    if (!_formKey.currentState!.validate()) return;

    // 关闭键盘
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 创建服务实例并调用搜索方法
      final service = EjudementService();
      final result = await service.getEJudgmentPortalSearchList(
        search: _searchController.text.trim(),
        jurisdictionType: _selectedCourtLevel,
      );

      if (!mounted) return;

      // 导航到结果页面
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultListPage(searchResult: result),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });

      // 显示错误时轻微震动反馈
      HapticFeedback.mediumImpact();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 获取屏幕尺寸
    final screenSize = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('eJudgment Search'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeInAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      // 标题和说明
                      const SizedBox(height: 20),
                      Hero(
                        tag: 'search_icon',
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.indigo.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.search_rounded,
                            size: 60,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Search Malaysian Court Judgments',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Enter a name, case number, or keyword to search',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 32),

                      // 搜索输入框
                      TextFormField(
                        controller: _searchController,
                        textCapitalization: TextCapitalization.characters,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                        decoration: InputDecoration(
                          labelText: 'SEARCH TERM',
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                          hintText:
                              'E.G. LIM AH KONG, ABC SDN BHD, CORRUPTION, DEFAMATION',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.indigo,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.indigo,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.indigo.shade200,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.indigo,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'PLEASE ENTER A SEARCH TERM';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // 法院级别下拉选择
                      DropdownButtonFormField<String>(
                        value: _selectedCourtLevel,
                        decoration: InputDecoration(
                          labelText: 'COURT LEVEL',
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.indigo,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.indigo.shade200,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.indigo,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down_circle,
                          color: Colors.indigo,
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          letterSpacing: 0.5,
                        ),
                        dropdownColor: Colors.white,
                        items: _courtLevels.map((String level) {
                          return DropdownMenuItem<String>(
                            value: level,
                            child: Text(level.toUpperCase()),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedCourtLevel = newValue;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 24),

                      // 搜索按钮
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.indigo.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _performSearch,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.indigo.shade200,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.search, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'SEARCH NOW',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      // 错误信息显示
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 16),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red.shade800,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(color: Colors.red.shade800),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.red.shade800,
                                  size: 18,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _errorMessage = null;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 100),

                      // 底部提示信息
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.copyright,
                                  size: 16,
                                  color: Colors.indigo,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '2025 Malaysian eJugement | Built by ctkqiang',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 4),
                            Text(
                              'This app is built dedicated to Malaysian Court with ❤️',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About eJudgment Search'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This application allows you to search for Malaysian court judgments.',
            ),
            SizedBox(height: 8),
            Text('You can search by:'),
            SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• Names (e.g., "Lim Ah Kong")'),
                  Text('• Company names (e.g., "ABC Sdn Bhd")'),
                  Text('• Case types (e.g., "Corruption", "Defamation")'),
                  Text('• Case numbers'),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text('You can also filter by court level using the dropdown menu.'),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }
}
